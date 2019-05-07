//
//  ChangeViewCtr.h
//  Animation
//
//  Created by Casey on 07/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 
 1.1 UIView的transform属性，用于在二维空间做旋转，缩放和平移, 是一个CGAffineTransform类型.
 1.2 CGAffineTransform是一个可以和二维空间向量（例如CGPoint）做乘法的3X2的矩阵
 1.3 看图Math2，用CGPoint的每一列和CGAffineTransform矩阵的每一行对应元素相乘再求和，就形成了一个新的CGPoint类型的结果.
     其中灰色元素，为了能让矩阵做乘法，左边矩阵的列数一定要和右边矩阵的行数个数相同，所以要给矩阵填充一些标志值，使得既可以让矩阵做乘法，又不改变运算结果，并且没必要存储这些添加的值，因为它们的值不会发生变化，但是要用来做运算。
    计算方式：用CGPoint的每一列和CGAffineTransform矩阵的每一行对应元素相乘再求和，就形成了一个新的CGPoint类型的结果。 矩阵数学不在讨论范围内
 
 1.4 提供了能够简单地做一些变换，不需要自己计算，如CGAffineTransformMakeRotation（旋转）， CGAffineTransformMakeScale(缩放变换)， CGAffineTransformMakeTranslation(平移)
 
 1.5 混合变换
 
 1.6 总结： CGAffineTransform类型属于Core Graphics框架，Core Graphics实际上是一个严格意义上的2D绘图API，并且CGAffineTransform仅仅对2D变换有效
 */

@interface ChangeViewCtr : UIViewController

@end


