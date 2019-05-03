//
//  SwfitPointer.swift
//  Mapping
//
//  Created by Casey on 30/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation

/*
 
 1 Swift中的指针分为两类, typed pointer 指定数据类型指针, raw pointer 未指定数据类型的指针(原生指针)
 
 
 c类型                        swift类型
 const Type *           UnsafePointer<Type>                 指针可变，指针指向的内存值不可变。
 Type *                 UnsafeMutablePointer<Type>          指针和指针指向的内存值均可变。
 ClassType * const *    UnsafePointer<UnsafePointer<Type>>          指针的指针：指针不可变，指针指向的类可变。
 ClassType **           UnsafeMutablePointer<UnsafeMutablePointer<Type> >   指针的指针：指针和指针指向的类均可变。
 ClassType **           AutoreleasingUnsafeMutablePointer<Type>         作为OC方法中的指针参数
 const void *           UnsafeRawPointer                                指针指向的内存区,类型未定。
 void *                 UnsafeMutableRawPointer  指针指向的内存区,类型未定。
 StructType *           OpaquePointer    c语言中的一些自定义类型，Swift中并未有相对应的类型。
 int a[]                UnsafeBufferPointer/UnsafeMutableBufferPointer    可以理解为一种数组指针
 */


struct CCInfo {
    
    var name:String = "1"
    var age:Int = 0
    var sex = true
    
}

class SwiftPoint {
    
    func unsafeMutablePointer()  {
        
        // 分配内存
        let point = UnsafeMutablePointer<Int>.allocate(capacity: MemoryLayout<Int>.stride)
       // let point = UnsafeMutablePointer<CCInfo>.allocate(capacity: MemoryLayout.stride(ofValue: CCInfo()))
       
        // 初始化  对于Int, Float, Double这些基本数据类型, 分配内存之后会有默认值0
        point.initialize(to: 12)
        
        // 赋值
        point.pointee = 10
        
        
        print(point.pointee)
        
        // 释放内存, 与allocate对应
        point.deallocate()
        
    }
    
    
    func unsafeMutblePointerFromAddress()  {
     
        // 通过地址值，生成
        if let pointt = UnsafeMutablePointer<Int>.init(bitPattern: 10) {
            
            print(pointt.pointee)
        
        }
    }
    
    
    func reboundType()  {
        
        
        var int8: Int8 = 123
        let int8Pointer = UnsafeMutablePointer(&int8)
        
        // 将内存临时重新绑定到其他类型
        int8Pointer.withMemoryRebound(to: Int.self, capacity: 8) { ptr in
            print(ptr.pointee)
        }
        
        
        //将内存永久重新绑定到其他类型， 用到了指向内存的原始指针
        let intPointer = UnsafeRawPointer(int8Pointer).bindMemory(to: Int.self, capacity: 1)
        print(intPointer.pointee)
        
        
    }
    
    func  bufferPointer() {
        
        // 用于连续存储在内存中的元素缓冲区, UnsafeBufferPointer 用于处理不可变的元素缓冲区, UnsafeMutableBufferPointer 用于处理可变的元素缓冲区
        
        var array = [1, 2, 3, 4]
        
        // 遍历
        let ptr = UnsafeBufferPointer.init(start: &array, count: array.count)
        
        ptr.forEach { element in
            print(element)
        }
        
        //遍历
        array.withUnsafeBufferPointer {  ptr in
            
            ptr.forEach {
                
                print($0)
            }
        }
        
    }
    
    
    func rawPointer() {
        
        // UnsafeRawPointer 用于 访问 非类型化数据的原始指针
        // UnsafeRawBufferPointer 用于 访问 和 操作 非类型化数据的原始指针
        
        
        // 访问不同类型的 相同内存
        var uint64: UInt64 = 257
        let rawPointer = UnsafeRawPointer(UnsafeMutablePointer(&uint64))
        let int64PointerT =  rawPointer.load(as: Int64.self)
        let uint8Point = rawPointer.load(as: UInt8.self)
        
        print(int64PointerT)
        print(uint8Point)
        
        // 257  = 1 0000 0001 而UInt8 表示存储8个位的无符号整数，即一个字节大小, 2^8 = 256, [0, 255]， 超出8个位范围的无法加载，所以打印为1
        
        
        //分配内存
        let bytePoint = UnsafeMutableRawPointer.allocate(byteCount: 4, alignment: 1)
        
        // 将给定值存储在指定偏移量的原始内存中
        bytePoint.storeBytes(of: 0x00060001, as: UInt32.self)
        
        // 从bytePoint引用的内存  用UInt8实例加载（即第一个字节用UInt8实例加载）
        let value = bytePoint.load(as: UInt8.self)
        print(value)
        
        let offsetPoint = bytePoint.advanced(by: 2)
       // let offsetPoint = bytePoint + 2 // 偏移 2个字节, 如果偏移3个字节，下面的操作就会越界了
        let offsetValue = offsetPoint.load(as: UInt16.self) // 将第三个和第四个字节作为UInt16实例加载
        
        
        print(offsetValue)
        
        bytePoint.deallocate()
        
        /*
         总结
         1 UnsafeRawBufferPointer / UnsafeMutableRawBufferPointer 实例是内存区域中原始字节的视图.
         2 内存中的每个字节都被视为一个UInt8值, 与该内存中保存的值的类型无关
         3 通过原始缓冲区从内存中读取是一种无类型操作, UnsafeMutableRawBufferPointer 实例可以写入内存, UnsafeRawBufferPointer 实例不可以
         4 如果要类型化，必须将内存绑定到一个类型上
         */
        
    }
    
    // 内存访问
    func memoryAccess()  {
        
       
        var a = 0
        scanceAddress(&a)
        a = withUnsafePointer(to: &a, { ptr  in
            return ptr.pointee + 2 // 此时, 会新开辟空间, 令a指向新地址, 值为2
        })
        print(a)
        scanceAddress(&a)
        
        
        // 修改指针指向的内存值
        var b = 0
        scanceAddress(&b)
        withUnsafeMutablePointer(to: &b) {
            $0.pointee += 10 // 未开辟新的内存空间, 直接修改a所指向的内存值
        }
        print(b)
        scanceAddress(&b)
        
        // 修改内存值
        var arr = [1, 2, 3]
        withUnsafeMutablePointer(to: &arr) { ptr in
            
            ptr.pointee[0] = 5
        }
        print(arr)
        
        // 修改内存值
        arr.withUnsafeMutableBufferPointer{ ptr in
        
            ptr[1] = 20
        }
        
        print(arr)
        
        
        let str = "12345"
        let strData = str.data(using: .utf8)!
        strData.withUnsafeBytes ({ (ptr:(UnsafePointer<Int8>)) in
            
            print(ptr.pointee) // ascii
            print(ptr.advanced(by: 1).pointee)
            print(ptr.advanced(by: 2).pointee)
            print(ptr.advanced(by: 3).pointee)
        })
        
    }
    
    
    func unmanage()  {
        
        let str = "123456" // 结构每次地址值都是一样的
        // 转化为 unmanaged 对象引用
        let unmanageObj =  Unmanaged.passUnretained(str as AnyObject)
        // 将 unmanaged class reference 转化 为pointer
        let ptr = unmanageObj.toOpaque()
        //  打印内存地址
        print(ptr.debugDescription)
        
    }
    
    
    //  打印内存地址
    func scanceAddress(_ pointer: UnsafeRawPointer) {
        
        print("address:\(pointer.debugDescription)")
        
    }
    
    /*
     以上， 知道一个类的实例内存分布情况 和 这个实例的内存地址
     那么就可以 通过指针，对内存操作，为对象的属性分别赋值
     */
    func applyStruct()  {
        
        struct InPerson {
            
            var name:String = ""
            var age:Int = 0
            var men:Bool = false
        }
        
        var personStruct = InPerson()
        
        // 获得头部指针
        let pStructHeadP = withUnsafeMutablePointer(to: &personStruct, {
            
            return UnsafeMutableRawPointer($0).bindMemory(to: Int8.self, capacity: MemoryLayout<Person>.stride)
        })
        
    
        // 将 headPointer 转化为 rawPointer, 方便移位操作
        let pStructHeadRawP = UnsafeMutableRawPointer(pStructHeadP)
        
        // 每个属性在内存中的位置
        let namePosition = 0
        let agePosition = namePosition + MemoryLayout<String>.stride
        let isBoyPosition = agePosition + MemoryLayout<Int>.stride
        
        // 将内存临时重新绑定到其他类型进行访问.
        let namePtr = pStructHeadRawP.advanced(by: namePosition).assumingMemoryBound(to: String.self)
        let agePtr = pStructHeadRawP.advanced(by: agePosition).assumingMemoryBound(to: Int.self)
        let menPtr = pStructHeadRawP.advanced(by: isBoyPosition).assumingMemoryBound(to: Bool.self)
        
        // 设置属性值
        namePtr.pointee = "cc"
        agePtr.pointee = 18
        menPtr.pointee = false
        
        
        print("\(personStruct.name), \(personStruct.age), \(personStruct.men)")
        
        
    }
    
    
    func applyClass()  {
        
        
        
        let personClass = InPersonInfoC()
        
        // 获得头部指针
        let pClassHeadRawP = Unmanaged.passUnretained(personClass as AnyObject).toOpaque()

        // 每个属性在内存中的位置
        let namePosition = 16 // class 类型实例需要有一块单独区域存储类型信息type 和 引用计数refCount (meta数据).
        let agePosition = namePosition + MemoryLayout<String>.stride
        let isBoyPosition = agePosition + MemoryLayout<Int>.stride

        // 将内存临时重新绑定到其他类型进行访问.
        let namePtr = pClassHeadRawP.advanced(by: namePosition).assumingMemoryBound(to: String.self)
        let agePtr = pClassHeadRawP.advanced(by: agePosition).assumingMemoryBound(to: Int.self)
        let menPtr = pClassHeadRawP.advanced(by: isBoyPosition).assumingMemoryBound(to: Bool.self)

        // 设置属性值
        namePtr.pointee = "cc"
        agePtr.pointee = 18
        menPtr.pointee = false
        
        
        print("\(personClass.name), \(personClass.age), \(personClass.men)")
        

        
    }
    
    // AutoreleasingUnsafeMutablePointer 这个指针通常是用来作为OC方法中的指针参数, 在Swift中调用
    func autoOCPoint()  {
        
        // 定义一个指针, 分配内存, 指针和指针指向的类均可变。
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: 20000)
        // 创建 AutoreleasingUnsafeMutablePointer
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        // 将原缓存区的数据拷贝到types所指向的那块内存
        let count =  objc_getClassList(autoreleasingTypes, Int32(20000))
        
        
        let classArrPoint =  UnsafeMutableRawPointer(mutating: autoreleasingTypes)
        
        let size = MemoryLayout<AnyClass>.size
        for index in 0...Int(count-1) {
            
            let point = classArrPoint.advanced(by: index*size)
            print(point.load(as: AnyClass.self))
        }
        
        print(count)
    }
    
}

class InPersonInfoC {
    
    var name:String = ""
    var age:Int = 0
    var men:Bool = false
    
    init() {}
}


