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

import struct Foundation.Data
import XCTest
@testable import NIO
import NIOFoundationCompat

class ByteBufferTest: XCTestCase {
    private let allocator = ByteBufferAllocator()
    private var buf: ByteBuffer! = nil

    private func setGetInt<T: FixedWidthInteger>(index: Int, v: T) throws {
        var buffer = allocator.buffer(capacity: 32)

        XCTAssertEqual(MemoryLayout<T>.size, buffer.setInteger(v, at: index))
        buffer.moveWriterIndex(to: index + MemoryLayout<T>.size)
        buffer.moveReaderIndex(to: index)
        XCTAssertEqual(v, buffer.getInteger(at: index))
    }

    private func writeReadInt<T: FixedWidthInteger>(v: T) throws {
        var buffer = allocator.buffer(capacity: 32)
        XCTAssertEqual(0, buffer.writerIndex)
        XCTAssertEqual(MemoryLayout<T>.size, buffer.writeInteger(v))
        XCTAssertEqual(MemoryLayout<T>.size, buffer.writerIndex)

        XCTAssertEqual(v, buffer.readInteger())
        XCTAssertEqual(0, buffer.readableBytes)
    }

    override func setUp() {
        super.setUp()

        self.buf = allocator.buffer(capacity: 1024)
        self.buf.writeBytes(Array(repeating: UInt8(0xff), count: 1024))
        self.buf = self.buf.getSlice(at: 256, length: 512)
        self.buf.clear()
    }

    override func tearDown() {
        self.buf = nil

        super.tearDown()
    }

    func testAllocateAndCount() {
        let b = allocator.buffer(capacity: 1024)
        XCTAssertEqual(1024, b.capacity)
    }

    func testEqualsComparesReadBuffersOnly() throws {
        // Only cares about the read buffer
        self.buf.writeInteger(Int8.max)
        self.buf.writeString("oh hi")
        let actual: Int8 = buf.readInteger()! // Just getting rid of it from the read buffer
        XCTAssertEqual(Int8.max, actual)

        var otherBuffer = allocator.buffer(capacity: 32)
        otherBuffer.writeString("oh hi")
        XCTAssertEqual(otherBuffer, buf)
    }

    func testSimpleReadTest() throws {
        buf.withUnsafeReadableBytes { ptr in
            XCTAssertEqual(ptr.count, 0)
        }

        buf.writeString("Hello world!")
        buf.withUnsafeReadableBytes { ptr in
            XCTAssertEqual(12, ptr.count)
        }
    }

    func testSimpleWrites() {
        var written = buf.writeString("")
        XCTAssertEqual(0, written)
        XCTAssertEqual(0, buf.readableBytes)

        written = buf.writeString("X")
        XCTAssertEqual(1, written)
        XCTAssertEqual(1, buf.readableBytes)

        written = buf.writeString("XXXXX")
        XCTAssertEqual(5, written)
        XCTAssertEqual(6, buf.readableBytes)
    }

    func makeSliceToBufferWhichIsDeallocated() -> ByteBuffer {
        var buf = self.allocator.buffer(capacity: 16)
        let oldCapacity = buf.capacity
        buf.writeBytes(0..<16)
        XCTAssertEqual(oldCapacity, buf.capacity)
        return buf.getSlice(at: 15, length: 1)!
    }

    func testMakeSureUniquelyOwnedSliceDoesNotGetReallocatedOnWrite() {
        var slice = self.makeSliceToBufferWhichIsDeallocated()
        XCTAssertEqual(1, slice.capacity)
        let oldStorageBegin = slice.withUnsafeReadableBytes { ptr in
            return UInt(bitPattern: ptr.baseAddress!)
        }
        slice.setInteger(1, at: 0, as: UInt8.self)
        let newStorageBegin = slice.withUnsafeReadableBytes { ptr in
            return UInt(bitPattern: ptr.baseAddress!)
        }
        XCTAssertEqual(oldStorageBegin, newStorageBegin)
    }

    func testWriteToUniquelyOwnedSliceWhichTriggersAReallocation() {
        var slice = self.makeSliceToBufferWhichIsDeallocated()
        XCTAssertEqual(1, slice.capacity)
        // this will cause a re-allocation, the whole buffer should be 32 bytes then, the slice having 17 of that.
        // this fills 16 bytes so will still fit
        slice.writeBytes(Array(16..<32))
        XCTAssertEqual(Array(15..<32), slice.readBytes(length: slice.readableBytes)!)

        // and this will need another re-allocation
        slice.writeBytes(Array(32..<47))
    }


    func testReadWrite() {
        buf.writeString("X")
        buf.writeString("Y")
        let d = buf.readData(length: 1)
        XCTAssertNotNil(d)
        if let d = d {
            XCTAssertEqual(1, d.count)
            XCTAssertEqual("X".utf8.first!, d.first!)
        }
    }

    func testStaticStringReadTests() throws {
        var allBytes = 0
        for testString in ["", "Hello world!", "👍", "🇬🇧🇺🇸🇪🇺"] as [StaticString] {
            buf.withUnsafeReadableBytes { ptr in
                XCTAssertEqual(0, ptr.count)
            }
            XCTAssertEqual(0, buf.readableBytes)
            XCTAssertEqual(allBytes, buf.readerIndex)

            let bytes = buf.writeStaticString(testString)
            XCTAssertEqual(testString.utf8CodeUnitCount, Int(bytes))
            allBytes += bytes
            XCTAssertEqual(allBytes - bytes, buf.readerIndex)

            let expected = testString.withUTF8Buffer { buf in
                String(decoding: buf, as: Unicode.UTF8.self)
            }
            buf.withUnsafeReadableBytes { ptr in
                let actual = String(decoding: ptr, as: Unicode.UTF8.self)
                XCTAssertEqual(expected, actual)
            }
            let d = buf.readData(length: testString.utf8CodeUnitCount)
            XCTAssertEqual(allBytes, buf.readerIndex)
            XCTAssertNotNil(d)
            XCTAssertEqual(d?.count, testString.utf8CodeUnitCount)
            XCTAssertEqual(expected, String(decoding: d!, as: Unicode.UTF8.self))
        }
    }

    func testString() {
        let written = buf.writeString("Hello")
        let string = buf.getString(at: 0, length: written)
        XCTAssertEqual("Hello", string)
    }

    func testSliceEasy() {
        buf.writeString("0123456789abcdefg")
        for i in 0..<16 {
            let slice = buf.getSlice(at: i, length: 1)
            XCTAssertEqual(1, slice?.capacity)
            XCTAssertEqual(buf.getData(at: i, length: 1), slice?.getData(at: 0, length: 1))
        }
    }

    func testWriteStringMovesWriterIndex() throws {
        var buf = allocator.buffer(capacity: 1024)
        buf.writeString("hello")
        XCTAssertEqual(5, buf.writerIndex)
        buf.withUnsafeReadableBytes { (ptr: UnsafeRawBufferPointer) -> Void in
            let s = String(decoding: ptr, as: Unicode.UTF8.self)
            XCTAssertEqual("hello", s)
        }
    }

    func testSetExpandsBufferOnUpperBoundsCheckFailure() {
        let initialCapacity = buf.capacity
        XCTAssertEqual(5, buf.setString("oh hi", at: buf.capacity))
        XCTAssert(initialCapacity < buf.capacity)
    }

    func testCoWWorks() {
        buf.writeString("Hello")
        var a = buf!
        let b = buf!
        a.writeString(" World")
        XCTAssertEqual(buf, b)
        XCTAssertNotEqual(buf, a)
    }

    func testWithMutableReadPointerMovesReaderIndexAndReturnsNumBytesConsumed() {
        XCTAssertEqual(0, buf.readerIndex)
        // We use mutable read pointers when we're consuming the data
        // so first we need some data there!
        buf.writeString("hello again")

        let bytesConsumed = buf.readWithUnsafeReadableBytes { dst in
            // Pretend we did some operation which made use of entire 11 byte string
            return 11
        }
        XCTAssertEqual(11, bytesConsumed)
        XCTAssertEqual(11, buf.readerIndex)
    }

    func testWithMutableWritePointerMovesWriterIndexAndReturnsNumBytesWritten() {
        XCTAssertEqual(0, buf.writerIndex)

        let bytesWritten = buf.writeWithUnsafeMutableBytes { (_: UnsafeMutableRawBufferPointer) in return 5 }
        XCTAssertEqual(5, bytesWritten)
        XCTAssertEqual(5, buf.writerIndex)
    }

    func testSetGetInt8() throws {
        try setGetInt(index: 0, v: Int8.max)
    }

    func testSetGetInt16() throws {
        try setGetInt(index: 1, v: Int16.max)
    }

    func testSetGetInt32() throws {
        try setGetInt(index: 2, v: Int32.max)
    }

    func testSetGetInt64() throws {
        try setGetInt(index: 3, v: Int64.max)
    }

    func testSetGetUInt8() throws {
        try setGetInt(index: 4, v: UInt8.max)
    }

    func testSetGetUInt16() throws {
        try setGetInt(index: 5, v: UInt16.max)
    }

    func testSetGetUInt32() throws {
        try setGetInt(index: 6, v: UInt32.max)
    }

    func testSetGetUInt64() throws {
        try setGetInt(index: 7, v: UInt64.max)
    }

    func testWriteReadInt8() throws {
        try writeReadInt(v: Int8.max)
    }

    func testWriteReadInt16() throws {
        try writeReadInt(v: Int16.max)
    }

    func testWriteReadInt32() throws {
        try writeReadInt(v: Int32.max)
    }

    func testWriteReadInt64() throws {
        try writeReadInt(v: Int32.max)
    }

    func testWriteReadUInt8() throws {
        try writeReadInt(v: UInt8.max)
    }

    func testWriteReadUInt16() throws {
        try writeReadInt(v: UInt16.max)
    }

    func testWriteReadUInt32() throws {
        try writeReadInt(v: UInt32.max)
    }

    func testWriteReadUInt64() throws {
        try writeReadInt(v: UInt32.max)
    }

    func testSlice() throws {
        var buffer = allocator.buffer(capacity: 32)
        XCTAssertEqual(MemoryLayout<UInt64>.size, buffer.writeInteger(UInt64.max))
        var slice = buffer.slice()
        XCTAssertEqual(MemoryLayout<UInt64>.size, slice.readableBytes)
        XCTAssertEqual(UInt64.max, slice.readInteger())
        XCTAssertEqual(MemoryLayout<UInt64>.size, buffer.readableBytes)
        XCTAssertEqual(UInt64.max, buffer.readInteger())
    }

    func testSliceWithParams() throws {
        var buffer = allocator.buffer(capacity: 32)
        XCTAssertEqual(MemoryLayout<UInt64>.size, buffer.writeInteger(UInt64.max))
        var slice = buffer.getSlice(at: 0, length: MemoryLayout<UInt64>.size)!
        XCTAssertEqual(MemoryLayout<UInt64>.size, slice.readableBytes)
        XCTAssertEqual(UInt64.max, slice.readInteger())
        XCTAssertEqual(MemoryLayout<UInt64>.size, buffer.readableBytes)
        XCTAssertEqual(UInt64.max, buffer.readInteger())
    }

    func testReadSlice() throws {
        var buffer = allocator.buffer(capacity: 32)
        XCTAssertEqual(MemoryLayout<UInt64>.size, buffer.writeInteger(UInt64.max))
        var slice = buffer.readSlice(length: buffer.readableBytes)!
        XCTAssertEqual(MemoryLayout<UInt64>.size, slice.readableBytes)
        XCTAssertEqual(UInt64.max, slice.readInteger())
        XCTAssertEqual(0, buffer.readableBytes)
        let value: UInt64? = buffer.readInteger()
        XCTAssertTrue(value == nil)
    }

    func testSliceNoCopy() throws {
        var buffer = allocator.buffer(capacity: 32)
        XCTAssertEqual(MemoryLayout<UInt64>.size, buffer.writeInteger(UInt64.max))
        let slice = buffer.readSlice(length: buffer.readableBytes)!

        buffer.withVeryUnsafeBytes { ptr1 in
            slice.withVeryUnsafeBytes { ptr2 in
                XCTAssertEqual(ptr1.baseAddress, ptr2.baseAddress)
            }
        }
    }

    func testSetGetData() throws {
        var buffer = allocator.buffer(capacity: 32)
        let data = Data([1, 2, 3])

        XCTAssertEqual(3, buffer.setBytes(data, at: 0))
        XCTAssertEqual(0, buffer.readableBytes)
        buffer.moveReaderIndex(to: 0)
        buffer.moveWriterIndex(to: 3)
        XCTAssertEqual(data, buffer.getData(at: 0, length: 3))
    }

    func testWriteReadData() throws {
        var buffer = allocator.buffer(capacity: 32)
        let data = Data([1, 2, 3])

        XCTAssertEqual(3, buffer.writeBytes(data))
        XCTAssertEqual(3, buffer.readableBytes)
        XCTAssertEqual(data, buffer.readData(length: 3))
    }

    func testDiscardReadBytes() throws {
        var buffer = allocator.buffer(capacity: 32)
        buffer.writeInteger(1, as: UInt8.self)
        buffer.writeInteger(UInt8(2))
        buffer.writeInteger(3 as UInt8)
        buffer.writeInteger(4, as: UInt8.self)
        XCTAssertEqual(4, buffer.readableBytes)
        buffer.moveReaderIndex(forwardBy: 2)
        XCTAssertEqual(2, buffer.readableBytes)
        XCTAssertEqual(2, buffer.readerIndex)
        XCTAssertEqual(4, buffer.writerIndex)
        XCTAssertTrue(buffer.discardReadBytes())
        XCTAssertEqual(2, buffer.readableBytes)
        XCTAssertEqual(0, buffer.readerIndex)
        XCTAssertEqual(2, buffer.writerIndex)
        XCTAssertEqual(UInt8(3), buffer.readInteger())
        XCTAssertEqual(UInt8(4), buffer.readInteger())
        XCTAssertEqual(0, buffer.readableBytes)
        XCTAssertTrue(buffer.discardReadBytes())
        XCTAssertFalse(buffer.discardReadBytes())
    }

    func testDiscardReadBytesCoW() throws {
        var buffer = allocator.buffer(capacity: 32)
        let bytesWritten = buffer.writeBytes("0123456789abcdef0123456789ABCDEF".data(using: .utf8)!)
        XCTAssertEqual(32, bytesWritten)

        func testAssumptionOriginalBuffer(_ buf: inout ByteBuffer) {
            XCTAssertEqual(32, buf.capacity)
            XCTAssertEqual(0, buf.readerIndex)
            XCTAssertEqual(32, buf.writerIndex)
            XCTAssertEqual("0123456789abcdef0123456789ABCDEF".data(using: .utf8)!, buf.getData(at: 0, length: 32)!)
        }
        testAssumptionOriginalBuffer(&buffer)

        var buffer10Missing = buffer
        let first10Bytes = buffer10Missing.readData(length: 10) /* make the first 10 bytes disappear */
        let otherBuffer10Missing = buffer10Missing
        XCTAssertEqual("0123456789".data(using: .utf8)!, first10Bytes)
        testAssumptionOriginalBuffer(&buffer)
        XCTAssertEqual(10, buffer10Missing.readerIndex)
        XCTAssertEqual(32, buffer10Missing.writerIndex)

        let nextBytes1 = buffer10Missing.getData(at: 10, length: 22)
        XCTAssertEqual("abcdef0123456789ABCDEF".data(using: .utf8)!, nextBytes1)

        buffer10Missing.discardReadBytes()
        XCTAssertEqual(0, buffer10Missing.readerIndex)
        XCTAssertEqual(22, buffer10Missing.writerIndex)
        testAssumptionOriginalBuffer(&buffer)

        XCTAssertEqual(10, otherBuffer10Missing.readerIndex)
        XCTAssertEqual(32, otherBuffer10Missing.writerIndex)

        let nextBytes2 = buffer10Missing.getData(at: 0, length: 22)
        XCTAssertEqual("abcdef0123456789ABCDEF".data(using: .utf8)!, nextBytes2)

        let nextBytes3 = otherBuffer10Missing.getData(at: 10, length: 22)
        XCTAssertEqual("abcdef0123456789ABCDEF".data(using: .utf8)!, nextBytes3)
        testAssumptionOriginalBuffer(&buffer)

    }

    func testDiscardReadBytesSlice() throws {
        var buffer = allocator.buffer(capacity: 32)
        buffer.writeInteger(UInt8(1))
        buffer.writeInteger(UInt8(2))
        buffer.writeInteger(UInt8(3))
        buffer.writeInteger(UInt8(4))
        XCTAssertEqual(4, buffer.readableBytes)
        var slice = buffer.getSlice(at: 1, length: 3)!
        XCTAssertEqual(3, slice.readableBytes)
        XCTAssertEqual(0, slice.readerIndex)

        slice.moveReaderIndex(forwardBy: 1)
        XCTAssertEqual(2, slice.readableBytes)
        XCTAssertEqual(1, slice.readerIndex)
        XCTAssertEqual(3, slice.writerIndex)
        XCTAssertTrue(slice.discardReadBytes())
        XCTAssertEqual(2, slice.readableBytes)
        XCTAssertEqual(0, slice.readerIndex)
        XCTAssertEqual(2, slice.writerIndex)
        XCTAssertEqual(UInt8(3), slice.readInteger())
        XCTAssertEqual(UInt8(4), slice.readInteger())
        XCTAssertEqual(0,slice.readableBytes)
        XCTAssertTrue(slice.discardReadBytes())
        XCTAssertFalse(slice.discardReadBytes())
    }

    func testWithDataSlices() throws {
        let testStringPrefix = "0123456789"
        let testStringSuffix = "abcdef"
        let testString = "\(testStringPrefix)\(testStringSuffix)"

        var buffer = allocator.buffer(capacity: testString.utf8.count)
        buffer.writeString(testStringPrefix)
        buffer.writeString(testStringSuffix)
        XCTAssertEqual(testString.utf8.count, buffer.capacity)

        func runTestForRemaining(string: String, buffer: ByteBuffer) {
            buffer.withUnsafeReadableBytes { ptr in
                XCTAssertEqual(string.utf8.count, ptr.count)

                for (idx, expected) in zip(0..<string.utf8.count, string.utf8) {
                    let actual = ptr[idx]
                    XCTAssertEqual(expected, actual, "character at index \(idx) is \(actual) but should be \(expected)")
                }
            }

            buffer.withUnsafeReadableBytes { data -> Void in
                XCTAssertEqual(string.utf8.count, data.count)
                for (idx, expected) in zip(data.startIndex..<data.startIndex+string.utf8.count, string.utf8) {
                    XCTAssertEqual(expected, data[idx])
                }
            }

            buffer.withUnsafeReadableBytes { slice in
                XCTAssertEqual(string, String(decoding: slice, as: Unicode.UTF8.self))
            }
        }

        runTestForRemaining(string: testString, buffer: buffer)
        let prefixBuffer = buffer.readSlice(length: testStringPrefix.utf8.count)
        XCTAssertNotNil(prefixBuffer)
        if let prefixBuffer = prefixBuffer {
            runTestForRemaining(string: testStringPrefix, buffer: prefixBuffer)
        }
        runTestForRemaining(string: testStringSuffix, buffer: buffer)
    }

    func testEndianness() throws {
        let value: UInt32 = 0x12345678
        buf.writeInteger(value)
        let actualRead: UInt32 = buf.readInteger()!
        XCTAssertEqual(value, actualRead)
        buf.writeInteger(value, endianness: .big)
        buf.writeInteger(value, endianness: .little)
        buf.writeInteger(value)
        let actual = buf.getData(at: 4, length: 12)!
        let expected = Data([0x12, 0x34, 0x56, 0x78, 0x78, 0x56, 0x34, 0x12, 0x12, 0x34, 0x56, 0x78])
        XCTAssertEqual(expected, actual)
        let actualA: UInt32 = buf.readInteger(endianness: .big)!
        let actualB: UInt32 = buf.readInteger(endianness: .little)!
        let actualC: UInt32 = buf.readInteger()!
        XCTAssertEqual(value, actualA)
        XCTAssertEqual(value, actualB)
        XCTAssertEqual(value, actualC)
    }

    func testExpansion() throws {
        var buf = allocator.buffer(capacity: 16)
        XCTAssertEqual(16, buf.capacity)
        buf.writeBytes("0123456789abcdef".data(using: .utf8)!)
        XCTAssertEqual(16, buf.capacity)
        XCTAssertEqual(16, buf.writerIndex)
        XCTAssertEqual(0, buf.readerIndex)
        buf.writeBytes("X".data(using: .utf8)!)
        XCTAssertGreaterThan(buf.capacity, 16)
        XCTAssertEqual(17, buf.writerIndex)
        XCTAssertEqual(0, buf.readerIndex)
        buf.withUnsafeReadableBytes { ptr in
            let bPtr = UnsafeBufferPointer(start: ptr.baseAddress!.bindMemory(to: UInt8.self, capacity: ptr.count),
                                           count: ptr.count)
            XCTAssertEqual("0123456789abcdefX".data(using: .utf8)!, Data(buffer: bPtr))
        }
    }

    func testExpansion2() throws {
        var buf = allocator.buffer(capacity: 2)
        XCTAssertEqual(2, buf.capacity)
        buf.writeBytes("0123456789abcdef".data(using: .utf8)!)
        XCTAssertEqual(16, buf.capacity)
        XCTAssertEqual(16, buf.writerIndex)
        buf.withUnsafeReadableBytes { ptr in
            let bPtr = UnsafeBufferPointer(start: ptr.baseAddress!.bindMemory(to: UInt8.self, capacity: ptr.count),
                                           count: ptr.count)
            XCTAssertEqual("0123456789abcdef".data(using: .utf8)!, Data(buffer: bPtr))
        }
    }

    func testNotEnoughBytesToReadForIntegers() throws {
        let byteCount = 15
        func initBuffer() {
            let written = buf.writeBytes(Data(Array(repeating: 0, count: byteCount)))
            XCTAssertEqual(byteCount, written)
        }

        func tryWith<T: FixedWidthInteger>(_ type: T.Type) {
            initBuffer()

            let tooMany = (byteCount + 1)/MemoryLayout<T>.size
            for _ in 1..<tooMany {
                /* read just enough ones that we should be able to read in one go */
                XCTAssertNotNil(buf.getInteger(at: buf.readerIndex) as T?)
                let actual: T? = buf.readInteger()
                XCTAssertNotNil(actual)
                XCTAssertEqual(0, actual)
            }
            /* now see that trying to read one more fails */
            let actual: T? = buf.readInteger()
            XCTAssertNil(actual)

            buf.clear()
        }

        tryWith(UInt16.self)
        tryWith(UInt32.self)
        tryWith(UInt64.self)
    }

    func testNotEnoughBytesToReadForData() throws {
        let cap = buf.capacity
        let expected = Data(Array(repeating: 0, count: cap))
        let written = buf.writeBytes(expected)
        XCTAssertEqual(cap, written)
        XCTAssertEqual(cap, buf.capacity)

        XCTAssertNil(buf.readData(length: cap+1)) /* too many */
        XCTAssertEqual(expected, buf.readData(length: cap)) /* to make sure it can work */
    }

    func testSlicesThatAreOutOfBands() throws {
        self.buf.moveReaderIndex(to: 0)
        self.buf.moveWriterIndex(to: self.buf.capacity)
        let goodSlice = self.buf.getSlice(at: 0, length: self.buf.capacity)
        XCTAssertNotNil(goodSlice)

        let badSlice1 = self.buf.getSlice(at: 0, length: self.buf.capacity+1)
        XCTAssertNil(badSlice1)

        let badSlice2 = self.buf.getSlice(at: self.buf.capacity-1, length: 2)
        XCTAssertNil(badSlice2)
    }

    func testMutableBytesCoW() throws {
        let cap = buf.capacity
        var otherBuf = buf
        XCTAssertEqual(otherBuf, buf)
        otherBuf?.writeWithUnsafeMutableBytes { ptr in
            XCTAssertEqual(cap, ptr.count)
            let intPtr = ptr.baseAddress!.bindMemory(to: UInt8.self, capacity: ptr.count)
            for i in 0..<ptr.count {
                intPtr[i] = UInt8(truncatingIfNeeded: i)
            }
            return ptr.count
        }
        XCTAssertEqual(cap, otherBuf?.capacity)
        XCTAssertNotEqual(buf, otherBuf)
        otherBuf?.withUnsafeReadableBytes { ptr in
            XCTAssertEqual(cap, ptr.count)
            for i in 0..<cap {
                XCTAssertEqual(ptr[i], UInt8(truncatingIfNeeded: i))
            }
        }
    }

    func testWritableBytesTriggersCoW() throws {
        let cap = buf.capacity
        var otherBuf = buf
        XCTAssertEqual(otherBuf, buf)

        // Write to both buffers.
        let firstResult = buf!.withUnsafeMutableWritableBytes { (ptr: UnsafeMutableRawBufferPointer) -> Bool in
            XCTAssertEqual(cap, ptr.count)
            memset(ptr.baseAddress!, 0, ptr.count)
            return false
        }
        let secondResult = otherBuf!.withUnsafeMutableWritableBytes { (ptr: UnsafeMutableRawBufferPointer) -> Bool in
            XCTAssertEqual(cap, ptr.count)
            let intPtr = ptr.baseAddress!.bindMemory(to: UInt8.self, capacity: ptr.count)
            for i in 0..<ptr.count {
                intPtr[i] = UInt8(truncatingIfNeeded: i)
            }
            return true
        }
        XCTAssertFalse(firstResult)
        XCTAssertTrue(secondResult)
        XCTAssertEqual(cap, otherBuf!.capacity)
        XCTAssertEqual(buf!.readableBytes, 0)
        XCTAssertEqual(otherBuf!.readableBytes, 0)

        // Move both writer indices forwards by the amount of data we wrote.
        buf!.moveWriterIndex(forwardBy: cap)
        otherBuf!.moveWriterIndex(forwardBy: cap)

        // These should now be unequal. Check their bytes to be sure.
        XCTAssertNotEqual(buf, otherBuf)
        buf!.withUnsafeReadableBytes { ptr in
            XCTAssertEqual(cap, ptr.count)
            for i in 0..<cap {
                XCTAssertEqual(ptr[i], 0)
            }
        }
        otherBuf!.withUnsafeReadableBytes { ptr in
            XCTAssertEqual(cap, ptr.count)
            for i in 0..<cap {
                XCTAssertEqual(ptr[i], UInt8(truncatingIfNeeded: i))
            }
        }
    }

    func testBufferWithZeroBytes() throws {
        var buf = allocator.buffer(capacity: 0)
        XCTAssertEqual(0, buf.capacity)

        var otherBuf = buf

        otherBuf.setBytes(Data(), at: 0)
        buf.setBytes(Data(), at: 0)

        XCTAssertEqual(0, buf.capacity)
        XCTAssertEqual(0, otherBuf.capacity)

        XCTAssertNil(otherBuf.readData(length: 1))
        XCTAssertNil(buf.readData(length: 1))
    }

    func testPastEnd() throws {
        let buf = allocator.buffer(capacity: 4)
        XCTAssertEqual(4, buf.capacity)

        XCTAssertNil(buf.getInteger(at: 0) as UInt64?)
        XCTAssertNil(buf.getData(at: 0, length: 5))
    }

    func testReadDataNotEnoughAvailable() throws {
        /* write some bytes */
        self.buf.writeBytes(Data([0, 1, 2, 3]))

        /* make more available in the buffer that should not be readable */
        self.buf.setBytes(Data([4, 5, 6, 7]), at: 4)

        let actualNil = buf.readData(length: 5)
        XCTAssertNil(actualNil)

        self.buf.moveReaderIndex(to: 0)
        self.buf.moveWriterIndex(to: 5)
        let actualGoodDirect = buf.getData(at: 0, length: 5)
        XCTAssertEqual(Data([0, 1, 2, 3, 4]), actualGoodDirect)

        let actualGood = self.buf.readData(length: 4)
        XCTAssertEqual(Data([0, 1, 2, 3]), actualGood)
    }

    func testReadSliceNotEnoughAvailable() throws {
        /* write some bytes */
        self.buf.writeBytes(Data([0, 1, 2, 3]))

        /* make more available in the buffer that should not be readable */
        self.buf.setBytes(Data([4, 5, 6, 7]), at: 4)

        let actualNil = self.buf.readSlice(length: 5)
        XCTAssertNil(actualNil)

        self.buf.moveWriterIndex(forwardBy: 1)
        let actualGoodDirect = self.buf.getSlice(at: 0, length: 5)
        XCTAssertEqual(Data([0, 1, 2, 3, 4]), actualGoodDirect?.getData(at: 0, length: 5))

        var actualGood = self.buf.readSlice(length: 4)
        XCTAssertEqual(Data([0, 1, 2, 3]), actualGood?.readData(length: 4))
    }

    func testSetBuffer() throws {
        var src = self.allocator.buffer(capacity: 4)
        src.writeBytes(Data([0, 1, 2, 3]))

        self.buf.set(buffer: src, at: 1)

        /* Should bit increase the writerIndex of the src buffer */
        XCTAssertEqual(4, src.readableBytes)
        XCTAssertEqual(0, self.buf.readableBytes)

        self.buf.moveWriterIndex(to: 5)
        self.buf.moveReaderIndex(to: 1)
        XCTAssertEqual(Data([0, 1, 2, 3]), self.buf.getData(at: 1, length: 4))
    }

    func testWriteBuffer() throws {
        var src = allocator.buffer(capacity: 4)
        src.writeBytes(Data([0, 1, 2, 3]))

        buf.writeBuffer(&src)

        /* Should increase the writerIndex of the src buffer */
        XCTAssertEqual(0, src.readableBytes)
        XCTAssertEqual(4, buf.readableBytes)
        XCTAssertEqual(Data([0, 1, 2, 3]), buf.readData(length: 4))
    }

    func testMisalignedIntegerRead() throws {
        let value = UInt64(7)

        buf.writeBytes(Data([1]))
        buf.writeInteger(value)
        let actual = buf.readData(length: 1)
        XCTAssertEqual(Data([1]), actual)

        buf.withUnsafeReadableBytes { ptr in
            /* make sure pointer is actually misaligned for an integer */
            let pointerBitPattern = UInt(bitPattern: ptr.baseAddress!)
            let lastBit = pointerBitPattern & 0x1
            XCTAssertEqual(1, lastBit) /* having a 1 as the last bit makes that pointer clearly misaligned for UInt64 */
        }

        XCTAssertEqual(value, buf.readInteger())
    }

    func testSetAndWriteBytes() throws {
        let str = "hello world!"
        let hwData = str.data(using: .utf8)!
        /* write once, ... */
        buf.writeString(str)
        var written1: Int = -1
        var written2: Int = -1
        hwData.withUnsafeBytes { ptr in
            /* ... write a second time and ...*/
            written1 = buf.setBytes(ptr, at: buf.writerIndex)
            buf.moveWriterIndex(forwardBy: written1)
            /* ... a lucky third time! */
            written2 = buf.writeBytes(ptr)
        }
        XCTAssertEqual(written1, written2)
        XCTAssertEqual(str.utf8.count, written1)
        XCTAssertEqual(3 * str.utf8.count, buf.readableBytes)
        let actualData = buf.readData(length: 3 * str.utf8.count)!
        let actualString = String(decoding: actualData, as: Unicode.UTF8.self)
        XCTAssertEqual(Array(repeating: str, count: 3).joined(), actualString)
    }

    func testWriteABunchOfCollections() throws {
        let overallData = "0123456789abcdef".data(using: .utf8)!
        buf.writeBytes("0123".utf8)
        "4567".withCString { ptr in
            ptr.withMemoryRebound(to: UInt8.self, capacity: 4) { ptr in
                _ = buf.writeBytes(UnsafeBufferPointer<UInt8>(start: ptr, count: 4))
            }
        }
        buf.writeBytes(Array("89ab".utf8))
        buf.writeBytes("cdef".data(using: .utf8)!)
        let actual = buf.getData(at: 0, length: buf.readableBytes)
        XCTAssertEqual(overallData, actual)
    }

    func testSetABunchOfCollections() throws {
        let overallData = "0123456789abcdef".data(using: .utf8)!
        self.buf.setBytes("0123".utf8, at: 0)
        _ = "4567".withCString { ptr in
            ptr.withMemoryRebound(to: UInt8.self, capacity: 4) { ptr in
                self.buf.setBytes(UnsafeBufferPointer<UInt8>(start: ptr, count: 4), at: 4)
            }
        }
        self.buf.setBytes(Array("89ab".utf8), at: 8)
        self.buf.setBytes("cdef".data(using: .utf8)!, at: 12)
        self.buf.moveReaderIndex(to: 0)
        self.buf.moveWriterIndex(to: 16)
        let actual = self.buf.getData(at: 0, length: 16)
        XCTAssertEqual(overallData, actual)
    }

    func testTryStringTooLong() throws {
        let capacity = self.buf.capacity
        for i in 0..<self.buf.capacity {
            self.buf.setString("x", at: i)
        }
        XCTAssertEqual(capacity, self.buf.capacity,
                       "buffer capacity needlessly changed from \(capacity) to \(self.buf.capacity)")
        XCTAssertNil(self.buf.getString(at: 0, length: capacity+1))
    }

    func testSetGetBytesAllFine() throws {
        self.buf.moveReaderIndex(to: 0)
        self.buf.setBytes([1, 2, 3, 4], at: 0)
        self.buf.moveWriterIndex(to: 4)
        XCTAssertEqual([1, 2, 3, 4], self.buf.getBytes(at: 0, length: 4) ?? [])

        let capacity = self.buf.capacity
        for i in 0..<self.buf.capacity {
            self.buf.setBytes([0xFF], at: i)
        }
        self.buf.moveWriterIndex(to: self.buf.capacity)
        XCTAssertEqual(capacity, buf.capacity, "buffer capacity needlessly changed from \(capacity) to \(buf.capacity)")
        XCTAssertEqual(Array(repeating: 0xFF, count: capacity), self.buf.getBytes(at: 0, length: capacity))

    }

    func testGetBytesTooLong() throws {
        XCTAssertNil(buf.getBytes(at: 0, length: buf.capacity+1))
        XCTAssertNil(buf.getBytes(at: buf.capacity, length: 1))
    }

    func testReadWriteBytesOkay() throws {
        buf.reserveCapacity(24)
        buf.clear()
        let capacity = buf.capacity
        for i in 0..<capacity {
            let expected = Array(repeating: UInt8(i % 255), count: i)
            buf.writeBytes(expected)
            let actual = buf.readBytes(length: i)!
            XCTAssertEqual(expected, actual)
            XCTAssertEqual(capacity, buf.capacity, "buffer capacity needlessly changed from \(capacity) to \(buf.capacity)")
            buf.clear()
        }
    }

    func testReadTooLong() throws {
        XCTAssertNotNil(buf.readBytes(length: buf.readableBytes))
        XCTAssertNil(buf.readBytes(length: buf.readableBytes+1))
    }

    func testReadWithUnsafeReadableBytesVariantsNothingToRead() throws {
        buf.reserveCapacity(1024)
        buf.clear()
        XCTAssertEqual(0, buf.readerIndex)
        XCTAssertEqual(0, buf.writerIndex)

        var rInt = buf.readWithUnsafeReadableBytes { ptr in
            XCTAssertEqual(0, ptr.count)
            return 0
        }
        XCTAssertEqual(0, rInt)

        rInt = buf.readWithUnsafeMutableReadableBytes { ptr in
            XCTAssertEqual(0, ptr.count)
            return 0
        }
        XCTAssertEqual(0, rInt)

        var rString = buf.readWithUnsafeReadableBytes { (ptr: UnsafeRawBufferPointer) -> (Int, String) in
            XCTAssertEqual(0, ptr.count)
            return (0, "blah")
        }
        XCTAssert(rString == "blah")

        rString = buf.readWithUnsafeMutableReadableBytes { (ptr: UnsafeMutableRawBufferPointer) -> (Int, String) in
            XCTAssertEqual(0, ptr.count)
            return (0, "blah")
        }
        XCTAssert(rString == "blah")
    }

    func testReadWithUnsafeReadableBytesVariantsSomethingToRead() throws {
        var buf = ByteBufferAllocator().buffer(capacity: 1)
        buf.clear()
        buf.writeBytes([1, 2, 3, 4, 5, 6, 7, 8])
        XCTAssertEqual(0, buf.readerIndex)
        XCTAssertEqual(8, buf.writerIndex)

        var rInt = buf.readWithUnsafeReadableBytes { ptr in
            XCTAssertEqual(8, ptr.count)
            return 0
        }
        XCTAssertEqual(0, rInt)

        rInt = buf.readWithUnsafeMutableReadableBytes { ptr in
            XCTAssertEqual(8, ptr.count)
            return 1
        }
        XCTAssertEqual(1, rInt)

        var rString = buf.readWithUnsafeReadableBytes { (ptr: UnsafeRawBufferPointer) -> (Int, String) in
            XCTAssertEqual(7, ptr.count)
            return (2, "blah")
        }
        XCTAssert(rString == "blah")

        rString = buf.readWithUnsafeMutableReadableBytes { (ptr: UnsafeMutableRawBufferPointer) -> (Int, String) in
            XCTAssertEqual(5, ptr.count)
            return (3, "blah")
        }
        XCTAssert(rString == "blah")

        XCTAssertEqual(6, buf.readerIndex)
        XCTAssertEqual(8, buf.writerIndex)
    }

    func testSomePotentialIntegerUnderOrOverflows() throws {
        buf.reserveCapacity(1024)
        buf.writeStaticString("hello world, just some trap bytes here")

        func testIndexAndLengthFunc<T>(_ body: (Int, Int) -> T?, file: StaticString = #file, line: UInt = #line) {
            XCTAssertNil(body(Int.max, 1), file: file, line: line)
            XCTAssertNil(body(Int.max - 1, 2), file: file, line: line)
            XCTAssertNil(body(1, Int.max), file: file, line: line)
            XCTAssertNil(body(2, Int.max - 1), file: file, line: line)
            XCTAssertNil(body(Int.max, Int.max), file: file, line: line)
            XCTAssertNil(body(Int.min, Int.min), file: file, line: line)
            XCTAssertNil(body(Int.max, Int.min), file: file, line: line)
            XCTAssertNil(body(Int.min, Int.max), file: file, line: line)
        }

        func testIndexOrLengthFunc<T>(_ body: (Int) -> T?, file: StaticString = #file, line: UInt = #line) {
            XCTAssertNil(body(Int.max))
            XCTAssertNil(body(Int.max - 1))
            XCTAssertNil(body(Int.min))
        }

        testIndexOrLengthFunc({ buf.readBytes(length: $0) })
        testIndexOrLengthFunc({ buf.readData(length: $0) })
        testIndexOrLengthFunc({ buf.readSlice(length: $0) })
        testIndexOrLengthFunc({ buf.readString(length: $0) })
        testIndexOrLengthFunc({ buf.readDispatchData(length: $0) })

        testIndexOrLengthFunc({ buf.getInteger(at: $0, as: UInt8.self) })
        testIndexOrLengthFunc({ buf.getInteger(at: $0, as: UInt16.self) })
        testIndexOrLengthFunc({ buf.getInteger(at: $0, as: UInt32.self) })
        testIndexOrLengthFunc({ buf.getInteger(at: $0, as: UInt64.self) })
        testIndexAndLengthFunc(buf.getBytes)
        testIndexAndLengthFunc(buf.getData)
        testIndexAndLengthFunc(buf.getSlice)
        testIndexAndLengthFunc(buf.getString)
        testIndexAndLengthFunc(buf.getDispatchData)
    }

    func testWriteForContiguousCollections() throws {
        buf.clear()
        var written = buf.writeBytes([1, 2, 3, 4])
        XCTAssertEqual(4, written)
        // UnsafeRawBufferPointer
        written += [5 as UInt8, 6, 7, 8].withUnsafeBytes { ptr in
            buf.writeBytes(ptr)
        }
        XCTAssertEqual(8, written)
        // UnsafeBufferPointer<UInt8>
        written += [9 as UInt8, 10, 11, 12].withUnsafeBufferPointer { ptr in
            buf.writeBytes(ptr)
        }
        XCTAssertEqual(12, written)
        // ContiguousArray
        written += buf.writeBytes(ContiguousArray<UInt8>([13, 14, 15, 16]))
        XCTAssertEqual(16, written)

        // Data
        written += buf.writeBytes("EFGH".data(using: .utf8)!)
        XCTAssertEqual(20, written)
        var more = Array("IJKL".utf8)

        // UnsafeMutableRawBufferPointer
        written += more.withUnsafeMutableBytes { ptr in
            buf.writeBytes(ptr)
        }
        more = Array("MNOP".utf8)
        // UnsafeMutableBufferPointer<UInt8>
        written += more.withUnsafeMutableBufferPointer { ptr in
            buf.writeBytes(ptr)
        }
        more = Array("mnopQRSTuvwx".utf8)

        // ArraySlice
        written += buf.writeBytes(more.dropFirst(4).dropLast(4))

        let moreCA = ContiguousArray("qrstUVWXyz01".utf8)
        // ContiguousArray's slice (== ArraySlice)
        written += buf.writeBytes(moreCA.dropFirst(4).dropLast(4))

        // Slice<UnsafeRawBufferPointer>
        written += Array("uvwxYZ01abcd".utf8).withUnsafeBytes { ptr in
            buf.writeBytes(ptr.dropFirst(4).dropLast(4) as UnsafeRawBufferPointer.SubSequence)
        }
        more = Array("2345".utf8)
        written += more.withUnsafeMutableBytes { ptr in
            buf.writeBytes(ptr.dropFirst(0)) + buf.writeBytes(ptr.dropFirst(4 /* drop all of them */))
        }

        let expected = Array(1...16) + Array("EFGHIJKLMNOPQRSTUVWXYZ012345".utf8)

        XCTAssertEqual(expected, buf.readBytes(length: written)!)
    }

    func testWriteForNonContiguousCollections() throws {
        buf.clear()
        let written = buf.writeBytes("ABCD".utf8)
        XCTAssertEqual(4, written)

        let expected = ["A".utf8.first!, "B".utf8.first!, "C".utf8.first!, "D".utf8.first!]

        XCTAssertEqual(expected, buf.readBytes(length: written)!)
    }

    func testReadStringOkay() throws {
        buf.clear()
        let expected = "hello"
        buf.writeString(expected)
        let actual = buf.readString(length: expected.utf8.count)
        XCTAssertEqual(expected, actual)
        XCTAssertEqual("", buf.readString(length: 0))
        XCTAssertNil(buf.readString(length: 1))
    }

    func testReadStringTooMuch() throws {
        buf.clear()
        XCTAssertNil(buf.readString(length: 1))

        buf.writeString("a")
        XCTAssertNil(buf.readString(length: 2))

        XCTAssertEqual("a", buf.readString(length: 1))
    }

    func testSetIntegerBeyondCapacity() throws {
        var buf = ByteBufferAllocator().buffer(capacity: 32)
        XCTAssertLessThan(buf.capacity, 200)

        buf.setInteger(17, at: 201)
        buf.moveWriterIndex(to: 201 + MemoryLayout<Int>.size)
        buf.moveReaderIndex(to: 201)
        let i: Int = buf.getInteger(at: 201)!
        XCTAssertEqual(17, i)
        XCTAssertGreaterThanOrEqual(buf.capacity, 200 + MemoryLayout.size(ofValue: i))
    }

    func testGetIntegerBeyondCapacity() throws {
        let buf = ByteBufferAllocator().buffer(capacity: 32)
        XCTAssertLessThan(buf.capacity, 200)

        let i: Int? = buf.getInteger(at: 201)
        XCTAssertNil(i)
    }

    func testSetStringBeyondCapacity() throws {
        var buf = ByteBufferAllocator().buffer(capacity: 32)
        XCTAssertLessThan(buf.capacity, 200)

        buf.setString("HW", at: 201)
        buf.moveWriterIndex(to: 201 + 2)
        buf.moveReaderIndex(to: 201)
        let s = buf.getString(at: 201, length: 2)!
        XCTAssertEqual("HW", s)
        XCTAssertGreaterThanOrEqual(buf.capacity, 202)
    }

    func testGetStringBeyondCapacity() throws {
        let buf = ByteBufferAllocator().buffer(capacity: 32)
        XCTAssertLessThan(buf.capacity, 200)

        let i: String? = buf.getString(at: 201, length: 1)
        XCTAssertNil(i)
    }

    func testAllocationOfReallyBigByteBuffer() throws {
        #if arch(arm) || arch(i386)
        // this test doesn't work on 32-bit platforms because the address space is only 4GB large and we're trying
        // to make a 4GB ByteBuffer which just won't fit. Even going down to 2GB won't make it better.
        return
        #endif
        let alloc = ByteBufferAllocator(hookedMalloc: { testAllocationOfReallyBigByteBuffer_mallocHook($0) },
                                        hookedRealloc: { testAllocationOfReallyBigByteBuffer_reallocHook($0, $1) },
                                        hookedFree: { testAllocationOfReallyBigByteBuffer_freeHook($0) },
                                        hookedMemcpy: { testAllocationOfReallyBigByteBuffer_memcpyHook($0, $1, $2) })

        let reallyBigSize = Int(Int32.max)
        XCTAssertEqual(AllocationExpectationState.begin, testAllocationOfReallyBigByteBuffer_state)
        var buf = alloc.buffer(capacity: reallyBigSize)
        XCTAssertEqual(AllocationExpectationState.mallocDone, testAllocationOfReallyBigByteBuffer_state)
        XCTAssertGreaterThanOrEqual(buf.capacity, reallyBigSize)

        buf.setBytes([1], at: 0)
        /* now make it expand (will trigger realloc) */
        buf.setBytes([1], at: buf.capacity)

        XCTAssertEqual(AllocationExpectationState.reallocDone, testAllocationOfReallyBigByteBuffer_state)
        XCTAssertEqual(buf.capacity, Int(UInt32.max))
    }

    func testWritableBytesAccountsForSlicing() throws {
        var buf = ByteBufferAllocator().buffer(capacity: 32)
        XCTAssertEqual(buf.capacity, 32)
        XCTAssertEqual(buf.writableBytes, 32)
        let oldWriterIndex = buf.writerIndex
        buf.writeStaticString("01234567")
        let newBuf = buf.getSlice(at: oldWriterIndex, length: 8)!
        XCTAssertEqual(newBuf.capacity, 8)
        XCTAssertEqual(newBuf.writableBytes, 0)
    }

    func testClearDupesStorageIfTheresTwoBuffersSharingStorage() throws {
        let alloc = ByteBufferAllocator()
        var buf1 = alloc.buffer(capacity: 16)
        let buf2 = buf1

        var buf1PtrVal: UInt = 1
        var buf2PtrVal: UInt = 2

        buf1.withUnsafeReadableBytes { ptr in
            buf1PtrVal = UInt(bitPattern: ptr.baseAddress!)
        }
        buf2.withUnsafeReadableBytes { ptr in
            buf2PtrVal = UInt(bitPattern: ptr.baseAddress!)
        }
        XCTAssertEqual(buf1PtrVal, buf2PtrVal)

        buf1.clear()

        buf1.withUnsafeReadableBytes { ptr in
            buf1PtrVal = UInt(bitPattern: ptr.baseAddress!)
        }
        buf2.withUnsafeReadableBytes { ptr in
            buf2PtrVal = UInt(bitPattern: ptr.baseAddress!)
        }
        XCTAssertNotEqual(buf1PtrVal, buf2PtrVal)
    }

    func testClearDoesNotDupeStorageIfTheresOnlyOneBuffer() throws {
        let alloc = ByteBufferAllocator()
        var buf = alloc.buffer(capacity: 16)

        var bufPtrValPre: UInt = 1
        var bufPtrValPost: UInt = 2

        buf.withUnsafeReadableBytes { ptr in
            bufPtrValPre = UInt(bitPattern: ptr.baseAddress!)
        }

        buf.clear()

        buf.withUnsafeReadableBytes { ptr in
            bufPtrValPost = UInt(bitPattern: ptr.baseAddress!)
        }
        XCTAssertEqual(bufPtrValPre, bufPtrValPost)
    }

    func testWeUseFastWriteForContiguousCollections() throws {
        struct WrongCollection: Collection {
            let storage: [UInt8] = [1, 2, 3]
            typealias Element = UInt8
            typealias Index = Array<UInt8>.Index
            typealias SubSequence = Array<UInt8>.SubSequence
            typealias Indices = Array<UInt8>.Indices
            public var indices: Indices {
                return self.storage.indices
            }
            public subscript(bounds: Range<Index>) -> SubSequence {
                return self.storage[bounds]
            }

            public subscript(position: Index) -> Element {
                /* this is wrong but we need to check that we don't access this */
                XCTFail("shouldn't have been called")
                return 0xff
            }

            public var startIndex: Index {
                return self.storage.startIndex
            }

            public var endIndex: Index {
                return self.storage.endIndex
            }

            func index(after i: Index) -> Index {
                return self.storage.index(after: i)
            }

            func withContiguousStorageIfAvailable<R>(_ body: (UnsafeBufferPointer<UInt8>) throws -> R) rethrows -> R? {
                return try self.storage.withUnsafeBufferPointer(body)
            }
        }
        buf.clear()
        buf.writeBytes(WrongCollection())
        XCTAssertEqual(3, buf.readableBytes)
        XCTAssertEqual(1, buf.readInteger()! as UInt8)
        XCTAssertEqual(2, buf.readInteger()! as UInt8)
        XCTAssertEqual(3, buf.readInteger()! as UInt8)
        buf.setBytes(WrongCollection(), at: 0)
        XCTAssertEqual(0, buf.readableBytes)
        buf.moveWriterIndex(to: 3)
        buf.moveReaderIndex(to: 0)
        XCTAssertEqual(1, buf.getInteger(at: 0, as: UInt8.self))
        XCTAssertEqual(2, buf.getInteger(at: 1, as: UInt8.self))
        XCTAssertEqual(3, buf.getInteger(at: 2, as: UInt8.self))
    }

    func testUnderestimatingSequenceWorks() throws {
        struct UnderestimatingSequence: Sequence {
            let storage: [UInt8] = Array(0...255)
            typealias Element = UInt8

            public var indices: CountableRange<Int> {
                return self.storage.indices
            }

            public subscript(position: Int) -> Element {
                return self.storage[position]
            }

            public var underestimatedCount: Int {
                return 8
            }

            func makeIterator() -> Array<UInt8>.Iterator {
                return self.storage.makeIterator()
            }
        }
        buf = self.allocator.buffer(capacity: 4)
        buf.clear()
        buf.writeBytes(UnderestimatingSequence())
        XCTAssertEqual(256, buf.readableBytes)
        for i in 0..<256 {
            let actual = Int(buf.readInteger()! as UInt8)
            XCTAssertEqual(i, actual)
        }
        buf = self.allocator.buffer(capacity: 4)
        buf.setBytes(UnderestimatingSequence(), at: 0)
        XCTAssertEqual(0, buf.readableBytes)
        buf.moveWriterIndex(to: 256)
        buf.moveReaderIndex(to: 0)
        for i in 0..<256 {
            XCTAssertEqual(i, buf.getInteger(at: i, as: UInt8.self).map(Int.init))
        }
    }

    func testZeroSizeByteBufferResizes() {
        var buf = ByteBufferAllocator().buffer(capacity: 0)
        buf.writeStaticString("x")
        XCTAssertEqual(buf.writerIndex, 1)
    }

    func testSpecifyTypesAndEndiannessForIntegerMethods() {
        self.buf.clear()
        self.buf.writeInteger(-1, endianness: .big, as: Int64.self)
        XCTAssertEqual(-1, self.buf.readInteger(endianness: .big, as: Int64.self))
        self.buf.setInteger(0xdeadbeef, at: 0, endianness: .little, as: UInt64.self)
        self.buf.moveWriterIndex(to: 8)
        self.buf.moveReaderIndex(to: 0)
        XCTAssertEqual(0xdeadbeef, self.buf.getInteger(at: 0, endianness: .little, as: UInt64.self))
    }

    func testByteBufferFitsInACoupleOfEnums() throws {
        enum Level4 {
            case case1(ByteBuffer)
            case case2(ByteBuffer)
            case case3(ByteBuffer)
            case case4(ByteBuffer)
        }
        enum Level3 {
            case case1(Level4)
            case case2(Level4)
            case case3(Level4)
            case case4(Level4)
        }
        enum Level2 {
            case case1(Level3)
            case case2(Level3)
            case case3(Level3)
            case case4(Level3)
        }
        enum Level1 {
            case case1(Level2)
            case case2(Level2)
            case case3(Level2)
            case case4(Level2)
        }

        XCTAssertLessThanOrEqual(MemoryLayout<ByteBuffer>.size, 23)
        XCTAssertLessThanOrEqual(MemoryLayout<Level1>.size, 24)

        XCTAssertLessThanOrEqual(MemoryLayout.size(ofValue: Level1.case1(.case2(.case3(.case4(self.buf))))), 24)
        XCTAssertLessThanOrEqual(MemoryLayout.size(ofValue: Level1.case1(.case3(.case4(.case1(self.buf))))), 24)
    }

    func testLargeSliceBegin16MBIsOkayAndDoesNotCopy() throws {
        var fourMBBuf = self.allocator.buffer(capacity: 4 * 1024 * 1024)
        fourMBBuf.writeBytes(repeatElement(0xff, count: fourMBBuf.capacity))
        let totalBufferSize = 5 * fourMBBuf.readableBytes
        XCTAssertEqual(4 * 1024 * 1024, fourMBBuf.readableBytes)
        var buf = self.allocator.buffer(capacity: totalBufferSize)
        for _ in 0..<5 {
            var fresh = fourMBBuf
            buf.writeBuffer(&fresh)
        }

        let offset = Int(_UInt24.max)

        // mark some special bytes
        buf.setInteger(0xaa, at: 0, as: UInt8.self)
        buf.setInteger(0xbb, at: offset - 1, as: UInt8.self)
        buf.setInteger(0xcc, at: offset, as: UInt8.self)
        buf.setInteger(0xdd, at: buf.writerIndex - 1, as: UInt8.self)

        XCTAssertEqual(totalBufferSize, buf.readableBytes)

        let oldPtrVal = buf.withUnsafeReadableBytes {
            UInt(bitPattern: $0.baseAddress!.advanced(by: offset))
        }

        let expectedReadableBytes = totalBufferSize - offset
        let slice = buf.getSlice(at: offset, length: expectedReadableBytes)!
        XCTAssertEqual(expectedReadableBytes, slice.readableBytes)
        let newPtrVal = slice.withUnsafeReadableBytes {
            UInt(bitPattern: $0.baseAddress!)
        }
        XCTAssertEqual(oldPtrVal, newPtrVal)

        XCTAssertEqual(0xcc, slice.getInteger(at: 0, as: UInt8.self))
        XCTAssertEqual(0xdd, slice.getInteger(at: slice.writerIndex - 1, as: UInt8.self))
    }

    func testLargeSliceBeginMoreThan16MBIsOkay() throws {
        var fourMBBuf = self.allocator.buffer(capacity: 4 * 1024 * 1024)
        fourMBBuf.writeBytes(repeatElement(0xff, count: fourMBBuf.capacity))
        let totalBufferSize = 5 * fourMBBuf.readableBytes + 1
        XCTAssertEqual(4 * 1024 * 1024, fourMBBuf.readableBytes)
        var buf = self.allocator.buffer(capacity: totalBufferSize)
        for _ in 0..<5 {
            var fresh = fourMBBuf
            buf.writeBuffer(&fresh)
        }

        let offset = Int(_UInt24.max) + 1

        // mark some special bytes
        buf.setInteger(0xaa, at: 0, as: UInt8.self)
        buf.setInteger(0xbb, at: offset - 1, as: UInt8.self)
        buf.setInteger(0xcc, at: offset, as: UInt8.self)
        buf.writeInteger(0xdd, as: UInt8.self) // write extra byte so the slice is the same length as above
        XCTAssertEqual(totalBufferSize, buf.readableBytes)

        let expectedReadableBytes = totalBufferSize - offset
        let slice = buf.getSlice(at: offset, length: expectedReadableBytes)!
        XCTAssertEqual(expectedReadableBytes, slice.readableBytes)
        XCTAssertEqual(0, slice.readerIndex)
        XCTAssertEqual(expectedReadableBytes, slice.writerIndex)
        XCTAssertEqual(Int(UInt32(expectedReadableBytes).nextPowerOf2()), slice.capacity)

        XCTAssertEqual(0xcc, slice.getInteger(at: 0, as: UInt8.self))
        XCTAssertEqual(0xdd, slice.getInteger(at: slice.writerIndex - 1, as: UInt8.self))
    }

    func testDiscardReadBytesOnConsumedBuffer() {
        var buffer = self.allocator.buffer(capacity: 8)
        buffer.writeInteger(0xaa, as: UInt8.self)
        XCTAssertEqual(1, buffer.readableBytes)
        XCTAssertEqual(0xaa, buffer.readInteger(as: UInt8.self))
        XCTAssertEqual(0, buffer.readableBytes)

        let buffer2 = buffer
        XCTAssertTrue(buffer.discardReadBytes())
        XCTAssertEqual(0, buffer.readerIndex)
        XCTAssertEqual(0, buffer.writerIndex)
        // As we fully consumed the buffer we should only have adjusted the indices but not triggered a copy as result of CoW sematics.
        // So we should still be able to also read the old data.
        buffer.moveWriterIndex(to: 1)
        buffer.moveReaderIndex(to: 0)
        XCTAssertEqual(0xaa, buffer.getInteger(at: 0, as: UInt8.self))
        XCTAssertEqual(0, buffer2.readableBytes)
    }

    func testDumpBytesFormat() throws {
        self.buf.clear()
        for f in UInt8.min...UInt8.max {
            self.buf.writeInteger(f)
        }
        let actual = self.buf._storage.dumpBytes(slice: self.buf._slice, offset: 0, length: self.buf.readableBytes)
        let expected = """
        [ \
        00 01 02 03 04 05 06 07 08 09 0a 0b 0c 0d 0e 0f 10 11 12 13 14 15 16 17 18 19 1a 1b 1c 1d 1e 1f \
        20 21 22 23 24 25 26 27 28 29 2a 2b 2c 2d 2e 2f 30 31 32 33 34 35 36 37 38 39 3a 3b 3c 3d 3e 3f \
        40 41 42 43 44 45 46 47 48 49 4a 4b 4c 4d 4e 4f 50 51 52 53 54 55 56 57 58 59 5a 5b 5c 5d 5e 5f \
        60 61 62 63 64 65 66 67 68 69 6a 6b 6c 6d 6e 6f 70 71 72 73 74 75 76 77 78 79 7a 7b 7c 7d 7e 7f \
        80 81 82 83 84 85 86 87 88 89 8a 8b 8c 8d 8e 8f 90 91 92 93 94 95 96 97 98 99 9a 9b 9c 9d 9e 9f \
        a0 a1 a2 a3 a4 a5 a6 a7 a8 a9 aa ab ac ad ae af b0 b1 b2 b3 b4 b5 b6 b7 b8 b9 ba bb bc bd be bf \
        c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 ca cb cc cd ce cf d0 d1 d2 d3 d4 d5 d6 d7 d8 d9 da db dc dd de df \
        e0 e1 e2 e3 e4 e5 e6 e7 e8 e9 ea eb ec ed ee ef f0 f1 f2 f3 f4 f5 f6 f7 f8 f9 fa fb fc fd fe ff ]
        """
        XCTAssertEqual(expected, actual)
    }

    func testReadableBytesView() throws {
        self.buf.clear()
        self.buf.writeString("hello world 012345678")
        XCTAssertEqual("hello ", self.buf.readString(length: 6))
        self.buf.moveWriterIndex(to: self.buf.writerIndex - 10)
        XCTAssertEqual("world", String(decoding: self.buf.readableBytesView, as: Unicode.UTF8.self))
        XCTAssertEqual("world", self.buf.readString(length: self.buf.readableBytes))
    }

    func testReadableBytesViewNoReadableBytes() throws {
        self.buf.clear()
        let view = self.buf.readableBytesView
        XCTAssertEqual(0, view.count)
    }

    func testBytesView() throws {
        self.buf.clear()
        self.buf.writeString("hello world 012345678")
        XCTAssertEqual(self.buf.viewBytes(at: self.buf.readerIndex,
                                          length: self.buf.writerIndex - self.buf.readerIndex).map { (view: ByteBufferView) -> String in
                                            String(decoding: view, as: Unicode.UTF8.self)
                                          },
                       self.buf.getString(at: self.buf.readerIndex, length: self.buf.readableBytes))
        XCTAssertEqual(self.buf.viewBytes(at: 0, length: 0).map { Array($0) }, [])
        XCTAssertEqual(Array("hello world 012345678".utf8),
                       self.buf.viewBytes(at: 0, length: self.buf.readableBytes).map(Array.init))
    }

    func testViewsStartIndexIsStable() throws {
        self.buf.writeString("hello")
        let view: ByteBufferView? = self.buf.viewBytes(at: 1, length: 3)
        XCTAssertEqual(1, view?.startIndex)
        XCTAssertEqual(3, view?.count)
        XCTAssertEqual(4, view?.endIndex)
        XCTAssertEqual("ell", view.map { String(decoding: $0, as: Unicode.UTF8.self) })
    }

    func testSlicesOfByteBufferViewsAreByteBufferViews() throws {
        self.buf.writeString("hello")
        let view: ByteBufferView? = self.buf.viewBytes(at: 1, length: 3)
        XCTAssertEqual("ell", view.map { String(decoding: $0, as: Unicode.UTF8.self) })
        let viewSlice: ByteBufferView? = view.map { $0[$0.startIndex + 1 ..< $0.endIndex] }
        XCTAssertEqual("ll", viewSlice.map { String(decoding: $0, as: Unicode.UTF8.self) })
        XCTAssertEqual("l", viewSlice.map { String(decoding: $0.dropFirst(), as: Unicode.UTF8.self) })
        XCTAssertEqual("", viewSlice.map { String(decoding: $0.dropFirst().dropLast(), as: Unicode.UTF8.self) })
    }
    
    func testReadableBufferViewRangeEqualCapacity() throws {
        self.buf.clear()
        self.buf.moveWriterIndex(forwardBy: buf.capacity)
        let view = self.buf.readableBytesView
        let viewSlice: ByteBufferView = view[view.startIndex ..< view.endIndex]
        XCTAssertEqual(buf.readableBytes, viewSlice.count)
    }

    func testByteBuffersCanBeInitializedFromByteBufferViews() throws {
        self.buf.writeString("hello")

        let readableByteBuffer = ByteBuffer(self.buf.readableBytesView)
        XCTAssertEqual(self.buf, readableByteBuffer)

        let sliceByteBuffer = self.buf.viewBytes(at: 1, length: 3).map(ByteBuffer.init)
        XCTAssertEqual("ell", sliceByteBuffer.flatMap { $0.getString(at: 0, length: $0.readableBytes) })

        self.buf.clear()

        let emptyByteBuffer = ByteBuffer(self.buf.readableBytesView)
        XCTAssertEqual(self.buf, emptyByteBuffer)

        var fixedCapacityBuffer = self.allocator.buffer(capacity: 16)
        let capacity = fixedCapacityBuffer.capacity
        fixedCapacityBuffer.writeString(String(repeating: "x", count: capacity))
        XCTAssertEqual(capacity, fixedCapacityBuffer.capacity)
        XCTAssertEqual(fixedCapacityBuffer, ByteBuffer(fixedCapacityBuffer.readableBytesView))
    }

    func testReserveCapacityWhenOversize() throws {
        let oldCapacity = buf.capacity
        let oldPtrVal = buf.withVeryUnsafeBytes {
            UInt(bitPattern: $0.baseAddress!)
        }

        buf.reserveCapacity(oldCapacity - 1)
        let newPtrVal = buf.withVeryUnsafeBytes {
            UInt(bitPattern: $0.baseAddress!)
        }

        XCTAssertEqual(buf.capacity, oldCapacity)
        XCTAssertEqual(oldPtrVal, newPtrVal)
    }

    func testReserveCapacitySameCapacity() throws {
        let oldCapacity = buf.capacity
        let oldPtrVal = buf.withVeryUnsafeBytes {
            UInt(bitPattern: $0.baseAddress!)
        }

        buf.reserveCapacity(oldCapacity)
        let newPtrVal = buf.withVeryUnsafeBytes {
            UInt(bitPattern: $0.baseAddress!)
        }

        XCTAssertEqual(buf.capacity, oldCapacity)
        XCTAssertEqual(oldPtrVal, newPtrVal)
    }

    func testReserveCapacityLargerUniquelyReferencedCallsRealloc() throws {
        testReserveCapacityLarger_reallocCount = 0
        testReserveCapacityLarger_mallocCount = 0

        let alloc = ByteBufferAllocator(hookedMalloc: testReserveCapacityLarger_mallocHook,
                                        hookedRealloc: testReserveCapacityLarger_reallocHook,
                                        hookedFree: testReserveCapacityLarger_freeHook,
                                        hookedMemcpy: testReserveCapacityLarger_memcpyHook)
        var buf = alloc.buffer(capacity: 16)


        let oldCapacity = buf.capacity

        XCTAssertEqual(testReserveCapacityLarger_mallocCount, 1)
        XCTAssertEqual(testReserveCapacityLarger_reallocCount, 0)
        buf.reserveCapacity(32)
        XCTAssertEqual(testReserveCapacityLarger_mallocCount, 1)
        XCTAssertEqual(testReserveCapacityLarger_reallocCount, 1)
        XCTAssertNotEqual(buf.capacity, oldCapacity)
    }

    func testReserveCapacityLargerMultipleReferenceCallsMalloc() throws {
        testReserveCapacityLarger_reallocCount = 0
        testReserveCapacityLarger_mallocCount = 0

        let alloc = ByteBufferAllocator(hookedMalloc: testReserveCapacityLarger_mallocHook,
                                        hookedRealloc: testReserveCapacityLarger_reallocHook,
                                        hookedFree: testReserveCapacityLarger_freeHook,
                                        hookedMemcpy: testReserveCapacityLarger_memcpyHook)
        var buf = alloc.buffer(capacity: 16)
        let bufCopy = buf

        withExtendedLifetime(bufCopy) {
            let oldCapacity = buf.capacity
            let oldPtrVal = buf.withVeryUnsafeBytes {
                UInt(bitPattern: $0.baseAddress!)
            }

            XCTAssertEqual(testReserveCapacityLarger_mallocCount, 1)
            XCTAssertEqual(testReserveCapacityLarger_reallocCount, 0)
            buf.reserveCapacity(32)
            XCTAssertEqual(testReserveCapacityLarger_mallocCount, 2)
            XCTAssertEqual(testReserveCapacityLarger_reallocCount, 0)

            let newPtrVal = buf.withVeryUnsafeBytes {
                UInt(bitPattern: $0.baseAddress!)
            }

            XCTAssertNotEqual(buf.capacity, oldCapacity)
            XCTAssertNotEqual(oldPtrVal, newPtrVal)
        }
    }

    func testReadWithFunctionsThatReturnNumberOfReadBytesAreDiscardable() {
        var buf = self.buf!
        buf.writeString("ABCD")

        /* deliberately not ignoring the result */ buf.readWithUnsafeReadableBytes { buffer in
            XCTAssertEqual(4, buffer.count)
            return 2
        }

        /* deliberately not ignoring the result */ buf.readWithUnsafeMutableReadableBytes { buffer in
            XCTAssertEqual(2, buffer.count)
            return 2
        }

        XCTAssertEqual(0, buf.readableBytes)
    }

    func testWriteAndSetAndGetAndReadEncoding() throws {
        var buf = self.buf!
        buf.clear()

        var writtenBytes = try assertNoThrowWithValue(buf.writeString("ÆBCD", encoding: .utf16LittleEndian))
        XCTAssertEqual(writtenBytes, 8)
        XCTAssertEqual(buf.readableBytes, 8)
        XCTAssertEqual(buf.getString(at: buf.readerIndex + 2, length: 6, encoding: .utf16LittleEndian), "BCD")

        writtenBytes = try assertNoThrowWithValue(buf.setString("EFGH", encoding: .utf32BigEndian, at: buf.readerIndex))
        XCTAssertEqual(writtenBytes, 16)
        XCTAssertEqual(buf.readableBytes, 8)
        XCTAssertEqual(buf.readString(length: 8, encoding: .utf32BigEndian), "EF")
        XCTAssertEqual(buf.readableBytes, 0)

        buf.clear()

        // Confirm that we do throw.
        XCTAssertThrowsError(try buf.setString("🤷‍♀️", encoding: .ascii, at: buf.readerIndex)) {
            XCTAssertEqual($0 as? ByteBufferFoundationError, .failedToEncodeString)
        }
        XCTAssertThrowsError(try buf.writeString("🤷‍♀️", encoding: .ascii)) {
            XCTAssertEqual($0 as? ByteBufferFoundationError, .failedToEncodeString)
        }
    }

    func testPossiblyLazilyBridgedString() {
        // won't hit the String writing fast path
        let utf16Bytes = Data([0xfe, 0xff, 0x00, 0x61, 0x00, 0x62, 0x00, 0x63, 0x00, 0xe4, 0x00, 0xe4, 0x00, 0xe4, 0x00, 0x0a])
        let slowString = String(data: utf16Bytes, encoding: .utf16)!

        self.buf.clear()
        let written = self.buf.writeString(slowString as String)
        XCTAssertEqual(10, written)
        XCTAssertEqual("abcäää\n", String(decoding: self.buf.readableBytesView, as: Unicode.UTF8.self))
    }

    func testWithVeryUnsafeMutableBytesWorksOnEmptyByteBuffer() {
        var buf = self.allocator.buffer(capacity: 0)
        XCTAssertEqual(0, buf.capacity)
        buf.withVeryUnsafeMutableBytes { ptr in
            XCTAssertEqual(0, ptr.count)
        }
    }

    func testWithVeryUnsafeMutableBytesYieldsPointerToWholeStorage() {
        var buf = self.allocator.buffer(capacity: 16)
        let capacity = buf.capacity
        XCTAssertGreaterThanOrEqual(capacity, 16)
        buf.writeString("1234")
        XCTAssertEqual(capacity, buf.capacity)
        buf.withVeryUnsafeMutableBytes { ptr in
            XCTAssertEqual(capacity, ptr.count)
            XCTAssertEqual("1234", String(decoding: ptr[0..<4], as: Unicode.UTF8.self))
        }
    }

    func testWithVeryUnsafeMutableBytesYieldsPointerToWholeStorageAndCanBeWritenTo() {
        var buf = self.allocator.buffer(capacity: 16)
        let capacity = buf.capacity
        XCTAssertGreaterThanOrEqual(capacity, 16)
        buf.writeString("1234")
        XCTAssertEqual(capacity, buf.capacity)
        buf.withVeryUnsafeMutableBytes { ptr in
            XCTAssertEqual(capacity, ptr.count)
            XCTAssertEqual("1234", String(decoding: ptr[0..<4], as: Unicode.UTF8.self))
            UnsafeMutableRawBufferPointer(rebasing: ptr[4..<8]).copyBytes(from: "5678".utf8)
        }
        buf.moveWriterIndex(forwardBy: 4)
        XCTAssertEqual("12345678", buf.readString(length: buf.readableBytes))

        buf.withVeryUnsafeMutableBytes { ptr in
            XCTAssertEqual(capacity, ptr.count)
            XCTAssertEqual("12345678", String(decoding: ptr[0..<8], as: Unicode.UTF8.self))
            ptr[0] = "X".utf8.first!
            UnsafeMutableRawBufferPointer(rebasing: ptr[8..<16]).copyBytes(from: "abcdefgh".utf8)
        }
        buf.moveWriterIndex(forwardBy: 8)
        XCTAssertEqual("abcdefgh", buf.readString(length: buf.readableBytes))
        buf.moveWriterIndex(to: 1)
        buf.moveReaderIndex(to: 0)
        XCTAssertEqual("X", buf.getString(at: 0, length: 1))
    }

    func testWithVeryUnsafeMutableBytesDoesCoW() {
        var buf = self.allocator.buffer(capacity: 16)
        let capacity = buf.capacity
        XCTAssertGreaterThanOrEqual(capacity, 16)
        buf.writeString("1234")
        let bufCopy = buf
        XCTAssertEqual(capacity, buf.capacity)
        buf.withVeryUnsafeMutableBytes { ptr in
            XCTAssertEqual(capacity, ptr.count)
            XCTAssertEqual("1234", String(decoding: ptr[0..<4], as: Unicode.UTF8.self))
            UnsafeMutableRawBufferPointer(rebasing: ptr[0..<8]).copyBytes(from: "abcdefgh".utf8)
        }
        buf.moveWriterIndex(forwardBy: 4)
        XCTAssertEqual("1234", String(decoding: bufCopy.readableBytesView, as: Unicode.UTF8.self))
        XCTAssertEqual("abcdefgh", String(decoding: buf.readableBytesView, as: Unicode.UTF8.self))
    }

    func testWithVeryUnsafeMutableBytesDoesCoWonSlices() {
        var buf = self.allocator.buffer(capacity: 16)
        let capacity = buf.capacity
        XCTAssertGreaterThanOrEqual(capacity, 16)
        buf.writeString("1234567890")
        var buf2 = buf.getSlice(at: 4, length: 4)!
        XCTAssertEqual(capacity, buf.capacity)
        let capacity2 = buf2.capacity
        buf2.withVeryUnsafeMutableBytes { ptr in
            XCTAssertEqual(capacity2, ptr.count)
            XCTAssertEqual("5678", String(decoding: ptr[0..<4], as: Unicode.UTF8.self))
            UnsafeMutableRawBufferPointer(rebasing: ptr[0..<4]).copyBytes(from: "QWER".utf8)
        }
        XCTAssertEqual("QWER", String(decoding: buf2.readableBytesView, as: Unicode.UTF8.self))
        XCTAssertEqual("1234567890", String(decoding: buf.readableBytesView, as: Unicode.UTF8.self))
    }

    func testGetDispatchDataWorks() {
        self.buf.clear()
        self.buf.writeString("abcdefgh")

        XCTAssertEqual(0, self.buf.getDispatchData(at: 7, length: 0)!.count)
        XCTAssertNil(self.buf.getDispatchData(at: self.buf.capacity, length: 1))
        XCTAssertEqual("abcdefgh", String(decoding: self.buf.getDispatchData(at: 0, length: 8)!, as: Unicode.UTF8.self))
        XCTAssertEqual("ef", String(decoding: self.buf.getDispatchData(at: 4, length: 2)!, as: Unicode.UTF8.self))
    }

    func testGetDispatchDataReadWrite() {
        var buffer = UnsafeMutableRawBufferPointer.allocate(byteCount: 4, alignment: 0)
        buffer.copyBytes(from: "1234".utf8)
        defer {
            buffer.deallocate()
        }
        self.buf.clear()
        self.buf.writeString("abcdefgh")
        self.buf.writeDispatchData( DispatchData.empty)
        self.buf.writeDispatchData( DispatchData(bytes: UnsafeRawBufferPointer(buffer)))
        XCTAssertEqual(12, self.buf.readableBytes)
        XCTAssertEqual("abcdefgh1234", String(decoding: self.buf.readDispatchData(length: 12)!, as: Unicode.UTF8.self))
        XCTAssertNil(self.buf.readDispatchData(length: 1))
        XCTAssertEqual(0, self.buf.readDispatchData(length: 0)?.count ?? 12)
    }

    func testVariousContiguousStorageAccessors() {
        self.buf.clear()
        self.buf.writeStaticString("abc0123456789efg")
        self.buf.moveReaderIndex(to: 3)
        self.buf.moveWriterIndex(to: 13)

        func inspectContiguousBytes<Bytes: ContiguousBytes>(bytes: Bytes, expectedString: String) {
            bytes.withUnsafeBytes { bytes in
                XCTAssertEqual(expectedString, String(decoding: bytes, as: Unicode.UTF8.self))
            }
        }
        inspectContiguousBytes(bytes: self.buf.readableBytesView, expectedString: "0123456789")
        let r1 = self.buf.readableBytesView.withContiguousStorageIfAvailable { bytes -> String in
            String(decoding: bytes, as: Unicode.UTF8.self)
        }
        XCTAssertEqual("0123456789", r1)

        self.buf.clear()
        inspectContiguousBytes(bytes: self.buf.readableBytesView, expectedString: "")
        let r2 = self.buf.readableBytesView.withContiguousStorageIfAvailable { bytes -> String in
            String(decoding: bytes, as: Unicode.UTF8.self)
        }
        XCTAssertEqual("", r2)
    }

    func testGetBytesThatAreNotReadable() {
        var buf = self.allocator.buffer(capacity: 256)

        // 1) Nothing available
        // no `get*` should work
        XCTAssertNil(buf.getInteger(at: 0, as: UInt8.self))
        XCTAssertNil(buf.getInteger(at: 0, as: UInt16.self))
        XCTAssertNil(buf.getInteger(at: 0, as: UInt32.self))
        XCTAssertNil(buf.getInteger(at: 0, as: UInt64.self))
        XCTAssertNil(buf.getString(at: 0, length: 1))
        XCTAssertNil(buf.getSlice(at: 0, length: 1))
        XCTAssertNil(buf.getData(at: 0, length: 1))
        XCTAssertNil(buf.getDispatchData(at: 0, length: 1))
        XCTAssertNil(buf.getBytes(at: 0, length: 1))
        XCTAssertNil(buf.getString(at: 0, length: 1, encoding: .utf8))
        XCTAssertNil(buf.viewBytes(at: 0, length: 1))

        // but some `get*` should be able to produce empties
        XCTAssertEqual("", buf.getString(at: 0, length: 0))
        XCTAssertEqual(0, buf.getSlice(at: 0, length: 0)?.capacity)
        XCTAssertEqual(Data(), buf.getData(at: 0, length: 0))
        XCTAssertEqual(0, buf.getDispatchData(at: 0, length: 0)?.count)
        XCTAssertEqual([], buf.getBytes(at: 0, length: 0))
        XCTAssertEqual("", buf.getString(at: 0, length: 0, encoding: .utf8))
        XCTAssertEqual("", buf.viewBytes(at: 0, length: 0).map { String(decoding: $0, as: Unicode.UTF8.self) })

        // 2) One byte available at the beginning
        buf.writeInteger(0x41, as: UInt8.self)

        // for most `get*`s, we can make them just not work
        XCTAssertNil(buf.getInteger(at: 0, as: UInt16.self))
        XCTAssertNil(buf.getInteger(at: 0, as: UInt32.self))
        XCTAssertNil(buf.getInteger(at: 0, as: UInt64.self))
        XCTAssertNil(buf.getString(at: 0, length: 2))
        XCTAssertNil(buf.getSlice(at: 0, length: 2))
        XCTAssertNil(buf.getData(at: 0, length: 2))
        XCTAssertNil(buf.getDispatchData(at: 0, length: 2))
        XCTAssertNil(buf.getBytes(at: 0, length: 2))
        XCTAssertNil(buf.getString(at: 0, length: 2, encoding: .utf8))
        XCTAssertNil(buf.viewBytes(at: 0, length: 2))

        XCTAssertNil(buf.getInteger(at: 1, as: UInt8.self))
        XCTAssertNil(buf.getInteger(at: 1, as: UInt16.self))
        XCTAssertNil(buf.getInteger(at: 1, as: UInt32.self))
        XCTAssertNil(buf.getInteger(at: 1, as: UInt64.self))
        XCTAssertNil(buf.getString(at: 1, length: 1))
        XCTAssertNil(buf.getSlice(at: 1, length: 1))
        XCTAssertNil(buf.getData(at: 1, length: 1))
        XCTAssertNil(buf.getDispatchData(at: 1, length: 1))
        XCTAssertNil(buf.getBytes(at: 1, length: 1))
        XCTAssertNil(buf.getString(at: 1, length: 1, encoding: .utf8))
        XCTAssertNil(buf.viewBytes(at: 1, length: 1))

        // on the other hand, we should be able to take that one byte out
        XCTAssertEqual(0x41, buf.getInteger(at: 0, as: UInt8.self))
        XCTAssertEqual("A", buf.getString(at: 0, length: 1))
        XCTAssertEqual(1, buf.getSlice(at: 0, length: 1)?.capacity)
        XCTAssertEqual(Data("A".utf8), buf.getData(at: 0, length: 1))
        XCTAssertEqual(1, buf.getDispatchData(at: 0, length: 1)?.count)
        XCTAssertEqual(["A".utf8.first!], buf.getBytes(at: 0, length: 1))
        XCTAssertEqual("A", buf.getString(at: 0, length: 1, encoding: .utf8))
        XCTAssertEqual("A", buf.viewBytes(at: 0, length: 1).map { String(decoding: $0, as: Unicode.UTF8.self) })

        // 3) Now let's have 4 bytes towards the end

        // we can make pretty much all `get*`s fail
        buf.setInteger(0x41414141, at: 251, as: UInt32.self)
        buf.moveWriterIndex(to: 255)
        buf.moveReaderIndex(to: 251)
        XCTAssertNil(buf.getInteger(at: 251, as: UInt64.self))
        XCTAssertNil(buf.getString(at: 251, length: 5))
        XCTAssertNil(buf.getSlice(at: 251, length: 5))
        XCTAssertNil(buf.getData(at: 251, length: 5))
        XCTAssertNil(buf.getDispatchData(at: 251, length: 5))
        XCTAssertNil(buf.getBytes(at: 251, length: 5))
        XCTAssertNil(buf.getString(at: 251, length: 5, encoding: .utf8))
        XCTAssertNil(buf.viewBytes(at: 251, length: 5))

        XCTAssertEqual(0x41, buf.getInteger(at: 254, as: UInt8.self))
        XCTAssertEqual(0x4141, buf.getInteger(at: 253, as: UInt16.self))
        XCTAssertEqual(0x41414141, buf.getInteger(at: 251, as: UInt32.self))
        XCTAssertEqual("AAAA", buf.getString(at: 251, length: 4))
        XCTAssertEqual(4, buf.getSlice(at: 251, length: 4)?.capacity)
        XCTAssertEqual(Data("AAAA".utf8), buf.getData(at: 251, length: 4))
        XCTAssertEqual(4, buf.getDispatchData(at: 251, length: 4)?.count)
        XCTAssertEqual(Array(repeating: "A".utf8.first!, count: 4), buf.getBytes(at: 251, length: 4))
        XCTAssertEqual("AAAA", buf.getString(at: 251, length: 4, encoding: .utf8))
        XCTAssertEqual("AAAA", buf.viewBytes(at: 251, length: 4).map { String(decoding: $0, as: Unicode.UTF8.self) })
    }

    func testByteBufferViewAsDataProtocol() {
        func checkEquals<D: DataProtocol>(expected: String, actual: D) {
            var actualBytesAsArray: [UInt8] = []
            for region in actual.regions {
                actualBytesAsArray += Array(region)
            }
            XCTAssertEqual(expected, String(decoding: actualBytesAsArray, as: Unicode.UTF8.self))
        }
        var buf = self.allocator.buffer(capacity: 32)
        buf.writeStaticString("0123abcd4567")
        buf.moveReaderIndex(forwardBy: 4)
        buf.moveWriterIndex(to: buf.writerIndex - 4)
        checkEquals(expected: "abcd", actual: buf.readableBytesView)
    }
}

private enum AllocationExpectationState: Int {
    case begin
    case mallocDone
    case reallocDone
    case freeDone
}

private var testAllocationOfReallyBigByteBuffer_state = AllocationExpectationState.begin
private func testAllocationOfReallyBigByteBuffer_freeHook(_ ptr: UnsafeMutableRawPointer?) -> Void {
    precondition(AllocationExpectationState.reallocDone == testAllocationOfReallyBigByteBuffer_state)
    testAllocationOfReallyBigByteBuffer_state = .freeDone
    /* free the pointer initially produced by malloc and then rebased by realloc offsetting it back */
    free(ptr?.advanced(by: Int(Int32.max)))
}

private func testAllocationOfReallyBigByteBuffer_mallocHook(_ size: Int) -> UnsafeMutableRawPointer? {
    precondition(AllocationExpectationState.begin == testAllocationOfReallyBigByteBuffer_state)
    testAllocationOfReallyBigByteBuffer_state = .mallocDone
    /* return a 16 byte pointer here, good enough to write an integer in there */
    return malloc(16)
}

private func testAllocationOfReallyBigByteBuffer_reallocHook(_ ptr: UnsafeMutableRawPointer?, _ count: Int) -> UnsafeMutableRawPointer? {
    precondition(AllocationExpectationState.mallocDone == testAllocationOfReallyBigByteBuffer_state)
    testAllocationOfReallyBigByteBuffer_state = .reallocDone
    /* rebase this pointer by -Int32.max so that the byte copy extending the ByteBuffer below will land at actual index 0 into this buffer ;) */
    return ptr!.advanced(by: -Int(Int32.max))
}

private func testAllocationOfReallyBigByteBuffer_memcpyHook(_ dst: UnsafeMutableRawPointer, _ src: UnsafeRawPointer, _ count: Int) -> Void {
    /* not actually doing any copies */
}


private var testReserveCapacityLarger_reallocCount = 0
private var testReserveCapacityLarger_mallocCount = 0
private func testReserveCapacityLarger_freeHook( _ ptr: UnsafeMutableRawPointer?) -> Void {
    free(ptr)
}

private func testReserveCapacityLarger_mallocHook(_ size: Int) -> UnsafeMutableRawPointer? {
    testReserveCapacityLarger_mallocCount += 1
    return malloc(size)
}

private func testReserveCapacityLarger_reallocHook(_ ptr: UnsafeMutableRawPointer?, _ count: Int) -> UnsafeMutableRawPointer? {
    testReserveCapacityLarger_reallocCount += 1
    return realloc(ptr, count)
}

private func testReserveCapacityLarger_memcpyHook(_ dst: UnsafeMutableRawPointer, _ src: UnsafeRawPointer, _ count: Int) -> Void {
    // No copying
}
