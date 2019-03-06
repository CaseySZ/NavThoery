//
//  GCDViewCtr.swift
//  ThreadClass
//
//  Created by Casey on 06/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import Dispatch

/*
 并行（线程） （多个cup操作多个任务，理解为两个任务一起执行，每个任务都有独立的cpu负责处理， 并不受）
 并发（任务task） （可以理解为一个cpu执行多个线程，其实就一个cpu在操作，只是任务不不断的切换执行）
 
 
 */

class GCDViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let oneItem = UIBarButtonItem.init(title: "global", style: .plain, target: self, action: #selector(globalQueue))
        let twoItem = UIBarButtonItem.init(title: "serial", style: .plain, target: self, action: #selector(serialQueue))
        let threeItem = UIBarButtonItem.init(title: "concurrent", style: .plain, target: self, action: #selector(concurrentQueue))
        let fourItem = UIBarButtonItem.init(title: "group", style: .plain, target: self, action: #selector(groupFct))
        let fiveItem = UIBarButtonItem.init(title: "barrier", style: .plain, target: self, action: #selector(barrierFct))
        self.navigationItem.rightBarButtonItems = [oneItem, twoItem, threeItem, fourItem, fiveItem]
        
        
    }
    
    // 全局队列
    @objc func globalQueue()  {
        
        let globalQueue =  DispatchQueue.global(qos: .default)
        let bgQueue =  DispatchQueue.global(qos: .background)
        let defaultQueue =  DispatchQueue.global()
        
        if globalQueue == defaultQueue {
            
            print("equal")
        }
    }
    
    // 串行队列
    @objc func serialQueue()  {
        
        let queue =  DispatchQueue.init(label: "111") // 默认是串行的
        
       // let queue =  DispatchQueue.init(label: "dd", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.initiallyInactive)
       // queue.activate()
        
        queue.async {
            print("1 start")
            sleep(1)
            print("1 end")
        }

        queue.async {
            print("2 start")
            sleep(1)
            print("2 end")
        }

        queue.async {
            print("3 start")
            sleep(1)
            print("3 end")
        }
        
    }
    
     // 并行队列
    @objc func concurrentQueue()  {
        
        let queue =  DispatchQueue.init(label: "dd", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent)
        queue.async {
            print("1 start")
            sleep(1)
            print("1 end")
        }
        
        queue.async {
            print("2 start")
            sleep(1)
            print("2 end")
        }
        
        queue.async {
            print("3 start")
            sleep(1)
            print("3 end")
        }
    }
    
    // 组
    @objc func groupFct()  {
        
        let group = DispatchGroup.init()
        
        let queue =  DispatchQueue.init(label: "dd", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent)
     
        queue.async(group: group) {
            
            print("1 group stask")
            sleep(1)
            print("1 group stask end")
        }
        

        
        // 当group这个queue中任务数为0时， 触发notify
        group.notify(queue: queue) {
            
            print("notify")
        }
        
        queue.async(group: group) {
            
            print("2 group stask")
            sleep(1)
            print("2 group stask end")
        }
        
        
        group.enter() // 往group里添加一个空任务 任务数+1
        group.leave() // 往group里添加一个空任务 任务数-1
        
        /*
         处理多任务场景会用到这个，如一个业务需要三个网络请求完成才能 render界面， 可以通过group来处理，当三个任务完成时，会触发notify
         */
        
    }
    
    
    
    // 屏障  swift 未开放出来
    @objc func barrierFct()  {
        
        let queue =  DispatchQueue.init(label: "dd", qos: DispatchQoS.default, attributes: DispatchQueue.Attributes.concurrent)
        
        queue.async {
            
            print("1")
            sleep(1)
            print("1 finish")
            
        }
        
        
        queue.async {
            
            print("2")
            sleep(1)
            print("2 finish")
            
        }
        
       // barrier
        
        
        queue.async {
            
            print("3")
            sleep(1)
            print("3 finish")
            
        }
    }
    
}
