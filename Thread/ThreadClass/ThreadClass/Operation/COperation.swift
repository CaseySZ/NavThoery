//
//  COperation.swift
//  ThreadClass
//
//  Created by Casey on 06/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

/*
  只重写main 不管要管理Operation的状态， operation的状态
重写start 需要管理Operation状态， isFinished为true的时候，队列认为这个op任务结束了
*/

class COperation: Operation {

    
    
    
    override func main() {
        
        print("main")
    }
    
 
  
    var _isFinished:Bool = false
    override open var isFinished: Bool {
        get {
            return _isFinished
        }
    }
    
    
    override func start() {
        
        print("start")
        
        _isFinished = true
     
    }
    
    deinit {
        print("COperation deinit")
    }
    
}
