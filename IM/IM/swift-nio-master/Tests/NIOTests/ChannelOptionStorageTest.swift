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

class ChannelOptionStorageTest: XCTestCase {
    func testWeStartWithNoOptions() throws {
        let cos = ChannelOptions.Storage()
        let optionsCollector = OptionsCollectingChannel()
        XCTAssertNoThrow(try cos.applyAllChannelOptions(to: optionsCollector).wait())
        XCTAssertEqual(0, optionsCollector.allOptions.count)
    }

    func testSetTwoOptionsOfDifferentType() throws {
        var cos = ChannelOptions.Storage()
        let optionsCollector = OptionsCollectingChannel()
        cos.append(key: ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
        cos.append(key: ChannelOptions.backlog, value: 2)
        XCTAssertNoThrow(try cos.applyAllChannelOptions(to: optionsCollector).wait())
        XCTAssertEqual(2, optionsCollector.allOptions.count)
    }

    func testSetTwoOptionsOfSameType() throws {
        let options: [(SocketOption, SocketOptionValue)] = [(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), 1),
                                                            (ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEPORT), 2)]
        var cos = ChannelOptions.Storage()
        let optionsCollector = OptionsCollectingChannel()
        for kv in options {
            cos.append(key: kv.0, value: kv.1)
        }
        XCTAssertNoThrow(try cos.applyAllChannelOptions(to: optionsCollector).wait())
        XCTAssertEqual(2, optionsCollector.allOptions.count)
        XCTAssertEqual(options.map { $0.0 },
                       (optionsCollector.allOptions as! [(SocketOption, SocketOptionValue)]).map { $0.0 })
        XCTAssertEqual(options.map { $0.1 },
                       (optionsCollector.allOptions as! [(SocketOption, SocketOptionValue)]).map { $0.1 })
    }

    func testSetOneOptionTwice() throws {
        var cos = ChannelOptions.Storage()
        let optionsCollector = OptionsCollectingChannel()
        cos.append(key: ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
        cos.append(key: ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 2)
        XCTAssertNoThrow(try cos.applyAllChannelOptions(to: optionsCollector).wait())
        XCTAssertEqual(1, optionsCollector.allOptions.count)
        XCTAssertEqual([ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR)],
                       (optionsCollector.allOptions as! [(SocketOption, SocketOptionValue)]).map { $0.0 })
        XCTAssertEqual([SocketOptionValue(2)],
                       (optionsCollector.allOptions as! [(SocketOption, SocketOptionValue)]).map { $0.1 })
    }
}

class OptionsCollectingChannel: Channel {
    var allOptions: [(Any, Any)] = []

    var allocator: ByteBufferAllocator { fatalError() }

    var closeFuture: EventLoopFuture<Void> { fatalError() }

    var pipeline: ChannelPipeline { fatalError() }

    var localAddress: SocketAddress? { fatalError() }

    var remoteAddress: SocketAddress? { fatalError() }

    var parent: Channel? { fatalError() }

    func setOption<Option: ChannelOption>(_ option: Option, value: Option.Value) -> EventLoopFuture<Void> {
        self.allOptions.append((option, value))
        return self.eventLoop.makeSucceededFuture(())
    }

    func getOption<Option: ChannelOption>(_ option: Option) -> EventLoopFuture<Option.Value> {
        fatalError()
    }

    var isWritable: Bool { fatalError() }

    var isActive: Bool { fatalError() }

    var _channelCore: ChannelCore { fatalError() }

    var eventLoop: EventLoop {
        return EmbeddedEventLoop()
    }
}
