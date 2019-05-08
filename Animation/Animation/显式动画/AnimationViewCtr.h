//
//  AnimationViewCtr.h
//  Animation
//
//  Created by Casey on 08/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 属性动画
 
 1 当图层保持动画结束时的状态，更新属性的时候，我们需要设置一个新的事务，并且禁用图层行为。否则动画会发生两次，一个是因为显式的CABasicAnimation，另一次是因为隐式动画
 
 2 关键帧动画
 
 3 虚拟属性(1，2执行动画通过属性keyPath来配置的,如位置属性position，虚拟属性？ )
 */

@interface AnimationViewCtr : UIViewController

@end


