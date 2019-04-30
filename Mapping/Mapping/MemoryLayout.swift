//
//  MemoryLayout.swift
//  Mapping
//
//  Created by Casey on 30/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation

struct HomeInfo {
    
    var name: String = ""
    var age: Int = 1
    var isEx: Bool = false
}

class CompanyInfo {
    
    var name: String = ""
    var age: Int = 1
    var isEx: Bool = false
    
}


func memoryLayout()  {
    
    
    print(MemoryLayout<HomeInfo>.size)
    print(MemoryLayout<HomeInfo>.stride)
    
    print(MemoryLayout<CompanyInfo>.size)
    print(MemoryLayout<CompanyInfo>.stride)
    
    
    print(MemoryLayout<HomeInfo>.alignment)
    print(MemoryLayout<CompanyInfo>.alignment)
    
    
}

/*
 
 size 实际内存占用, stride 这个内存区域占用的大小
 
 alignment, 默认内存对齐方式.
 
 class 是引用类型，生成的实例分布在 Heap(堆) 内存区域上，在 Stack(栈)只存放着一个指向堆中实例的指针.
 所以MemoryLayout<CompanyInfo>.size 才是 8, 这里是栈中存放的指针的大小
 
 */

