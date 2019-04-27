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
    
    
    
    let pointer =  unsafeBitCast(type, to: UnsafePointer<Int>.self)
    var result: [Property.Description] = []
    let selfType = unsafeBitCast(pointer, to: Any.Type.self)
    let offset = 8
//    if is64BitPlatform {
//        offset = 11
//    }
    
    let base =  pointer.advanced(by: offset)
    if base.pointee == 0 {
        
        return nil
    }
    
    let contextDesc = relativePointer(base: base, offset: base.pointee - Int(bitPattern: base))

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











