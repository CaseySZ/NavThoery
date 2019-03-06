//
//  CancelOperation.swift
//  ThreadClass
//
//  Created by Casey on 06/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class CancelOperation: Operation {

    
    
    override func main() {
        
        
        // 通过 设置取消埋点 来取消 任务
        print("start")
        for index in 0...5 {
            if self.isCancelled {
                break;
            }
            print("ing:\(index)")
            sleep(1)
        }
        print("finish")
        
    }
    
}
