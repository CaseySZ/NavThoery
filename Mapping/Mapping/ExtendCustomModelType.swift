//
//  ExtendCustomModelType.swift
//  Mapping
//
//  Created by Casey on 27/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation

public protocol _ExtendCustomModelType: _Transformable {
    init()
}



extension _ExtendCustomModelType {
    
    mutating func headPointerOfClass() -> UnsafeMutablePointer<Byte> {
        
        let opaquePointer = Unmanaged.passUnretained(self as AnyObject).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Byte.self, capacity: MemoryLayout<Self>.stride)
        return UnsafeMutablePointer<Byte>(mutableTypedPointer)
    }
    
    static func _transform(_ dict: [String:Any]) -> _ExtendCustomModelType?  {
        
        var instance:Self = Self.init()
        
        
        _transform(dict, to: &instance)
        
        return instance;
    }
    
    
    static func _transform(_ dict: [String: Any], to instance: inout Self) {
        
        // 1 获取到属性的名称和类型
        guard let properties = getProperties(forType: Self.self) else {
            print("Failed when try to get properties from type: \(type(of: Self.self))")
            return
        }
        
        /* 2 找到实例在内存中的 headPointer, 通过属性的类型计算内存中的偏移值, 确定属性在内存中的位置.
         拿到头指针后, 我们可以直接根据实例的头指针以及每个属性的偏移值, 获取到每个属性在内存中的位置
         */
        
        let rawPointer = instance.headPointerOfClass()
                  
        
        for property in properties {
            
            
            /* 3获取对应变量的地址
             
             */
            
            let propAddr = rawPointer.advanced(by: property.offset)
            
            // 4 获取对应类型的值
            if let convertedValue = convertValue(rawValue: dict[property.key], propertyType: property.type)  {
                
                // 5 在内存中为属性赋值.
                extensions(of: property.type).write(convertedValue, to: propAddr)
                continue
            }
            
        }
        
        
    }
    
    
    
}



fileprivate func convertValue(rawValue: Any, propertyType: Any.Type) -> Any? {
    
    if rawValue is NSNull { return nil }
    
    if let transformableType = propertyType as? _Transformable.Type {
    
        return transformableType.transform(from: rawValue)
        
        
    } else {
        
        return nil
    }
}





