//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2017-2018 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

let localhostPickPort = try! SocketAddress.makeAddressResolvingHost("127.0.0.1", port: 0)

import NIO
import NIOHTTP1
import Foundation
import AtomicCounter
import Dispatch

private final class SimpleHTTPServer: ChannelInboundHandler {
    typealias InboundIn = HTTPServerRequestPart
    typealias OutboundOut = HTTPServerResponsePart

    private let bodyLength = 100
    private let numberOfAdditionalHeaders = 3

    private var responseHead: HTTPResponseHead {
        var head = HTTPResponseHead(version: HTTPVersion(major: 1, minor: 1), status: .ok)
        head.headers.add(name: "Content-Length", value: "\(self.bodyLength)")
        for i in 0..<self.numberOfAdditionalHeaders {
            head.headers.add(name: "X-Random-Extra-Header", value: "\(i)")
        }
        return head
    }

    private func responseBody(allocator: ByteBufferAllocator) -> ByteBuffer {
        var buffer = allocator.buffer(capacity: self.bodyLength)
        for i in 0..<self.bodyLength {
            buffer.writeInteger(UInt8(i % Int(UInt8.max)))
        }
        return buffer
    }

    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        if case .head(let req) = self.unwrapInboundIn(data), req.uri == "/allocation-test-1" {
            context.write(self.wrapOutboundOut(.head(self.responseHead)), promise: nil)
            context.write(self.wrapOutboundOut(.body(.byteBuffer(self.responseBody(allocator: context.channel.allocator)))), promise: nil)
            context.writeAndFlush(self.wrapOutboundOut(.end(nil)), promise: nil)
        }
    }
}

private struct PingPongFailure: Error, CustomStringConvertible {
    public var description: String

    init(problem: String) {
        self.description = problem
    }
}

private final class PingHandler: ChannelInboundHandler {
    typealias InboundIn = ByteBuffer
    typealias OutboundOut = ByteBuffer

    private var pingBuffer: ByteBuffer!
    private let numberOfRequests: Int
    private var remainingNumberOfRequests: Int
    private let allDone: EventLoopPromise<Void>
    public static let pingCode: UInt8 = 0xbe

    public init(numberOfRequests: Int, eventLoop: EventLoop) {
        self.numberOfRequests = numberOfRequests
        self.remainingNumberOfRequests = numberOfRequests
        self.allDone = eventLoop.makePromise()
    }

    public func channelActive(context: ChannelHandlerContext) {
        self.pingBuffer = context.channel.allocator.buffer(capacity: 1)
        self.pingBuffer.writeInteger(PingHandler.pingCode)

        context.writeAndFlush(self.wrapOutboundOut(self.pingBuffer), promise: nil)
    }

    public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        var buf = self.unwrapInboundIn(data)
        if buf.readableBytes == 1 &&
            buf.readInteger(as: UInt8.self) == PongHandler.pongCode {
            if self.remainingNumberOfRequests > 0 {
                self.remainingNumberOfRequests -= 1
                context.writeAndFlush(self.wrapOutboundOut(self.pingBuffer), promise: nil)
            } else {
                context.close(promise: self.allDone)
            }
        } else {
            context.close(promise: nil)
            self.allDone.fail(PingPongFailure(problem: "wrong buffer received: \(buf.debugDescription)"))
        }
    }

    public func wait() throws {
        try self.allDone.futureResult.wait()
    }
}

private final class PongHandler: ChannelInboundHandler {
    typealias InboundIn = UInt8
    typealias OutboundOut = ByteBuffer

    private var pongBuffer: ByteBuffer!
    public static let pongCode: UInt8 = 0xef

    public func handlerAdded(context: ChannelHandlerContext) {
        self.pongBuffer = context.channel.allocator.buffer(capacity: 1)
        self.pongBuffer.writeInteger(PongHandler.pongCode)
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        let data = self.unwrapInboundIn(data)
        if data == PingHandler.pingCode {
            context.writeAndFlush(NIOAny(self.pongBuffer), promise: nil)
        } else {
            context.close(promise: nil)
        }
    }

    func errorCaught(context: ChannelHandlerContext, error: Error) {
        context.close(promise: nil)
    }
}

private final class PongDecoder: ByteToMessageDecoder {
    typealias InboundOut = UInt8

    public func decode(context: ChannelHandlerContext, buffer: inout ByteBuffer) -> DecodingState {
        if let ping = buffer.readInteger(as: UInt8.self) {
            context.fireChannelRead(self.wrapInboundOut(ping))
            return .continue
        } else {
            return .needMoreData
        }
    }

    public func decodeLast(context: ChannelHandlerContext, buffer: inout ByteBuffer, seenEOF: Bool) throws -> DecodingState {
        return .needMoreData
    }
}

private func withAutoReleasePool<T>(_ execute: () throws -> T) rethrows -> T {
    #if os(Linux)
    return try execute()
    #else
    return try autoreleasepool {
        try execute()
    }
    #endif
}

@_cdecl("swift_main")
public func swiftMain() -> Int {
    final class RepeatedRequests: ChannelInboundHandler {
        typealias InboundIn = HTTPClientResponsePart
        typealias OutboundOut = HTTPClientRequestPart

        private let numberOfRequests: Int
        private var remainingNumberOfRequests: Int
        private let isDonePromise: EventLoopPromise<Int>
        static var requestHead: HTTPRequestHead {
            var head = HTTPRequestHead(version: HTTPVersion(major: 1, minor: 1), method: .GET, uri: "/allocation-test-1")
            head.headers.add(name: "Host", value: "foo-\(ObjectIdentifier(self)).com")
            return head
        }

        init(numberOfRequests: Int, eventLoop: EventLoop) {
            self.remainingNumberOfRequests = numberOfRequests
            self.numberOfRequests = numberOfRequests
            self.isDonePromise = eventLoop.makePromise()
        }

        func wait() throws -> Int {
            let reqs = try self.isDonePromise.futureResult.wait()
            precondition(reqs == self.numberOfRequests)
            return reqs
        }

        func errorCaught(context: ChannelHandlerContext, error: Error) {
            context.channel.close(promise: nil)
            self.isDonePromise.fail(error)
        }

        func channelRead(context: ChannelHandlerContext, data: NIOAny) {
            let respPart = self.unwrapInboundIn(data)
            if case .end(nil) = respPart {
                if self.remainingNumberOfRequests <= 0 {
                    context.channel.close().map { self.numberOfRequests - self.remainingNumberOfRequests }.cascade(to: self.isDonePromise)
                } else {
                    self.remainingNumberOfRequests -= 1
                    context.write(self.wrapOutboundOut(.head(RepeatedRequests.requestHead)), promise: nil)
                    context.writeAndFlush(self.wrapOutboundOut(.end(nil)), promise: nil)
                }
            }
        }
    }

    func measure(_ fn: () -> Int) -> [[String: Int]] {
        func measureOne(_ fn: () -> Int) -> [String: Int] {
            AtomicCounter.reset_free_counter()
            AtomicCounter.reset_malloc_counter()
            withAutoReleasePool {
                _ = fn()
            }
            usleep(100_000) // allocs/frees happen on multiple threads, allow some cool down time
            let frees = AtomicCounter.read_free_counter()
            let mallocs = AtomicCounter.read_malloc_counter()
            return ["total_allocations": mallocs,
                    "remaining_allocations": mallocs - frees]
        }

        _ = measureOne(fn) /* pre-heat and throw away */
        usleep(100_000) // allocs/frees happen on multiple threads, allow some cool down time
        var measurements: [[String: Int]] = []
        for _ in 0..<10 {
            measurements.append(measureOne(fn))
        }
        return measurements
    }

    func measureAndPrint(desc: String, fn: () -> Int) -> Void {
        let measurements = measure(fn)
        for k in measurements[0].keys {
            let vs = measurements.map { $0[k]! }
            print("\(desc).\(k): \(vs.min() ?? -1)")
        }
        print("DEBUG: \(measurements)")
    }

    func doRequests(group: EventLoopGroup, number numberOfRequests: Int) throws -> Int {
        let serverChannel = try ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelInitializer { channel in
                channel.pipeline.configureHTTPServerPipeline(withPipeliningAssistance: true,
                                                             withErrorHandling: false).flatMap {
                    channel.pipeline.addHandler(SimpleHTTPServer())
                }
            }.bind(to: localhostPickPort).wait()

        defer {
            try! serverChannel.close().wait()
        }


        let repeatedRequestsHandler = RepeatedRequests(numberOfRequests: numberOfRequests, eventLoop: group.next())

        let clientChannel = try ClientBootstrap(group: group)
            .channelInitializer { channel in
                channel.pipeline.addHTTPClientHandlers().flatMap {
                    channel.pipeline.addHandler(repeatedRequestsHandler)
                }
            }
            .channelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .connect(to: serverChannel.localAddress!)
            .wait()

        clientChannel.write(NIOAny(HTTPClientRequestPart.head(RepeatedRequests.requestHead)), promise: nil)
        try clientChannel.writeAndFlush(NIOAny(HTTPClientRequestPart.end(nil))).wait()
        return try repeatedRequestsHandler.wait()
    }

    func doPingPongRequests(group: EventLoopGroup, number numberOfRequests: Int) throws -> Int {
        let serverChannel = try ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.recvAllocator, value: FixedSizeRecvByteBufferAllocator(capacity: 4))
            .childChannelInitializer { channel in
                channel.pipeline.addHandler(ByteToMessageHandler(PongDecoder())).flatMap {
                    channel.pipeline.addHandler(PongHandler())
                }
            }.bind(host: "127.0.0.1", port: 0).wait()

        defer {
            try! serverChannel.close().wait()
        }

        let pingHandler = PingHandler(numberOfRequests: numberOfRequests, eventLoop: group.next())
        _ = try ClientBootstrap(group: group)
            .channelInitializer { channel in
                channel.pipeline.addHandler(pingHandler)
            }
            .channelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .channelOption(ChannelOptions.recvAllocator, value: FixedSizeRecvByteBufferAllocator(capacity: 4))
            .connect(to: serverChannel.localAddress!)
            .wait()

        try pingHandler.wait()
        return numberOfRequests
    }

    let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    defer {
        try! group.syncShutdownGracefully()
    }

    measureAndPrint(desc: "1000_reqs_1_conn") {
        let numberDone = try! doRequests(group: group, number: 1000)
        precondition(numberDone == 1000)
        return numberDone
    }

    measureAndPrint(desc: "1_reqs_1000_conn") {
        var numberDone = 1
        for _ in 0..<1000 {
            let newDones = try! doRequests(group: group, number: 1)
            precondition(newDones == 1)
            numberDone += newDones
        }
        return numberDone
    }

    measureAndPrint(desc: "ping_pong_1000_reqs_1_conn") {
        let numberDone = try! doPingPongRequests(group: group, number: 1000)
        precondition(numberDone == 1000)
        return numberDone
    }

    measureAndPrint(desc: "bytebuffer_lots_of_rw") {
        let dispatchData = ("A" as StaticString).withUTF8Buffer { ptr in
            DispatchData(bytes: UnsafeRawBufferPointer(ptr))
        }
        var buffer = ByteBufferAllocator().buffer(capacity: 7 * 1000)
        let foundationData = "A".data(using: .utf8)!
        @inline(never)
        func doWrites(buffer: inout ByteBuffer) {
            /* these ones are zero allocations */
            // buffer.writeBytes(foundationData) // see SR-7542
            buffer.writeBytes([0x41])
            buffer.writeBytes("A".utf8)
            buffer.writeString("A")
            buffer.writeStaticString("A")
            buffer.writeInteger(0x41, as: UInt8.self)

            /* those down here should be one allocation each (on Linux) */
            buffer.writeBytes(dispatchData) // see https://bugs.swift.org/browse/SR-9597
        }
        @inline(never)
        func doReads(buffer: inout ByteBuffer) {
            /* these ones are zero allocations */
            let val = buffer.readInteger(as: UInt8.self)
            precondition(0x41 == val, "\(val!)")
            var slice = buffer.readSlice(length: 1)
            let sliceVal = slice!.readInteger(as: UInt8.self)
            precondition(0x41 == sliceVal, "\(sliceVal!)")
            buffer.withUnsafeReadableBytes { ptr in
                precondition(ptr[0] == 0x41)
            }

            /* those down here should be one allocation each */
            let arr = buffer.readBytes(length: 1)
            precondition([0x41] == arr!, "\(arr!)")
            let str = buffer.readString(length: 1)
            precondition("A" == str, "\(str!)")
        }
        for _ in 0..<1000  {
            doWrites(buffer: &buffer)
            doReads(buffer: &buffer)
        }
        return buffer.readableBytes
    }

    measureAndPrint(desc: "future_lots_of_callbacks") {
        struct MyError: Error { }
        @inline(never)
        func doThenAndFriends(loop: EventLoop) {
            let p = loop.makePromise(of: Int.self)
            let f = p.futureResult.flatMap { (r: Int) -> EventLoopFuture<Int> in
                // This call allocates a new Future, and
                // so does flatMap(), so this is two Futures.
                return loop.makeSucceededFuture(r + 1)
            }.flatMapThrowing { (r: Int) -> Int in
                // flatMapThrowing allocates a new Future, and calls `flatMap`
                // which also allocates, so this is two.
                return r + 2
            }.map { (r: Int) -> Int in
                // map allocates a new future, and calls `flatMap` which
                // also allocates, so this is two.
                return r + 2
            }.flatMapThrowing { (r: Int) -> Int in
                // flatMapThrowing allocates a future on the error path and
                // calls `flatMap`, which also allocates, so this is two.
                throw MyError()
            }.flatMapError { (err: Error) -> EventLoopFuture<Int> in
                // This call allocates a new Future, and so does flatMapError,
                // so this is two Futures.
                return loop.makeFailedFuture(err)
            }.flatMapErrorThrowing { (err: Error) -> Int in
                // flatMapError allocates a new Future, and calls flatMapError,
                // so this is two Futures
                throw err
            }.recover { (err: Error) -> Int in
                // recover allocates a future, and calls flatMapError, so
                // this is two Futures.
                return 1
            }
            p.succeed(0)
            
            // Wait also allocates a lock.
            _ = try! f.wait()
        }
        @inline(never)
        func doAnd(loop: EventLoop) {
            let p1 = loop.makePromise(of: Int.self)
            let p2 = loop.makePromise(of: Int.self)
            let p3 = loop.makePromise(of: Int.self)

            // Each call to and() allocates a Future. The calls to
            // and(result:) allocate two.
    
            let f = p1.futureResult
                        .and(p2.futureResult)
                        .and(p3.futureResult)
                        .and(value: 1)
                        .and(value: 1)

            p1.succeed(1)
            p2.succeed(1)
            p3.succeed(1)
            _ = try! f.wait()
        }
        let el = EmbeddedEventLoop()
        for _ in 0..<1000  {
            doThenAndFriends(loop: el)
            doAnd(loop: el)
        }
        return 1000
    }

    measureAndPrint(desc: "scheduling_10000_executions") {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        let loop = group.next()
        let dg = DispatchGroup()

        try! loop.submit {
            for _ in 0..<10_000 {
                dg.enter()
                loop.execute { dg.leave() }
            }
        }.wait()
        dg.wait()
        try! group.syncShutdownGracefully()
        return 10_000
    }

    return 0
}
