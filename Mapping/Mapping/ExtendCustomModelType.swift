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
        
        guard let properties = getProperties(forType: Self.self) else {
            print("Failed when try to get properties from type: \(type(of: Self.self))")
            return
        }
        
        let rawPointer = instance.headPointerOfClass()
                  
        
        for property in properties {
            
            
            let propAddr = rawPointer.advanced(by: property.offset)
            
            
            if let convertedValue = convertValue(rawValue: dict[property.key], propertyType: property.type)  {
                
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





