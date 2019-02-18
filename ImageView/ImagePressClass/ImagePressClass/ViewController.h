//
//  ViewController.h
//  ImagePressClass
//
//  Created by EOC on 2017/4/16.
//  Copyright © 2017年   All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 1 图片压缩    一种文件大小压缩， 但图片渲染内存并没有压缩， 其本质是文件大小变化了，图片大小并没变化
 2 黑白图片    本质是修改每一个像素点的变化，RGBA，
 3 截图       把图片绘制到上下文中，切割context
 4 缩放       本质就是修改frame
 5 ImageIO   
 */


/*
 关系：
 UIImage    CGImage   ImageIO  (CoreGraphic 生成的图片，底层也是通过ImageIO来处理的，有一个中间量 CGImageProvider)
 CGImage
 ImageIO   
 
 CIImage  默认在GPU上渲染 （instument上可以看到，加载只有用GL来处理）
 
 */

@interface ViewController : UIViewController


@end

