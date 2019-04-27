//
//  BuiltInBasicType.swift
//  Mapping
//
//  Created by Casey on 27/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation


public protocol _Transformable {
    
}


public extension _Transformable {
    
    public static func transform(from object: Any) -> Self? {
        
        if let typedObject = object as? Self {
            return typedObject
        }
        
        // 根据不同类型做转换
        switch self {
            
        case let type as IntegerPropertyProtocol.Type:
            return type._transform(from: object) as? Self
        case let type as _BuiltInBasicType.Type:
            return type._transform(from: object) as? Self
        default:
            return nil
        }
    }
}

protocol _BuiltInBasicType:_Transformable {
    
    static func _transform(from object: Any) -> Self?
}

//////////////// 整数类型处理
extension Int: IntegerPropertyProtocol {}
extension UInt: IntegerPropertyProtocol {}
extension Int8: IntegerPropertyProtocol {}
extension Int16: IntegerPropertyProtocol {}
extension Int32: IntegerPropertyProtocol {}
extension Int64: IntegerPropertyProtocol {}
extension UInt8: IntegerPropertyProtocol {}
extension UInt16: IntegerPropertyProtocol {}
extension UInt32: IntegerPropertyProtocol {}
extension UInt64: IntegerPropertyProtocol {}


protocol IntegerPropertyProtocol: _BuiltInBasicType {
    
    init?(_ text: String, radix: Int)
}

extension IntegerPropertyProtocol {
    
    static func _transform(from object: Any) -> Self? {
        switch object {
        case let str as String:
            var test = Self(str, radix: 10)
           // test = Int(str) as? Self
            return test
        default:
            return nil
        }
    }
    
}


////////////////
extension Optional:_BuiltInBasicType{
    
    static func _transform(from object: Any) -> Optional? {
        if let value = (Wrapped.self as? _Transformable.Type)?.transform(from: object) as? Wrapped {
            return Optional(value)
        } else if let value = object as? Wrapped {
            return Optional(value)
        }
        return nil
    }
    
}

////////////////
extension String: _BuiltInBasicType {
    
    static func _transform(from object: Any) -> String? {
        switch object {
        case let str as String:
            return str
        case let num as NSNumber:
           return num.description
        case _ as NSNull:
            return nil
        default:
            return "\(object)"
        }
    }
    
}



