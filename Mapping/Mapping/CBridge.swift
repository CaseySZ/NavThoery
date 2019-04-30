//
//  CBridge.swift
//  Mapping
//
//  Created by Casey on 27/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation


/*
 在这部分代码中, 看到了我们比较熟悉的 _getFieldAt 方法, 这个方法曾今在 Mirror 被使用过, 获取字段信息. 在 Swift 代码中要访问 C++ 代码, 需要加上 @_silgen_name
 https://www.jianshu.com/p/ceeb6dbae083
 */
@_silgen_name("swift_getFieldAt")
func _getFieldAt(
    _ type: Any.Type,
    _ index: Int,
    _ callback: @convention(c) (UnsafePointer<CChar>, UnsafeRawPointer, UnsafeMutableRawPointer) -> Void,
    _ ctx: UnsafeMutableRawPointer
)


