//
//  TDChangeViewCtr.h
//  Animation
//
//  Created by Casey on 07/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 1.1 前面提到图层的 zPosition属性， 可以用来让图层靠近或者远离相机（用户视角），图层的transform属性（CATransform3D类型）让图层在3D空间内移动或者旋转
 1.2 和CGAffineTransform类似，CATransform3D也是一个矩阵, 是一个可以在3维空间内做变换的4x4的矩阵, 图Math3
 1.3 提供了能够简单地做一些变换，不需要自己计算,多了一个Z参数，如CATransform3DMakeRotation（旋转）， CATransform3DMakeScale(缩放变换)， CATransform3DMakeTranslation(平移)

    CATransform3DMakeRotation(CGFloat angle, CGFloat x, CGFloat y, CGFloat z)
    CATransform3DMakeScale(CGFloat sx, CGFloat sy, CGFloat sz)
    CATransform3DMakeTranslation(Gloat tx, CGFloat ty, CGFloat tz)
 
 1.4 demo
 1.5 小结：涉及了一些2D和3D的简单变换，简单的立体效果
 */

@interface TDChangeViewCtr : UIViewController

@end


