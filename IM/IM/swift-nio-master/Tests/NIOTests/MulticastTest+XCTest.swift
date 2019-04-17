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
//
// MulticastTest+XCTest.swift
//
import XCTest

///
/// NOTE: This file was generated by generate_linux_tests.rb
///
/// Do NOT edit this file directly as it will be regenerated automatically when needed.
///

extension MulticastTest {

   static var allTests : [(String, (MulticastTest) -> () throws -> Void)] {
      return [
                ("testCanJoinBasicMulticastGroupIPv4", testCanJoinBasicMulticastGroupIPv4),
                ("testCanJoinBasicMulticastGroupIPv6", testCanJoinBasicMulticastGroupIPv6),
                ("testCanLeaveAnIPv4MulticastGroup", testCanLeaveAnIPv4MulticastGroup),
                ("testCanLeaveAnIPv6MulticastGroup", testCanLeaveAnIPv6MulticastGroup),
           ]
   }
}

