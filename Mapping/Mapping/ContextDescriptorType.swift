//
//  ContextDescriptorType.swift
//  Mapping
//
//  Created by Casey on 27/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation

// 以 _ClassContextDescriptor 类型访问数据
func relativePointer<T, U>(base: UnsafePointer<T>, offset: U) -> UnsafePointer<_ClassContextDescriptor> where U : FixedWidthInteger {
    return UnsafeRawPointer(base).advanced(by: Int(integer: offset)).assumingMemoryBound(to: _ClassContextDescriptor.self)
}


extension Int {
    fileprivate init<T : FixedWidthInteger>(integer: T) {
        switch integer {
        case let value as Int: self = value
        case let value as Int32: self = Int(value)
        case let value as Int16: self = Int(value)
        case let value as Int8: self = Int(value)
        default: self = 0
        }
    }
}


/*
 以 _StructContextDescriptor 类型访问内存数据, 得到属性数量 numberOfFields, 属性偏移矢量 fieldOffsetVector, 通过这两个参数可以获取每个属性的偏移值
 内部结构来源于 Swift 源码中
 
 https://github.com/apple/swift/blob/master/include/swift/ABI/Metadata.h#L3416
 
 */
/*
 文章：
 https://blog.csdn.net/weixin_33758863/article/details/88060638
 
 */
//
struct _StructContextDescriptor: _ContextDescriptorProtocol {
    var flags: Int32
    var parent: Int32
    var mangledName: Int32
    var fieldTypesAccessor: Int32
    var numberOfFields: Int32
    var fieldOffsetVector: Int32
}


struct _ClassContextDescriptor: _ContextDescriptorProtocol {
    var flags: Int32
    var parent: Int32
    var mangledName: Int32
    var fieldTypesAccessor: Int32
    var superClsRef: Int32
    var reservedWord1: Int32
    var reservedWord2: Int32
    var numImmediateMembers: Int32
    var numberOfFields: Int32
    var fieldOffsetVector: Int32
    
    
}


protocol _ContextDescriptorProtocol {
    var mangledName: Int32 { get }
    var numberOfFields: Int32 { get }
    var fieldOffsetVector: Int32 { get }
    var fieldTypesAccessor: Int32 { get }
}


