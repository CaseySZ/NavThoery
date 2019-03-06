//
//  OperationViewCtr.swift
//  ThreadClass
//
//  Created by Casey on 06/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class OperationViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        let blockOpItem = UIBarButtonItem.init(title: "base", style: .plain, target: self, action: #selector(operationUse))
        let dependOpItem = UIBarButtonItem.init(title: "depend", style: .plain, target: self, action: #selector(operationDepend))
        let cancelOpItem = UIBarButtonItem.init(title: "cancel", style: .plain, target: self, action: #selector(cancelEvent))
        let cancelOpIngItem = UIBarButtonItem.init(title: "cancelOp_ing", style: .plain, target: self, action: #selector(cancelOpIngEvent))
        self.navigationItem.rightBarButtonItems = [blockOpItem, dependOpItem, cancelOpItem, cancelOpIngItem]
        
    }
    
    
   // 使用
    @objc func operationUse() {
        
        
        let operation = COperation.init()
        
        OperationQueue.init().addOperation(operation)
        
        
    }
    
    // 依赖
    @objc func operationDepend() {
        
        let queue = OperationQueue.init()
        
        let operationOne = COperation.init()
        
        let operationTwo = BlockOperation.init {
            print("two")
        }
        
        let operationThree = BlockOperation.init {
            print("three")
        }
        
        operationOne.addDependency(operationTwo)
        operationThree.addDependency(operationOne)
        
        
        queue.addOperation(operationOne)
        queue.addOperation(operationTwo)
        queue.addOperation(operationThree)
        
        /*
         
         依赖关系，在入队列前建立，入队列后再建依赖关系没效
         依赖关系，是根据每个operation的finish状态来操作的，通过KVO来处理依赖逻辑
         
         
         */
        
    }
    
    
    let cqueue = OperationQueue.init()
    
    let coperation = BlockOperation.init {
        
        print("start")
        for index in 0...5 {

            print("ing:\(index)")
            sleep(1)
        }
        print("finish")
        
    }
    
    let loperation = BlockOperation.init {
        print("loperation")
    }
    
    // 取消
    @objc func cancelEvent() {
        
        
        
        loperation.addDependency(coperation)
        cqueue.addOperation(coperation)
        cqueue.addOperation(loperation)
    }
    
    /*
     operation的cancel不能取消已经执行的任务
     queue的 cancelAllOperations 不能取消已经开启的任务
     
     如果想取消正在执行的任务，需要内部处理
     */
    
    
    // 取消正在执行的
    let cancelOp = CancelOperation()
    @objc func cancelOpIngEvent() {
        
        let queue = OperationQueue.init()
        queue.addOperation(cancelOp)

    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        loperation.cancel()
       // cqueue.cancelAllOperations()
        
        
        cancelOp.cancel()
    }
    
}
