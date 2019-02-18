//
//  QRCodeCIImageVC.h
//  ImagePressClass
//
//  Created by Casey on 15/02/2019.
//  Copyright © 2019 EOC. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 CoreImage 文档： 提供高性能处理的图像处理和分析技术  (kCIContextUseSoftwareRenderer 设置在CPU上渲染) https://objccn.io/issue-21-6/
 CGImageRef：A bitmap image or image mask  （位图/图像掩码）
 CIImage 描述 A representation of an image to be processed or produced by Core Image filters； （由核心图像过滤器处理或产生的图像的一种表示形式）..... This lazy evaluation
 CGContextRef 描述 （A Quartz 2D drawing environment）// https://blog.csdn.net/sinat_27706697/article/details/45949387
 */

@interface QRCodeCIImageVC : UIViewController

@end


