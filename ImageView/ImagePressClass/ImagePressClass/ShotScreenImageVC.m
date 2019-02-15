//
//  ShotScreenImageVC.m
//  ImagePressClass
//
//  Created by EOC on 2017/4/16.
//  Copyright © 2017年   All rights reserved.
//

#import "ShotScreenImageVC.h"
#import <QuartzCore/QuartzCore.h>

@interface ShotScreenImageVC ()

@end

@implementation ShotScreenImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _scrollerView.contentSize = CGSizeMake(700, 700);
    
    UIBarButtonItem *customItem = [[UIBarButtonItem alloc] initWithTitle:@"截图" style:UIBarButtonItemStylePlain target:self action:@selector(shotScreen)];
    UIBarButtonItem *circleItem =[[UIBarButtonItem alloc] initWithTitle:@"circle" style:UIBarButtonItemStylePlain target:self action:@selector(circleAction)];
    self.navigationItem.rightBarButtonItems = @[customItem, circleItem];
    
}

- (void)shotScreen{
    
    
    // 1 创建上下文
    UIGraphicsBeginImageContext(_scrollerView.frame.size);
    // 2 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 3 把view 渲染到上下吻
    [_scrollerView.layer renderInContext:context];
    // 4 把上下文中生成图片
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    image = [self getSubImage:CGRectMake(100, 100, _eocImageV.frame.size.width, _eocImageV.frame.size.height) image:image.CGImage];
    UIGraphicsEndImageContext();
    _eocImageV.image =  image;
    
    //_eocImageV.image = [self imageWithColor:nil];
}


- (void)circleAction {
    
    // 1 创建上下文
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    // 2 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 3 操作上下文
    CGContextSetLineWidth(context, 1);
    CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
    CGRect rect = CGRectMake(0, 0, 200, 200);
    CGContextAddEllipseInRect(context, rect);
    // 截剪上下文为圆形 闭环的
    CGContextClip(context);
    
    // 4 把image 渲染到相应的上下文中
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    [image drawInRect:CGRectMake(0, 0, 200, 200)];
    
    UIImage *backImage =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    _eocImageV.image  =  backImage;
}



- (UIImage*)getSubImage:(CGRect)rect image:(CGImageRef)cgImage{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(cgImage, rect);
    UIImage *subImage = [UIImage imageWithCGImage:imageRef];
    return subImage;
    
}


- (UIImage*)imageWithColor:(UIColor*)color{
    
    
    UIImage *rendImage = [UIImage imageNamed:@"3.jpg"];
    // 1 创建上下文
    UIGraphicsBeginImageContext(rendImage.size);
    // 2 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 3 把图片渲染到上下文
    [rendImage drawInRect:CGRectMake(0, 0, rendImage.size.width, rendImage.size.height)];
    
    UIColor *redColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.5];
    CGContextSetFillColorWithColor(context, redColor.CGColor);
    // 3 把颜色渲染到上下文
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    // 4 颜色渲染区域
    CGContextFillRect(context, CGRectMake(0, 0,rendImage.size.width, rendImage.size.height));
    // 5 生成图片
    CGImageRef imageRef =  CGBitmapContextCreateImage(context);
    
    UIImage *redImage = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    
    UIGraphicsEndImageContext();

    
    // 裁剪
    return redImage;
    
}


@end
