//
//  TimingViewCtr.h
//  Animation
//
//  Created by Casey on 09/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import <UIKit/UIKit.h>

/* CAMediaTiming
 
 1 CAMediaTiming 属性 duration, repeatCount, 持续和重复 默认都是0
 
 
 2 timeOffset让动画快进到某一点，例如，对于一个持续4秒的动画来说，设置timeOffset为2意味着动画将从一半的地方开始动画，然后执行4秒。
 
 3 speed 动画的速度，默认是1.0， 如果speed = 2.0的，那么对于一个duration为4的动画，实际上在2秒的时候就已经完成了
 
 
 4 fillMode 动画结束后呈现的状态（presentationLayer），结合 removeOnCompletion = NO 使用
     kCAFillModeForwards // 保持动画结束之后的那一帧
 
 5 beginTime 开始时间（延迟动画） （CoreAnimation有一个全局时间的概念，马赫时间 CACurrentMediaTime() 可以理解为一个相对时间，相对于开机到目前的时间 ）
 
 
 6 动画的暂停和恢复，快进
 
 7 手动动画 CALayer调整duration和repeatCount/repeatDuration属性并不会影响到子动画。但是beginTime，timeOffset和speed属性将会影响到动画
 （猜测：动画对象提交后，对动画对象进行了深拷贝并提交给了系统，不能修改动画属性， 但直接用-animationForKey:来检索图层正在进行的动画可以返回正确的动画对象，但是修改它的属性将会抛出异常，所以猜测，layer层也实现了CAMediaTiming协议， 来影响到动画，可能还有其他作用）
 */

@interface TimingViewCtr : UIViewController

@end


