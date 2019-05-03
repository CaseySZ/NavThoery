//
//  CCMPanGestureRecongnizer.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class CCMPanGestureRecongnizer: UIPanGestureRecognizer, UIGestureRecognizerDelegate {
    
    
    override init(target: Any?, action: Selector?) {
        
        super.init(target: target, action: action)
        self.delegate = self
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        print("CCPanGesture touchesBegan")
//        super.touchesBegan(touches, with: event!)
//    }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        print("CCPanGesture touchesMoved")
//        super.touchesMoved(touches, with: event!)
//    }
//
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        print("CCPanGesture touchesEnded")
//        super.touchesEnded(touches, with: event!)
//    }
//
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//
//        print("CCPanGesture touchesCancelled")
//        super.touchesCancelled(touches, with: event!)
//    }
    
   

    /*
     手指触摸屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等
     此方法在window对象在有触摸事件分发后，调用gestureRecognizer:shouldReceive(在touchesBegan:withEvent:方法之前调用)，返回yes，事件是否识别成手势，如果返回NO,则不去识别手势。(默认情况下为YES)
     */
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        print("shouldReceive")
        return true
    }
    
    //手势识别后，是否开始，返回NO则结束手势
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        print("gestureRecognizerShouldBegin")
        return true
    }
    
//    /*
//     是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
//     是否允许多个手势识别器共同识别，一个控件的手势识别后是否阻断手势识别继续向下传播，默认返回NO；如果为YES，响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播
//     */
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//
//
//        print("RecognizeSimultaneously")
//        return true
//    }
    
    // 这个方法返回YES，第一个手势和第二个互斥时，第一个会失效(在view上最后面添加的手势是第一个，添加CC和CCM手势看现象)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        print("shouldRequireFailureOf")
        return true
    }
    
    //这个方法返回YES，第一个和第二个互斥时，第二个会失效(两个手势的代理是同一个)
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        print("shouldBeRequiredToFailBy")
        return true
    }
    
}
