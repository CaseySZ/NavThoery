//
//  GeometryViewCtr.h
//  Animation
//
//  Created by Casey on 06/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 1 布局：
 UIView有三个比较重要的布局属性：frame，bounds和center，CALayer对应地叫做frame，bounds和position。
 为了能清楚区分，图层用了“position”，视图用了“center”，但是他们都代表同样的值,
 frame代表了图层的外部坐标（也就是在父图层上占据的空间），bounds是内部坐标（{0, 0}通常是图层的左上角,
 center和position都代表了相对于父图层anchorPoint所在的位置。
 
 注意：frame 它其实是一个计算属性，是根据bounds，position和transform计算而来，后面 变换课程，可以提现
 */

/*
 2 锚点坐标： 默认来说，anchorPoint位于图层的中点，所以图层的将会以这个点为中心放置
 图层左上角是{0, 0}，右下角是{1, 1}， 系统默认是{0.5, 0.5}
 
 */

/*
 3 坐标系 Z, 默认是0 （可以理解为，让图层靠近或者远离相机（用户视角））
 和UIView严格的二维坐标系不同，CALayer存在于一个三维空间当中。除了我们已经讨论过的position和anchorPoint属性之外，CALayer还有另外两个属性，zPosition和anchorPointZ
  zPosition属性在大多数情况下其实并不常用。在第五章，我们将会涉及CATransform3D，你会知道如何在三维空间移动和旋转图层，除了做变换之外，zPosition最实用的功能就是改变图层的显示顺序了。
 
 */

@interface GeometryViewCtr : UIViewController

@end


