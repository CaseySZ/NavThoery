//
//  SepcLayerViewCtr.h
//  Animation
//
//  Created by Casey on 07/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 1 CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类, 通过指定诸如颜色和线宽等属性，用CGPath来定义想要绘制的图形，最后CAShapeLayer就自动渲染出来了（GPU）。
    和通过CALayer来绘制
    1.1渲染快速。CAShapeLayer使用了硬件加速，绘制同一图形会比用Core Graphics快很多。
    1.2高效使用内存。一个CAShapeLayer不需要像普通CALayer一样创建一个寄宿图形，所以无论有多大，都不会占用太多的内存。
    1.3不会被图层边界剪裁掉。一个CAShapeLayer可以在边界之外绘制。你的图层路径不会像在使用Core Graphics的普通CALayer一样被剪裁掉（如我们在第二章所见）。
    1.4 不会出现像素化。当你给CAShapeLayer做3D变换时，它不像一个有寄宿图的普通图层一样变得像素化。
 案例通过CALayer和CAShapelayer绘制的内存问题，
 
 2 CATextLayer
 
 3 CATransformLayer
 
 4 CAGradientLayer是用来生成两种或更多颜色平滑渐变的, 优点在于绘制使用了硬件加速
 
 */

@interface SepcLayerViewCtr : UIViewController

@end


