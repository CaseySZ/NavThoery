//
//  SYEventTheoryVC.h
//  EventTheory
//
//  Created by sy on 2018/7/18.
//  Copyright © 2018年 sy. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 1 事件的产生  2 事件的分发  3 事件的响应

 2 用户行为 -> source1生成事件对象UIEvent -> source0来处理事件对象-> 事件的分发 -> [UIApplication sendEvent:] -> [UIWindow sendEvent] -> 响应
 
 
 3 用户行为 -> eventFetch线程处理 -> source1生成事件对象UIEvent -> mach port通知主线程来处理事件（对象） -> source0来处理事件对象-> 事件的分发 -> [UIApplication sendEvent:] -> [UIWindow sendEvent] -> 响应
 
 */


@interface SYEventTheoryVC : UIViewController{
    
    
}

@end
