//
//  TestPoint.swift
//  Mapping
//
//  Created by Casey on 29/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation


class Person {
    
    var age = 1
    var info = PersonInfo()
    var sex = 0
    
    
}


class PersonInfo {
    
    var width = 3
    var height = 4
    
    
}

func TestPoint()  {
    
    
    var person = Person()
    withUnsafePointer(to: &person) { ptr in
        
        
        ptr.withMemoryRebound(to: Int.self, capacity: 1, { intPtr in
            
            
            let offset =  MemoryLayout<Int>.size
            let base = intPtr.advanced(by: offset)
            
            let contextDesc = UnsafeRawPointer(base).assumingMemoryBound(to: PersonInfo.self)
            
            
            
        })
        
        
        
        
        
        
    }
    
    
    
    //print(contextDesc.pointee)
    
}
