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
import NIO

class MarkedCircularBufferTests: XCTestCase {
    func testEmptyMark() throws {
        var buf = MarkedCircularBuffer<Int>(initialCapacity: 8)
        XCTAssertFalse(buf.hasMark)
        XCTAssertNil(buf.markedElement)
        XCTAssertNil(buf.markedElementIndex)

        buf.mark()
        XCTAssertFalse(buf.hasMark)
        XCTAssertNil(buf.markedElement)
        XCTAssertNil(buf.markedElementIndex)
    }

    func testSimpleMark() throws {
        var buf = MarkedCircularBuffer<Int>(initialCapacity: 8)

        for i in 1...4 { buf.append(i) }
        buf.mark()
        for i in 5...8 { buf.append(i) }

        XCTAssertTrue(buf.hasMark)
        XCTAssertEqual(buf.markedElement, 4)
        XCTAssertEqual(buf.markedElementIndex, buf.index(buf.startIndex, offsetBy: 3))

        for i in 0..<3 { XCTAssertFalse(buf.isMarked(index: buf.index(buf.startIndex, offsetBy: i))) }
        XCTAssertTrue(buf.isMarked(index: buf.index(buf.startIndex, offsetBy: 3)))
        for i in 4..<8 { XCTAssertFalse(buf.isMarked(index: buf.index(buf.startIndex, offsetBy: i))) }
    }

    func testPassingTheMark() throws {
        var buf = MarkedCircularBuffer<Int>(initialCapacity: 8)

        for i in 1...4 { buf.append(i) }
        buf.mark()
        for i in 5...8 { buf.append(i) }

        for j in 1...3 {
            XCTAssertEqual(buf.removeFirst(), j)
            XCTAssertTrue(buf.hasMark)
            XCTAssertEqual(buf.markedElement, 4)
            XCTAssertEqual(buf.markedElementIndex, buf.index(buf.startIndex, offsetBy: 3 - j))
        }

        XCTAssertEqual(buf.removeFirst(), 4)
        XCTAssertFalse(buf.hasMark)
        XCTAssertNil(buf.markedElement)
        XCTAssertNil(buf.markedElementIndex)
    }

    func testMovingTheMark() throws {
        var buf = MarkedCircularBuffer<Int>(initialCapacity: 8)

        for i in 1...8 {
            buf.append(i)
            buf.mark()

            XCTAssertTrue(buf.hasMark)
            XCTAssertEqual(buf.markedElement, i)
            XCTAssertEqual(buf.markedElementIndex, buf.index(buf.startIndex, offsetBy: i - 1))
            XCTAssertTrue(buf.isMarked(index: buf.index(buf.startIndex, offsetBy: i - 1)))
        }
    }
    func testIndices() throws {
        var buf = MarkedCircularBuffer<Int>(initialCapacity: 4)
        for i in 1...4 {
            buf.append(i)
        }

        var allIndices: [MarkedCircularBuffer<Int>.Index] = []
        var index = buf.startIndex
        while index != buf.endIndex {
            allIndices.append(index)
            index = buf.index(after: index)
        }
        XCTAssertEqual(Array(buf.indices), allIndices)
    }

    func testFirst() throws {
        var buf = MarkedCircularBuffer<Int>(initialCapacity: 4)
        for i in 1...4 {
            buf.append(i)
        }
        XCTAssertEqual(buf.first, 1)
    }

    func testCount() throws {
        var buf = MarkedCircularBuffer<Int>(initialCapacity: 4)
        for i in 1...4 {
            buf.append(i)
        }
        XCTAssertEqual(buf.count, 4)
    }

    func testSubscript() throws {
        var buf = MarkedCircularBuffer<Int>(initialCapacity: 4)
        for i in 1...4 {
            buf.append(i)
        }
        XCTAssertEqual(buf[buf.startIndex], 1)
        XCTAssertEqual(buf[buf.index(buf.startIndex, offsetBy: 3)], 4)
    }

    func testIsEmpty() throws {
        var buf = MarkedCircularBuffer<Int>(initialCapacity: 4)
        for i in 1...4 {
            buf.append(i)
        }
        XCTAssertFalse(buf.isEmpty)
        let _ = buf.removeFirst()
        let _ = buf.removeFirst()
        let _ = buf.removeFirst()
        let _ = buf.removeFirst()
        XCTAssertTrue(buf.isEmpty)
    }
    
}
