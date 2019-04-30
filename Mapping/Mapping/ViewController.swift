//
//  ViewController.swift
//  Mapping
//
//  Created by Casey on 27/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

/*
 
 Metadata 官方文档
 
 https://github.com/apple/swift/blob/master/docs/ABI/TypeMetadata.rst
 
 
 */

// https://www.jianshu.com/p/ea64c84172fb  ⚠️

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
      //  SwiftPoint().unsafeMutablePointer()
      //  SwiftPoint().reboundType()
      //  SwiftPoint().bufferPointer()
       // SwiftPoint().rawPointer()
       // SwiftPoint().memoryAccess()
       // SwiftPoint().unmanage()
        
       // SwiftPoint().applyStruct()
       // SwiftPoint().applyClass()
        SwiftPoint().autoOCPoint()
       // memoryLayout()
        return
        
        var dict = [String:Any]()
        dict["id"] = "1234"
        dict["name"] = "cc"
        dict["age"] = "10"
        dict["height"] = "180"
        dict["className"] = "aa"
        dict["seat"] = "1"
        
        if let student =  Student.deserialize(dict) {
            
            print(student)
            
        }
        
    }
}


class Student: HandyJson {
    var id: Int?
    var name: String?
    var age: Int?
    var height: Int = 0
    var className: String?
    var seat: String?
    
    required init() {}
}

