//
//  EventTheoryVC.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

/*
 https://blog.csdn.net/jiajiayouba/article/details/23447145 分析了为什么打印两次, 但没有结论, 具体机制仍然是扑朔迷离, 实际写代码时也不需要考虑这些
 */


/*

 1 事件的产生  2 事件的分发  3 事件的响应
 
 2 用户行为 -> source1生成事件对象UIEvent -> source0来处理事件对象-> 事件的分发 -> [UIApplication sendEvent:] -> [UIWindow sendEvent] -> 响应
 
 3 用户行为 -> eventFetch线程处理 -> source1生成事件对象UIEvent -> mach port通知主线程来处理事件（对象） -> source0来处理事件对象-> 事件的分发 -> [UIApplication sendEvent:] -> [UIWindow sendEvent] -> 响应
 
 
*/

/*
 响应原理 找到最适合响应这个事件的对象
 查找 {
 1 触摸点是否发生自己身上 （self.view的区域里）
 2 倒序遍历子控件 （找到最适合的子控件来处理，如果找不到，那么就是自己处理事件）
 3 然后子控件，重复 1，2 步骤
 }
 
 点击绿色区域：
 1 点击区域在self.view 上
 2 倒序遍历self.view 的子控件（_blueView）
 3 判断点击区域是否在_blueView上， 发现不在（继续查找）
 4 判断点击区域是否在_redView上，发现在这个view上
 5 倒序遍历_redView 的子控件（_greenView）
 6 判断点击区域是否在_greenView上
 7 发现在_greenView上，继续查找（找不到比_greenView更合适的view了），那么_greenView就响应事件
 
 在查找的过程中， 如果父控件不接收触摸事件，那么子控件也不能接收事件 （UIImageview ，userInteractionEnabled默认就是NO）
 */

/*
 问题1 点击蓝色，为什么响应的是蓝色，而不是红色呢
 */
class EventTheoryVC: UIViewController {

    let redView = RedView.init(frame: CGRect.init(x: 70, y: 100, width: 200, height: 300))
    let greenView = GreenView.init(frame: CGRect.init(x: 80, y: 110, width: 100, height: 100))
    let blueView = BlueView.init(frame: CGRect.init(x: 90, y: 120, width: 100, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Event"
        self.view.backgroundColor = .white
        
        
     //   theoryDemoOne()
        theoryDemoTwo()
    }
    
    
    func theoryDemoOne()  {
        
        redView.frame = CGRect.init(x: 70, y: 100, width: 200, height: 300)
        greenView.frame = CGRect.init(x: 80, y: 138, width: 100, height: 100)
        blueView.frame = CGRect.init(x: 90, y: 120, width: 200, height: 300)
        
        self.view.addSubview(redView)
        self.view.addSubview(greenView)
        self.view.addSubview(blueView)
        
    }
    
    func theoryDemoTwo() { // 响应链, touch方法里面执行super， 会把消息转发到响应链上，看touchBegin的方法描述
        
        self.view.addSubview(redView)
        self.view.addSubview(greenView)
        redView.addSubview(blueView)
    
    }
    

}
