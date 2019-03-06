//
//  ThreadViewCtr.swift
//  ThreadClass
//
//  Created by Casey on 06/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

/*
 
 线程和runloop的关系
 1 线程和runloop是一对一的关系
 2 线程默认没有开启runloop（线程的runloop什么时候创建的呢：RunLoop.current时创建的，属于懒加载，后面讲runloop源码会看到）
 3 runloop开启后，如果runloop里面没有资源，则runloop结束 （runloop是一个while循环，没资源时循环结束）
 
 
 应该避免调用这个方法，因为它不会给线程一个机会来清理它在执行过程中分配的任何资源
 Thread.exit()
 
 4 注意避免僵尸线程
 
 */

class ThreadViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.view.backgroundColor = .white
        
        
        let threadItem = UIBarButtonItem.init(title: "threadTimer", style: .plain, target: self, action: #selector(startThread))
        let threadTItem = UIBarButtonItem.init(title: "threadPort", style: .plain, target: self, action: #selector(startThreadT))
        self.navigationItem.rightBarButtonItems = [threadItem, threadTItem]
        
        
    }
    
    var threadTimer:Thread?
    @objc func startThread() {
        
        threadTimer = Thread.init(target: self, selector: #selector(threadEvent), object: nil)
        threadTimer?.start()
        
       
    }
    
    @objc func threadEvent() {
        
        var count = 0
        let model = CModel() // 查看mode的内存释放
        let timer = Timer.init(timeInterval: 1, repeats: true) { (time) in

            count = count + 1
            print("timer:\(count), \(model)")
            if count > 10 {
                time.invalidate()
                //Thread.exit()
            }

        }
        
        RunLoop.current.add(timer, forMode: .default)
        RunLoop.current.run()
        
        print("thread finish")
    }
    
    
    //MARK:  T
    @objc func startThreadT() {
        
        
        threadTimer = Thread.init(target: self, selector: #selector(threadTEvent), object: nil)
        threadTimer?.start()

    }
    
    var port = Port.init()
    @objc func threadTEvent() {
        
        print("threadT start")
        self.perform(#selector(cancelPort), with: nil, afterDelay: 3)
        RunLoop.current.add(port, forMode: .default)
        RunLoop.current.run()
        print("threadT finish")
    }
    
    @objc func cancelPort() {
        
        print("cancelPort")
        RunLoop.current.remove(port, forMode: .default)
        // 只能在当前线程移除，不要嵌套
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
       
        
    }
    
}
