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

import NIOConcurrencyHelpers
@testable import NIO
import XCTest

private extension Channel {
    func waitForDatagrams(count: Int) throws -> [AddressedEnvelope<ByteBuffer>] {
        return try self.pipeline.context(name: "ByteReadRecorder").flatMap { context in
            if let future = (context.handler as? DatagramReadRecorder<ByteBuffer>)?.notifyForDatagrams(count) {
                return future
            }

            XCTFail("Could not wait for reads")
            return self.eventLoop.makeSucceededFuture([] as [AddressedEnvelope<ByteBuffer>])
        }.wait()
    }

    func readCompleteCount() throws -> Int {
        return try self.pipeline.context(name: "ByteReadRecorder").map { context in
            return (context.handler as! DatagramReadRecorder<ByteBuffer>).readCompleteCount
        }.wait()
    }

    func configureForRecvMmsg(messageCount: Int) throws {
        let totalBufferSize = messageCount * 2048

        try self.setOption(ChannelOptions.recvAllocator, value: FixedSizeRecvByteBufferAllocator(capacity: totalBufferSize)).flatMap {
            self.setOption(ChannelOptions.datagramVectorReadMessageCount, value: messageCount)
        }.wait()
    }
}

/// A class that records datagrams received and forwards them on.
///
/// Used extensively in tests to validate messaging expectations.
private class DatagramReadRecorder<DataType>: ChannelInboundHandler {
    typealias InboundIn = AddressedEnvelope<DataType>
    typealias InboundOut = AddressedEnvelope<DataType>

    enum State {
        case fresh
        case registered
        case active
    }

    var reads: [AddressedEnvelope<DataType>] = []
    var loop: EventLoop? = nil
    var state: State = .fresh

    var readWaiters: [Int: EventLoopPromise<[AddressedEnvelope<DataType>]>] = [:]
    var readCompleteCount = 0

    func channelRegistered(context: ChannelHandlerContext) {
        XCTAssertEqual(.fresh, self.state)
        self.state = .registered
        self.loop = context.eventLoop
    }

    func channelActive(context: ChannelHandlerContext) {
        XCTAssertEqual(.registered, self.state)
        self.state = .active
    }

    func channelRead(context: ChannelHandlerContext, data: NIOAny) {
        XCTAssertEqual(.active, self.state)
        let data = self.unwrapInboundIn(data)
        reads.append(data)

        if let promise = readWaiters.removeValue(forKey: reads.count) {
            promise.succeed(reads)
        }

        context.fireChannelRead(self.wrapInboundOut(data))
    }

    func channelReadComplete(context: ChannelHandlerContext) {
        self.readCompleteCount += 1
        context.fireChannelReadComplete()
    }

    func notifyForDatagrams(_ count: Int) -> EventLoopFuture<[AddressedEnvelope<DataType>]> {
        guard reads.count < count else {
            return loop!.makeSucceededFuture(.init(reads.prefix(count)))
        }

        readWaiters[count] = loop!.makePromise()
        return readWaiters[count]!.futureResult
    }
}

final class DatagramChannelTests: XCTestCase {
    private var group: MultiThreadedEventLoopGroup! = nil
    private var firstChannel: Channel! = nil
    private var secondChannel: Channel! = nil

    private func buildChannel(group: EventLoopGroup) throws -> Channel {
        return try DatagramBootstrap(group: group)
            .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .channelInitializer { channel in
                channel.pipeline.addHandler(DatagramReadRecorder<ByteBuffer>(), name: "ByteReadRecorder")
            }
            .bind(host: "127.0.0.1", port: 0)
            .wait()
    }

    override func setUp() {
        super.setUp()
        self.group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        self.firstChannel = try! buildChannel(group: group)
        self.secondChannel = try! buildChannel(group: group)
    }

    override func tearDown() {
        XCTAssertNoThrow(try self.group.syncShutdownGracefully())
        super.tearDown()
    }

    func testBasicChannelCommunication() throws {
        var buffer = self.firstChannel.allocator.buffer(capacity: 256)
        buffer.writeStaticString("hello, world!")
        let writeData = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)
        XCTAssertNoThrow(try self.firstChannel.writeAndFlush(NIOAny(writeData)).wait())

        let reads = try self.secondChannel.waitForDatagrams(count: 1)
        XCTAssertEqual(reads.count, 1)
        let read = reads.first!
        XCTAssertEqual(read.data, buffer)
        XCTAssertEqual(read.remoteAddress, self.firstChannel.localAddress!)
    }

    func testManyWrites() throws {
        var buffer = firstChannel.allocator.buffer(capacity: 256)
        buffer.writeStaticString("hello, world!")
        let writeData = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)
        var writeFutures: [EventLoopFuture<Void>] = []
        for _ in 0..<5 {
            writeFutures.append(self.firstChannel.write(NIOAny(writeData)))
        }
        self.firstChannel.flush()
        XCTAssertNoThrow(try EventLoopFuture.andAllSucceed(writeFutures, on: self.firstChannel.eventLoop).wait())

        let reads = try self.secondChannel.waitForDatagrams(count: 5)

        // These short datagrams should not have been dropped by the kernel.
        XCTAssertEqual(reads.count, 5)

        for read in reads {
            XCTAssertEqual(read.data, buffer)
            XCTAssertEqual(read.remoteAddress, self.firstChannel.localAddress!)
        }
    }

    func testConnectionFails() throws {
        do {
            try self.firstChannel.connect(to: self.secondChannel.localAddress!).wait()
        } catch ChannelError.operationUnsupported {
            // All is well
        } catch {
            XCTFail("Encountered error: \(error)")
        }
    }

    func testDatagramChannelHasWatermark() throws {
        _ = try self.firstChannel.setOption(ChannelOptions.writeBufferWaterMark, value: WriteBufferWaterMark(low: 1, high: 1024)).wait()

        var buffer = self.firstChannel.allocator.buffer(capacity: 256)
        buffer.writeBytes([UInt8](repeating: 5, count: 256))
        let writeData = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)
        XCTAssertTrue(self.firstChannel.isWritable)
        for _ in 0..<4 {
            // We submit to the loop here to make sure that we synchronously process the writes and checks
            // on writability.
            let writable: Bool = try self.firstChannel.eventLoop.submit {
                self.firstChannel.write(NIOAny(writeData), promise: nil)
                return self.firstChannel.isWritable
            }.wait()
            XCTAssertTrue(writable)
        }

        let lastWritePromise = self.firstChannel.eventLoop.makePromise(of: Void.self)
        // The last write will push us over the edge.
        var writable: Bool = try self.firstChannel.eventLoop.submit {
            self.firstChannel.write(NIOAny(writeData), promise: lastWritePromise)
            return self.firstChannel.isWritable
        }.wait()
        XCTAssertFalse(writable)

        // Now we're going to flush, and check the writability immediately after.
        self.firstChannel.flush()
        writable = try lastWritePromise.futureResult.map { _ in self.firstChannel.isWritable }.wait()
        XCTAssertTrue(writable)
    }

    func testWriteFuturesFailWhenChannelClosed() throws {
        var buffer = self.firstChannel.allocator.buffer(capacity: 256)
        buffer.writeStaticString("hello, world!")
        let writeData = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)
        let promises = (0..<5).map { _ in self.firstChannel.write(NIOAny(writeData)) }

        // Now close the channel. When that completes, all the futures should be complete too.
        let fulfilled = try self.firstChannel.close().map {
            promises.map { $0.isFulfilled }.allSatisfy { $0 }
        }.wait()
        XCTAssertTrue(fulfilled)

        promises.forEach {
            do {
                try $0.wait()
                XCTFail("Did not error")
            } catch ChannelError.ioOnClosedChannel {
                // All good
            } catch {
                XCTFail("Unexpected error: \(error)")
            }
        }
    }

    func testManyManyDatagramWrites() throws {
        // We're going to try to write loads, and loads, and loads of data. In this case, one more
        // write than the iovecs max.

        var overall: EventLoopFuture<Void> = self.firstChannel.eventLoop.makeSucceededFuture(())
        for _ in 0...Socket.writevLimitIOVectors {
            let myPromise = self.firstChannel.eventLoop.makePromise(of: Void.self)
            var buffer = self.firstChannel.allocator.buffer(capacity: 1)
            buffer.writeString("a")
            let envelope = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)
            self.firstChannel.write(NIOAny(envelope), promise: myPromise)
            overall = EventLoopFuture.andAllSucceed([overall, myPromise.futureResult], on: self.firstChannel.eventLoop)
        }
        self.firstChannel.flush()
        XCTAssertNoThrow(try overall.wait())
        // We're not going to check that the datagrams arrive, because some kernels *will* drop them here.
    }

    func testSendmmsgLotsOfData() throws {
        var datagrams = 0

        var overall = self.firstChannel.eventLoop.makeSucceededFuture(())
        // We defer this work to the background thread because otherwise it incurs an enormous number of context
        // switches.
        try self.firstChannel.eventLoop.submit {
            let myPromise = self.firstChannel.eventLoop.makePromise(of: Void.self)
            // For datagrams this buffer cannot be very large, because if it's larger than the path MTU it
            // will cause EMSGSIZE.
            let bufferSize = 1024 * 5
            var buffer = self.firstChannel.allocator.buffer(capacity: bufferSize)
            buffer.writeWithUnsafeMutableBytes {
                _ = memset($0.baseAddress!, 4, $0.count)
                return $0.count
            }
            let envelope = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)

            let lotsOfData = Int(Int32.max)
            var written: Int64 = 0
            while written <= lotsOfData {
                self.firstChannel.write(NIOAny(envelope), promise: myPromise)
                overall = EventLoopFuture.andAllSucceed([overall, myPromise.futureResult], on: self.firstChannel.eventLoop)
                written += Int64(bufferSize)
                datagrams += 1
            }
        }.wait()
        self.firstChannel.flush()

        XCTAssertNoThrow(try overall.wait())
    }

    func testLargeWritesFail() throws {
        // We want to try to trigger EMSGSIZE. To be safe, we're going to allocate a 10MB buffer here and fill it.
        let bufferSize = 1024 * 1024 * 10
        var buffer = self.firstChannel.allocator.buffer(capacity: bufferSize)
        buffer.writeWithUnsafeMutableBytes {
            _ = memset($0.baseAddress!, 4, $0.count)
            return $0.count
        }
        let envelope = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)

        let writeFut = self.firstChannel.write(NIOAny(envelope))
        self.firstChannel.flush()

        do {
            try writeFut.wait()
            XCTFail("Did not throw")
        } catch ChannelError.writeMessageTooLarge {
            // All good
        } catch {
            XCTFail("Got unexpected error \(error)")
        }
    }

    func testOneLargeWriteDoesntPreventOthersWriting() throws {
        // We want to try to trigger EMSGSIZE. To be safe, we're going to allocate a 10MB buffer here and fill it.
        let bufferSize = 1024 * 1024 * 10
        var buffer = self.firstChannel.allocator.buffer(capacity: bufferSize)
        buffer.writeWithUnsafeMutableBytes {
            _ = memset($0.baseAddress!, 4, $0.count)
            return $0.count
        }

        // Now we want two envelopes. The first is small, the second is large.
        let firstEnvelope = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer.getSlice(at: buffer.readerIndex, length: 100)!)
        let secondEnvelope = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)

        // Now, three writes. We're sandwiching the big write between two small ones.
        let firstWrite = self.firstChannel.write(NIOAny(firstEnvelope))
        let secondWrite = self.firstChannel.write(NIOAny(secondEnvelope))
        let thirdWrite = self.firstChannel.writeAndFlush(NIOAny(firstEnvelope))

        // The first and third writes should be fine.
        XCTAssertNoThrow(try firstWrite.wait())
        XCTAssertNoThrow(try thirdWrite.wait())

        // The second should have failed.
        do {
            try secondWrite.wait()
            XCTFail("Did not throw")
        } catch ChannelError.writeMessageTooLarge {
            // All good
        } catch {
            XCTFail("Got unexpected error \(error)")
        }
    }

    func testClosingBeforeFlushFailsAllWrites() throws {
        // We want to try to trigger EMSGSIZE. To be safe, we're going to allocate a 10MB buffer here and fill it.
        let bufferSize = 1024 * 1024 * 10
        var buffer = self.firstChannel.allocator.buffer(capacity: bufferSize)
        buffer.writeWithUnsafeMutableBytes {
            _ = memset($0.baseAddress!, 4, $0.count)
            return $0.count
        }

        // Now we want two envelopes. The first is small, the second is large.
        let firstEnvelope = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer.getSlice(at: buffer.readerIndex, length: 100)!)
        let secondEnvelope = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)

        // Now, three writes. We're sandwiching the big write between two small ones.
        let firstWrite = self.firstChannel.write(NIOAny(firstEnvelope))
        let secondWrite = self.firstChannel.write(NIOAny(secondEnvelope))
        let thirdWrite = self.firstChannel.writeAndFlush(NIOAny(firstEnvelope))

        // The first and third writes should be fine.
        XCTAssertNoThrow(try firstWrite.wait())
        XCTAssertNoThrow(try thirdWrite.wait())

        // The second should have failed.
        do {
            try secondWrite.wait()
            XCTFail("Did not throw")
        } catch ChannelError.writeMessageTooLarge {
            // All good
        } catch {
            XCTFail("Got unexpected error \(error)")
        }
    }

    public func testRecvFromFailsWithECONNREFUSED() throws {
        try assertRecvFromFails(error: ECONNREFUSED, active: true)
    }

    public func testRecvFromFailsWithENOMEM() throws {
        try assertRecvFromFails(error: ENOMEM, active: true)
    }

    public func testRecvFromFailsWithEFAULT() throws {
        try assertRecvFromFails(error: EFAULT, active: false)
    }

    private func assertRecvFromFails(error: Int32, active: Bool) throws {
        final class RecvFromHandler: ChannelInboundHandler {
            typealias InboundIn = AddressedEnvelope<ByteBuffer>
            typealias InboundOut = AddressedEnvelope<ByteBuffer>

            private let promise: EventLoopPromise<IOError>

            init(_ promise: EventLoopPromise<IOError>) {
                self.promise = promise
            }

            func channelRead(context: ChannelHandlerContext, data: NIOAny) {
                XCTFail("Should not receive data but got \(self.unwrapInboundIn(data))")
            }

            func errorCaught(context: ChannelHandlerContext, error: Error) {
                if let ioError = error as? IOError {
                    self.promise.succeed(ioError)
                }
            }
        }

        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer {
            XCTAssertNoThrow(try group.syncShutdownGracefully())
        }
        class NonRecvFromSocket : Socket {
            private var error: Int32?

            init(error: Int32) throws {
                self.error = error
                try super.init(protocolFamily: AF_INET, type: Posix.SOCK_DGRAM)
            }

            override func recvfrom(pointer: UnsafeMutableRawBufferPointer, storage: inout sockaddr_storage, storageLen: inout socklen_t) throws -> IOResult<(Int)> {
                if let err = self.error {
                    self.error = nil
                    throw IOError(errnoCode: err, function: "recvfrom")
                }
                return IOResult.wouldBlock(0)
            }
        }
        let socket = try NonRecvFromSocket(error: error)
        let channel = try DatagramChannel(socket: socket, eventLoop: group.next() as! SelectableEventLoop)
        let promise = channel.eventLoop.makePromise(of: IOError.self)
        XCTAssertNoThrow(try channel.register().wait())
        XCTAssertNoThrow(try channel.pipeline.addHandler(RecvFromHandler(promise)).wait())
        XCTAssertNoThrow(try channel.bind(to: SocketAddress.init(ipAddress: "127.0.0.1", port: 0)).wait())

        XCTAssertEqual(active, try channel.eventLoop.submit {
            channel.readable()
            return channel.isActive
        }.wait())

        if active {
            XCTAssertNoThrow(try channel.close().wait())
        }
        let ioError = try promise.futureResult.wait()
        XCTAssertEqual(error, ioError.errnoCode)
    }

    public func testRecvMmsgFailsWithECONNREFUSED() throws {
        try assertRecvMmsgFails(error: ECONNREFUSED, active: true)
    }

    public func testRecvMmsgFailsWithENOMEM() throws {
        try assertRecvMmsgFails(error: ENOMEM, active: true)
    }

    public func testRecvMmsgFailsWithEFAULT() throws {
        try assertRecvMmsgFails(error: EFAULT, active: false)
    }

    private func assertRecvMmsgFails(error: Int32, active: Bool) throws {
        // Only run this test on platforms that support recvmmsg: the others won't even
        // try.
        #if os(Linux) || os(FreeBSD) || os(Android)
        final class RecvMmsgHandler: ChannelInboundHandler {
            typealias InboundIn = AddressedEnvelope<ByteBuffer>
            typealias InboundOut = AddressedEnvelope<ByteBuffer>

            private let promise: EventLoopPromise<IOError>

            init(_ promise: EventLoopPromise<IOError>) {
                self.promise = promise
            }

            func channelRead(context: ChannelHandlerContext, data: NIOAny) {
                XCTFail("Should not receive data but got \(self.unwrapInboundIn(data))")
            }

            func errorCaught(context: ChannelHandlerContext, error: Error) {
                if let ioError = error as? IOError {
                    self.promise.succeed(ioError)
                }
            }
        }

        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer {
            XCTAssertNoThrow(try group.syncShutdownGracefully())
        }
        class NonRecvMmsgSocket : Socket {
            private var error: Int32?

            init(error: Int32) throws {
                self.error = error
                try super.init(protocolFamily: AF_INET, type: Posix.SOCK_DGRAM)
            }

            override func recvmmsg(msgs: UnsafeMutableBufferPointer<MMsgHdr>) throws -> IOResult<Int> {
                if let err = self.error {
                    self.error = nil
                    throw IOError(errnoCode: err, function: "recvfrom")
                }
                return IOResult.wouldBlock(0)
            }
        }
        let socket = try NonRecvMmsgSocket(error: error)
        let channel = try DatagramChannel(socket: socket, eventLoop: group.next() as! SelectableEventLoop)
        let promise = channel.eventLoop.makePromise(of: IOError.self)
        XCTAssertNoThrow(try channel.register().wait())
        XCTAssertNoThrow(try channel.pipeline.addHandler(RecvMmsgHandler(promise)).wait())
        XCTAssertNoThrow(try channel.configureForRecvMmsg(messageCount: 10))
        XCTAssertNoThrow(try channel.bind(to: SocketAddress.init(ipAddress: "127.0.0.1", port: 0)).wait())

        XCTAssertEqual(active, try channel.eventLoop.submit {
            channel.readable()
            return channel.isActive
        }.wait())

        if active {
            XCTAssertNoThrow(try channel.close().wait())
        }
        let ioError = try promise.futureResult.wait()
        XCTAssertEqual(error, ioError.errnoCode)
        #endif
    }

    public func testSetGetOptionClosedDatagramChannel() throws {
        try assertSetGetOptionOnOpenAndClosed(channel: firstChannel, option: ChannelOptions.maxMessagesPerRead, value: 1)
    }

    func testWritesAreAccountedCorrectly() throws {
        var buffer = firstChannel.allocator.buffer(capacity: 256)
        buffer.writeStaticString("hello, world!")
        let firstWrite = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer.getSlice(at: buffer.readerIndex, length: 5)!)
        let secondWrite = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)
        self.firstChannel.write(NIOAny(firstWrite), promise: nil)
        self.firstChannel.write(NIOAny(secondWrite), promise: nil)
        self.firstChannel.flush()

        let reads = try self.secondChannel.waitForDatagrams(count: 2)

        // These datagrams should not have been dropped by the kernel.
        XCTAssertEqual(reads.count, 2)

        XCTAssertEqual(reads[0].data, buffer.getSlice(at: buffer.readerIndex, length: 5)!)
        XCTAssertEqual(reads[0].remoteAddress, self.firstChannel.localAddress!)
        XCTAssertEqual(reads[1].data, buffer)
        XCTAssertEqual(reads[1].remoteAddress, self.firstChannel.localAddress!)
    }

    func testSettingTwoDistinctChannelOptionsWorksForDatagramChannel() throws {
        let channel = try assertNoThrowWithValue(DatagramBootstrap(group: group)
            .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .channelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_TIMESTAMP), value: 1)
            .bind(host: "127.0.0.1", port: 0)
            .wait())
        defer {
            XCTAssertNoThrow(try channel.close().wait())
        }
        XCTAssertTrue(try getBoolSocketOption(channel: channel, level: SOL_SOCKET, name: SO_REUSEADDR))
        XCTAssertTrue(try getBoolSocketOption(channel: channel, level: SOL_SOCKET, name: SO_TIMESTAMP))
        XCTAssertFalse(try getBoolSocketOption(channel: channel, level: SOL_SOCKET, name: SO_KEEPALIVE))
    }

    func testUnprocessedOutboundUserEventFailsOnDatagramChannel() throws {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
        defer {
            XCTAssertNoThrow(try group.syncShutdownGracefully())
        }
        let channel = try DatagramChannel(eventLoop: group.next() as! SelectableEventLoop,
                                          protocolFamily: AF_INET)
        XCTAssertThrowsError(try channel.triggerUserOutboundEvent("event").wait()) { (error: Error) in
            if let error = error as? ChannelError {
                XCTAssertEqual(ChannelError.operationUnsupported, error)
            } else {
                XCTFail("unexpected error: \(error)")
            }
        }
    }

    func testBasicMultipleReads() throws {
        XCTAssertNoThrow(try self.secondChannel.configureForRecvMmsg(messageCount: 10))

        // This test should exercise recvmmsg.
        var buffer = self.firstChannel.allocator.buffer(capacity: 256)
        buffer.writeStaticString("hello, world!")
        let writeData = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)

        // We write this in three times.
        self.firstChannel.write(NIOAny(writeData), promise: nil)
        self.firstChannel.write(NIOAny(writeData), promise: nil)
        self.firstChannel.write(NIOAny(writeData), promise: nil)
        self.firstChannel.flush()

        let reads = try self.secondChannel.waitForDatagrams(count: 3)
        XCTAssertEqual(reads.count, 3)

        for (idx, read) in reads.enumerated() {
            XCTAssertEqual(read.data, buffer, "index: \(idx)")
            XCTAssertEqual(read.remoteAddress, self.firstChannel.localAddress!, "index: \(idx)")
        }
    }

    func testMmsgWillTruncateWithoutChangeToAllocator() throws {
        // This test validates that setting a small allocator will lead to datagram truncation.
        // Right now we don't error on truncation, so this test looks for short receives.
        // Setting the recv allocator to 30 bytes forces 3 bytes per message.
        // Sadly, this test only truncates for the platforms with recvmmsg support: the rest don't truncate as 30 bytes is sufficient.
        XCTAssertNoThrow(try self.secondChannel.configureForRecvMmsg(messageCount: 10))
        XCTAssertNoThrow(try self.secondChannel.setOption(ChannelOptions.recvAllocator, value: FixedSizeRecvByteBufferAllocator(capacity: 30)).wait())

        var buffer = self.firstChannel.allocator.buffer(capacity: 256)
        buffer.writeStaticString("hello, world!")
        let writeData = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)

        // We write this in three times.
        self.firstChannel.write(NIOAny(writeData), promise: nil)
        self.firstChannel.write(NIOAny(writeData), promise: nil)
        self.firstChannel.write(NIOAny(writeData), promise: nil)
        self.firstChannel.flush()

        let reads = try self.secondChannel.waitForDatagrams(count: 3)
        XCTAssertEqual(reads.count, 3)

        for (idx, read) in reads.enumerated() {
            #if os(Linux) || os(FreeBSD) || os(Android)
            XCTAssertEqual(read.data.readableBytes, 3, "index: \(idx)")
            #else
            XCTAssertEqual(read.data.readableBytes, 13, "index: \(idx)")
            #endif
            XCTAssertEqual(read.remoteAddress, self.firstChannel.localAddress!, "index: \(idx)")
        }
    }

    func testRecvMmsgForMultipleCycles() throws {
        // The goal of this test is to provide more datagrams than can be received in a single invocation of
        // recvmmsg, and to confirm that they all make it through.
        // This test is allowed to run on systems without recvmmsg: it just exercises the serial read path.
        XCTAssertNoThrow(try self.secondChannel.configureForRecvMmsg(messageCount: 10))

        // We now turn off autoread.
        XCTAssertNoThrow(try self.secondChannel.setOption(ChannelOptions.autoRead, value: false).wait())
        XCTAssertNoThrow(try self.secondChannel.setOption(ChannelOptions.maxMessagesPerRead, value: 3).wait())

        var buffer = self.firstChannel.allocator.buffer(capacity: 256)
        buffer.writeStaticString("data")
        let writeData = AddressedEnvelope(remoteAddress: self.secondChannel.localAddress!, data: buffer)

        // Ok, now we're good. Let's queue up a bunch of datagrams. We've configured to receive 10 at a time, so we'll send 30.
        for _ in 0..<29 {
            self.firstChannel.write(NIOAny(writeData), promise: nil)
        }
        XCTAssertNoThrow(try self.firstChannel.writeAndFlush(NIOAny(writeData)).wait())

        // Now we read. Rather than issue many read() calls, we'll turn autoread back on.
        XCTAssertNoThrow(try self.secondChannel.setOption(ChannelOptions.autoRead, value: true).wait())

        // Wait for all 30 datagrams to come through. There should be no loss here, as this is small datagrams on loopback.
        let reads = try self.secondChannel.waitForDatagrams(count: 30)
        XCTAssertEqual(reads.count, 30)

        // Now we want to count the number of readCompletes. On any platform without recvmmsg, we should have seen 10 or more
        // (as max messages per read is 3). On platforms with recvmmsg, we would expect to see
        // substantially fewer than 10, and potentially as low as 1.
        #if os(Linux) || os(FreeBSD) || os(Android)
        XCTAssertLessThan(try assertNoThrowWithValue(self.secondChannel.readCompleteCount()), 10)
        XCTAssertGreaterThanOrEqual(try assertNoThrowWithValue(self.secondChannel.readCompleteCount()), 1)
        #else
        XCTAssertGreaterThanOrEqual(try assertNoThrowWithValue(self.secondChannel.readCompleteCount()), 10)
        #endif
    }
}
