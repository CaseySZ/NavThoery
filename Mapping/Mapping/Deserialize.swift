//
//  Deserialize.swift
//  Mapping
//
//  Created by Casey on 27/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation

typealias Byte = Int8

public protocol HandyJson: _ExtendCustomModelType {
    
}


extension HandyJson {
    
    
    
    public static func deserialize(_ dict:[String: Any]?) -> Self? {
        
        
        
        return JSON<Self>.deserializeFrom(dict)
        
    }
    
    

    
}


public class JSON<T:HandyJson> {
    
    
    public static func deserializeFrom(_ dict: [String: Any]?) -> T? {
        
        
        if let targetDict = dict {
            
            return T._transform(targetDict) as? T
            
        }else {
        
            return nil
        }
    }
    
   
}






