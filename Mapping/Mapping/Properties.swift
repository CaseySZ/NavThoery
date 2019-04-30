//
//  Properties.swift
//  Mapping
//
//  Created by Casey on 27/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation

var is64BitPlatform: Bool {
    return MemoryLayout<Int>.size == MemoryLayout<Int64>.size
}

struct Property {
    
    let key: String
    let value: Any
    
    struct Description {
        
        public let key: String
        public let type: Any.Type
        public let offset: Int
        
//        public func write(_ value: Any, to storage: UnsafeMutableRawPointer) {
//            return extensions(of: type).write(value, to: storage.advanced(by: offset))
//        }
        
    }
}


func getProperties(forType type: Any.Type) -> [Property.Description]? {
    
    
    // 1.1 类型转化
    let pointer =  unsafeBitCast(type, to: UnsafePointer<Int>.self)
    
    /*
     这是 64 位系统下的 metadata 结构，32 位系统下 nominal type descriptor 的偏移在 11 个指针长度的位置
    */
    let offset = 8
//    if is64BitPlatform {
//        offset = 11
//    }
    
    let base =  pointer.advanced(by: offset)
    if base.pointee == 0 {
        
        return nil
    }
   /*
     https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst
     第一行 metadata ..... cluding every instantiation of generic types 包含类型
     metadata对象文档第三行：  these metadata records are generated statically by the compiler
     编译的时候生成statically，并且metadata records are lazily created by the runtime as required. 是懒加载的形式
     */
    // 相对指针偏移值 (base.pointee是指向metadata值) ，算出这个对象地址和当前base地址的内存地址距离，通过相对位置找到这个statically对象地址
    let relativePointerOffset = base.pointee - Int(bitPattern: base)
    print("relativePointerOffset:\(relativePointerOffset), pointer: \(pointer.pointee), \(Int(bitPattern: base)), base.pointee:\(base.pointee), base:\(base),")
 
  //  let contextDesc = relativePointer(base: base, offset: relativePointerOffset)
    
    
    
    // 以 _ClassContextDescriptor 类型访问数据， 获取类型结构, _ClassContextDescriptor内部结构来源于 Swift 源码中
    // po UnsafeRawPointer(base).advanced(by: relativePointerOffset) 看指向的地址值
    let contextDesc = UnsafeRawPointer(base).advanced(by: relativePointerOffset).assumingMemoryBound(to: _ClassContextDescriptor.self)
    
    //var fieldOffsets:[Int]? =
    
    let vectorOffset = contextDesc.pointee.fieldOffsetVector
    let fieldOffsets = (0..<contextDesc.pointee.numberOfFields).map {
        return UnsafePointer<Int>(pointer)[Int(vectorOffset) + Int($0)]
    }

    print(fieldOffsets)
    
    
    class NameAndType {
        var name: String?
        var type: Any.Type?
    }
    
    
    // 属性的包装
    var result: [Property.Description] = []
    
    // 类对象
    let selfType = unsafeBitCast(pointer, to: Any.Type.self)
    // 获取属性信息
    for index in 0..<Int(contextDesc.pointee.numberOfFields) {
        
        var nameAndType = NameAndType()
        
        _getFieldAt(selfType, index, { (name, type, nameAndTypePtr) in
            let name = String(cString: name)
            let type = unsafeBitCast(type, to: Any.Type.self)
            nameAndTypePtr.assumingMemoryBound(to: NameAndType.self).pointee.name = name
            nameAndTypePtr.assumingMemoryBound(to: NameAndType.self).pointee.type = type
        }, &nameAndType)
        
        if let name = nameAndType.name, let type = nameAndType.type {
            
            result.append(Property.Description(key: name, type: type, offset: fieldOffsets[index]))
        }
        
        
        
    }
    
    
    let mdPointer =  unsafeBitCast(type, to: UnsafePointer<_Metadata._Class>.self)
    let instanceStart = mdPointer.pointee.class_rw_t()?.pointee.class_ro_t()?.pointee.instanceStart // 实例的便宜位置纠正 
    
    
    return result
    
}











