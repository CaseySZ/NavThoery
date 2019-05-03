//
//  GestureViewCtr.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

/*
 1 手势识别
 2 手势冲突
 3 手势共存
 */


/* 手势识别 (⚠️识别过程中会执行view的touchbegin这些方法，识别完就不会执行了)
 1 yellowView 添加TapGesture, 既响应view的touch，也响应tapGesture的touch， 这两个是独立的，一个是UIGestureRecognizer对象的， 一个是UIResponse对象
 2 手势是通过touch识别的，去掉super就不能响应了
 3 事件的响应对象有两个，一个是UIResponse，另一个是UIGestureRecognizer，当手势识别过程结束，确定最佳响应对象（可以通过PanGesture手势查看，一个手势识别成功，UIResponse执行touchesCancelled），事件默认是单个响应
 */

/* 手势冲突和手势共存
 添加 CCPanGestureRecongnizer  和 CCMPanGestureRecongnizer 两个手势，通过代理处理手势问题
 
 */

class GestureViewCtr: UIViewController, UIGestureRecognizerDelegate {

    
    let yellowView = YellowView.init(frame: CGRect.init(x: 70, y: 100, width: 200, height: 300))
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Gesture"
        self.view.backgroundColor = .white
        
        self.view.addSubview(yellowView)
        
        
     //   let tapGesture = CCTapGesture.init(target: self, action: #selector(tapGestureEvent(_:)))
     //   yellowView.addGestureRecognizer(tapGesture)
        
        
        let panGesture = CCPanGestureRecongnizer.init(target: self, action: #selector(panGestureEvent(_:)))
        yellowView.addGestureRecognizer(panGesture)
      
        
       // let mPanGesture = CCMPanGestureRecongnizer.init(target: self, action: #selector(mpanGestureEvent(_:)))
       // yellowView.addGestureRecognizer(mPanGesture)
   
        
    }
    
    
    @objc func tapGestureEvent(_ gesture:CCTapGesture) {
        
        print("tapGestureEvent")
    }
    
    
    @objc func panGestureEvent(_ gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
        case .began:
            print("began")
        case .ended:
            print("end")
        case .cancelled:
            print("cancell")
        case .changed:
            print("change")
        default:
            print("other")
        }
        
        if gesture.state == .began {
            
            print("began")
        }
        
    }
    
    
    
    @objc func mpanGestureEvent(_ gesture: UIPanGestureRecognizer) {
        
        
        switch gesture.state {
        case .began:
            print("m began")
        case .ended:
            print("m  end")
        case .cancelled:
            print("m  cancell")
        case .changed:
            print("m  change")
        default:
            print("m other")
        }
        
        if gesture.state == .began {
            
            print("began")
        }
        
    }
    
    
    //这个方法返回YES，第一个和第二个互斥时，第二个会失效
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        print("shouldBeRequiredToFailBy")
        return false
    }
}
