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

import XCTest
@testable import NIO

class EmbeddedChannelTest: XCTestCase {
    func testWriteOutboundByteBuffer() throws {
        let channel = EmbeddedChannel()
        var buf = channel.allocator.buffer(capacity: 1024)
        buf.writeString("hello")
        
        XCTAssertTrue(try channel.writeOutbound(buf).isFull)
        XCTAssertTrue(try channel.finish().hasLeftOvers)
        XCTAssertNoThrow(XCTAssertEqual(buf, try channel.readOutbound()))
        XCTAssertNoThrow(XCTAssertNil(try channel.readOutbound()))
        XCTAssertNoThrow(XCTAssertNil(try channel.readInbound()))
    }

    func testWriteInboundByteBuffer() throws {
        let channel = EmbeddedChannel()
        var buf = channel.allocator.buffer(capacity: 1024)
        buf.writeString("hello")

        XCTAssertTrue(try channel.writeInbound(buf).isFull)
        XCTAssertTrue(try channel.finish().hasLeftOvers)
        XCTAssertNoThrow(XCTAssertEqual(buf, try channel.readInbound()))
        XCTAssertNoThrow(XCTAssertNil(try channel.readInbound()))
        XCTAssertNoThrow(XCTAssertNil(try channel.readOutbound()))
    }

    func testWriteInboundByteBufferReThrow() throws {
        let channel = EmbeddedChannel()
        _ = try channel.pipeline.addHandler(ExceptionThrowingInboundHandler()).wait()
        do {
            try channel.writeInbound("msg")
            XCTFail()
        } catch let err {
            XCTAssertEqual(ChannelError.operationUnsupported, err as! ChannelError)
        }
        XCTAssertTrue(try channel.finish().isClean)
    }

    func testWriteOutboundByteBufferReThrow() throws {
        let channel = EmbeddedChannel()
        _ = try channel.pipeline.addHandler(ExceptionThrowingOutboundHandler()).wait()
        do {
            try channel.writeOutbound("msg")
            XCTFail()
        } catch let err {
            XCTAssertEqual(ChannelError.operationUnsupported, err as! ChannelError)
        }
        XCTAssertTrue(try channel.finish().isClean)
    }

    func testReadOutboundWrongTypeThrows() {
        let channel = EmbeddedChannel()
        XCTAssertTrue(try channel.writeOutbound("hello").isFull)
        do {
            _ = try channel.readOutbound(as: Int.self)
            XCTFail()
        } catch let error as EmbeddedChannel.WrongTypeError {
            let expectedError = EmbeddedChannel.WrongTypeError(expected: Int.self, actual: String.self)
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail()
        }
    }

    func testReadInboundWrongTypeThrows() {
        let channel = EmbeddedChannel()
        XCTAssertTrue(try channel.writeInbound("hello").isFull)
        do {
            _ = try channel.readInbound(as: Int.self)
            XCTFail()
        } catch let error as EmbeddedChannel.WrongTypeError {
            let expectedError = EmbeddedChannel.WrongTypeError(expected: Int.self, actual: String.self)
            XCTAssertEqual(error, expectedError)
        } catch {
            XCTFail()
        }
    }

    func testWrongTypesWithFastpathTypes() {
        let channel = EmbeddedChannel()
        defer {
            XCTAssertNoThrow(XCTAssertTrue(try channel.finish().isClean))
        }

        let buffer = channel.allocator.buffer(capacity: 0)
        let ioData = IOData.byteBuffer(buffer)
        let fileHandle = NIOFileHandle(descriptor: -1)
        let fileRegion = FileRegion(fileHandle: fileHandle, readerIndex: 0, endIndex: 0)
        defer {
            XCTAssertNoThrow(_ = try fileHandle.takeDescriptorOwnership())
        }

        XCTAssertTrue(try channel.writeOutbound(buffer).isFull)
        XCTAssertTrue(try channel.writeOutbound(ioData).isFull)
        XCTAssertTrue(try channel.writeOutbound(fileHandle).isFull)
        XCTAssertTrue(try channel.writeOutbound(fileRegion).isFull)
        XCTAssertTrue(try channel.writeOutbound(
            AddressedEnvelope<ByteBuffer>(remoteAddress: SocketAddress(ipAddress: "1.2.3.4", port: 5678),
                                          data: buffer)).isFull)
        XCTAssertTrue(try channel.writeOutbound(buffer).isFull)
        XCTAssertTrue(try channel.writeOutbound(ioData).isFull)
        XCTAssertTrue(try channel.writeOutbound(fileRegion).isFull)


        XCTAssertTrue(try channel.writeInbound(buffer).isFull)
        XCTAssertTrue(try channel.writeInbound(ioData).isFull)
        XCTAssertTrue(try channel.writeInbound(fileHandle).isFull)
        XCTAssertTrue(try channel.writeInbound(fileRegion).isFull)
        XCTAssertTrue(try channel.writeInbound(
            AddressedEnvelope<ByteBuffer>(remoteAddress: SocketAddress(ipAddress: "1.2.3.4", port: 5678),
                                          data: buffer)).isFull)
        XCTAssertTrue(try channel.writeInbound(buffer).isFull)
        XCTAssertTrue(try channel.writeInbound(ioData).isFull)
        XCTAssertTrue(try channel.writeInbound(fileRegion).isFull)

        func check<Expected, Actual>(expected: Expected.Type,
                                     actual: Actual.Type,
                                     file: StaticString = #file,
                                     line: UInt = #line) {
            do {
                _ = try channel.readOutbound(as: Expected.self)
                XCTFail("this should have failed", file: file, line: line)
            } catch let error as EmbeddedChannel.WrongTypeError {
                let expectedError = EmbeddedChannel.WrongTypeError(expected: Expected.self, actual: Actual.self)
                XCTAssertEqual(error, expectedError, file: file, line: line)
            } catch {
                XCTFail("unexpected error: \(error)", file: file, line: line)
            }

            do {
                _ = try channel.readInbound(as: Expected.self)
                XCTFail("this should have failed", file: file, line: line)
            } catch let error as EmbeddedChannel.WrongTypeError {
                let expectedError = EmbeddedChannel.WrongTypeError(expected: Expected.self, actual: Actual.self)
                XCTAssertEqual(error, expectedError, file: file, line: line)
            } catch {
                XCTFail("unexpected error: \(error)", file: file, line: line)
            }
        }

        check(expected: Never.self, actual: IOData.self)
        check(expected: Never.self, actual: IOData.self)
        check(expected: Never.self, actual: NIOFileHandle.self)
        check(expected: Never.self, actual: IOData.self)
        check(expected: Never.self, actual: AddressedEnvelope<ByteBuffer>.self)
        check(expected: NIOFileHandle.self, actual: IOData.self)
        check(expected: NIOFileHandle.self, actual: IOData.self)
        check(expected: ByteBuffer.self, actual: IOData.self)
    }

    func testCloseMultipleTimesThrows() throws {
        let channel = EmbeddedChannel()
        XCTAssertTrue(try channel.finish().isClean)

        // Close a second time. This must fail.
        do {
            try _ = channel.close().wait()
            XCTFail("Second close succeeded")
        } catch ChannelError.alreadyClosed {
            // Nothing to do here.
        }
    }

    func testCloseOnInactiveIsOk() throws {
        let channel = EmbeddedChannel()
        let inactiveHandler = CloseInChannelInactiveHandler()
        _ = try channel.pipeline.addHandler(inactiveHandler).wait()
        XCTAssertTrue(try channel.finish().isClean)

        // channelInactive should fire only once.
        XCTAssertEqual(inactiveHandler.inactiveNotifications, 1)
    }

    func testEmbeddedLifecycle() throws {
        let handler = ChannelLifecycleHandler()
        XCTAssertEqual(handler.currentState, .unregistered)

        let channel = EmbeddedChannel(handler: handler)

        XCTAssertEqual(handler.currentState, .registered)
        XCTAssertFalse(channel.isActive)

        _ = try channel.connect(to: try SocketAddress(unixDomainSocketPath: "/fake")).wait()
        XCTAssertEqual(handler.currentState, .active)
        XCTAssertTrue(channel.isActive)

        XCTAssertTrue(try channel.finish().isClean)
        XCTAssertEqual(handler.currentState, .unregistered)
        XCTAssertFalse(channel.isActive)
    }

    private final class ExceptionThrowingInboundHandler : ChannelInboundHandler {
        typealias InboundIn = String

        public func channelRead(context: ChannelHandlerContext, data: NIOAny) {
            context.fireErrorCaught(ChannelError.operationUnsupported)
        }

    }

    private final class ExceptionThrowingOutboundHandler : ChannelOutboundHandler {
        typealias OutboundIn = String
        typealias OutboundOut = Never

        public func write(context: ChannelHandlerContext, data: NIOAny, promise: EventLoopPromise<Void>?) {
            promise!.fail(ChannelError.operationUnsupported)
        }
    }

    private final class CloseInChannelInactiveHandler: ChannelInboundHandler {
        typealias InboundIn = ByteBuffer
        public var inactiveNotifications = 0

        public func channelInactive(context: ChannelHandlerContext) {
            inactiveNotifications += 1
            context.close(promise: nil)
        }
    }

    func testEmbeddedChannelAndPipelineAndChannelCoreShareTheEventLoop() {
        let channel = EmbeddedChannel()
        let pipelineEventLoop = channel.pipeline.eventLoop
        XCTAssert(pipelineEventLoop === channel.eventLoop)
        XCTAssert(pipelineEventLoop === (channel._channelCore as! EmbeddedChannelCore).eventLoop)
        XCTAssertTrue(try channel.finish().isClean)
    }

    func testSendingAnythingOnEmbeddedChannel() throws {
        let channel = EmbeddedChannel()
        let buffer = ByteBufferAllocator().buffer(capacity: 5)
        let socketAddress = try SocketAddress(unixDomainSocketPath: "path")
        let handle = NIOFileHandle(descriptor: 1)
        let fileRegion = FileRegion(fileHandle: handle, readerIndex: 1, endIndex: 2)
        defer {
            // fake descriptor, so shouldn't be closed.
            XCTAssertNoThrow(try handle.takeDescriptorOwnership())
        }
        try channel.writeAndFlush(1).wait()
        try channel.writeAndFlush("1").wait()
        try channel.writeAndFlush(buffer).wait()
        try channel.writeAndFlush(IOData.byteBuffer(buffer)).wait()
        try channel.writeAndFlush(IOData.fileRegion(fileRegion)).wait()
        try channel.writeAndFlush(AddressedEnvelope(remoteAddress: socketAddress, data: buffer)).wait()
    }

    func testActiveWhenConnectPromiseFiresAndInactiveWhenClosePromiseFires() throws {
        let channel = EmbeddedChannel()
        XCTAssertFalse(channel.isActive)
        let connectPromise = channel.eventLoop.makePromise(of: Void.self)
        connectPromise.futureResult.whenComplete { (_: Result<Void, Error>) in
            XCTAssertTrue(channel.isActive)
        }
        channel.connect(to: try SocketAddress(ipAddress: "127.0.0.1", port: 0), promise: connectPromise)
        try connectPromise.futureResult.wait()

        let closePromise = channel.eventLoop.makePromise(of: Void.self)
        closePromise.futureResult.whenComplete { (_: Result<Void, Error>) in
            XCTAssertFalse(channel.isActive)
        }

        channel.close(promise: closePromise)
        try closePromise.futureResult.wait()
    }

    func testWriteWithoutFlushDoesNotWrite() throws {
        let channel = EmbeddedChannel()

        var buf = ByteBufferAllocator().buffer(capacity: 1)
        buf.writeBytes([1])
        let writeFuture = channel.write(buf)
        XCTAssertNoThrow(XCTAssertNil(try channel.readOutbound()))
        XCTAssertFalse(writeFuture.isFulfilled)
        channel.flush()
        XCTAssertNoThrow(XCTAssertNotNil(try channel.readOutbound(as: ByteBuffer.self)))
        XCTAssertTrue(writeFuture.isFulfilled)
        XCTAssertNoThrow(XCTAssertTrue(try channel.finish().isClean))
    }

    func testSetLocalAddressAfterSuccessfulBind() throws {
        let channel = EmbeddedChannel()
        let bindPromise = channel.eventLoop.makePromise(of: Void.self)
        let socketAddress = try SocketAddress(ipAddress: "127.0.0.1", port: 0)
        channel.bind(to: socketAddress, promise: bindPromise)
        bindPromise.futureResult.whenComplete { _ in
            XCTAssertEqual(channel.localAddress, socketAddress)
        }
        try bindPromise.futureResult.wait()
    }

    func testSetRemoteAddressAfterSuccessfulConnect() throws {
        let channel = EmbeddedChannel()
        let connectPromise = channel.eventLoop.makePromise(of: Void.self)
        let socketAddress = try SocketAddress(ipAddress: "127.0.0.1", port: 0)
        channel.connect(to: socketAddress, promise: connectPromise)
        connectPromise.futureResult.whenComplete { _ in
            XCTAssertEqual(channel.remoteAddress, socketAddress)
        }
        try connectPromise.futureResult.wait()
    }

    func testUnprocessedOutboundUserEventFailsOnEmbeddedChannel() {
        let channel = EmbeddedChannel()
        XCTAssertThrowsError(try channel.triggerUserOutboundEvent("event").wait()) { (error: Error) in
            if let error = error as? ChannelError {
                XCTAssertEqual(ChannelError.operationUnsupported, error)
            } else {
                XCTFail("unexpected error: \(error)")
            }
        }
    }
}
