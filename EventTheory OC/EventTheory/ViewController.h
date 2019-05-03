//
//  ViewController.h
//  EventTheory
//
//  Created by sy on 2018/7/18.
//  Copyright © 2018年 sy. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 UIEventTypeTouches, // 触摸事件类型
 UIEventTypeMotion, // 摇晃事件类型
 UIEventTypeRemoteControl, // 遥控事件
 UIEventTypePresses // 物理按钮事件类型
 
 */

/*
 
 7
 
  事件对象
 
  响应对象
 
 各司其职， 职责分明， MAC
 
 NSEvent
 
 NSView
 
 */

/*
 小结： 1 事件的产生 分发，
       2 响应 （找到最优对象响应 ） （向上传递【响应链机制】 ）
       3 UITouch 手势 buttonevent
       4 
 */

@interface ViewController : UIViewController{
    
    UIEvent *event;
    
    UIResponder *respone;
    UIView *view;
    
}


@end

