//
//  OperationViewCtr.swift
//  ThreadClass
//
//  Created by Casey on 06/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit


/*
 
 1 Operation线程的操作 和 OperationQueue 配合使用
 2 要继承Operation，不能直接使用Operation
 3 系统提供了一个Operation的子类 blockOperation
 4
 
 */

class OperationBaseViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let blockOpItem = UIBarButtonItem.init(title: "blockOp", style: .plain, target: self, action: #selector(operationUse))
        self.navigationItem.rightBarButtonItems = [blockOpItem]
        
    }
    
    let blockOperation = BlockOperation.init()
    @objc func operationUse() {
        
        
        
        blockOperation.addExecutionBlock {
            
            print("one:\(Thread.current)")
            
        }
        
        blockOperation.addExecutionBlock {
            
            print("two:\(Thread.current)")
            
        }
        
        blockOperation.addExecutionBlock {
            
            print("three:\(Thread.current)")
            
        }
        
        /*
            BlockOperation
            add block 没有先进先出的概念， 每个block在不同的线程中执行。
            手动开启，第一个开启的block会在主线程，
         */
        OperationQueue.init().addOperation(blockOperation)
        
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    
        
    }

}
