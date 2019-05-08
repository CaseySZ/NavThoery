//
//  TransitionViewCtr.h
//  Animation
//
//  Created by Casey on 08/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import <UIKit/UIKit.h>

/*过渡
 1 之前提到的属性动画， 只能对图层的可动画属性起作用， 如果要改变一个不能动画的属性（比如图片，图片插入和替换），或者从层级关系中添加或者移除图层（如push，淡入淡出效果），属性动画将不起作用，就需要通过CATransition来操作。
 
 2 系统提供四种类型 （type 属性来控制， 默认是kCATransitionFade）
 kCATransitionFade // 平滑的淡入淡出效果
 kCATransitionMoveIn // 把新的滑动进来显示新的外观，
 kCATransitionPush // 把新的从边缘的一侧滑动进来，旧的从另一侧推出去的效果
 kCATransitionReveal // 把旧的滑动出去来显示新的外观（而不是把新的滑动进入）
 
 
 3 动画方向 （subtype属性来控制， 默认的动画从左侧滑入）
 
 kCATransitionFromRight
 kCATransitionFromLeft
 kCATransitionFromTop
 kCATransitionFromBottom
 
 
 4 注意 一次只能使用一次CATransition， 使用完之后，回到默认
 
 5 system other
 
 6 自定义， 过渡动画的基础原则是对原始的图层外观截图，然后添加一段动画，平滑过渡到图层改变之后的效果
    6.1 截图
    6.2 动画
 
*/



@interface TransitionViewCtr : UIViewController

@end


