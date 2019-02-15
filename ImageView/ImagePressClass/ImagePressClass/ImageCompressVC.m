

//
//  ImageCompressVC.m
//  ImagePressClass
//
//  Created by Casey on 18/01/2019.
//  Copyright © 2019 EOC. All rights reserved.
//

#import "ImageCompressVC.h"

@interface ImageCompressVC ()

@end

@implementation ImageCompressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"image compress";
    
}


// 通过上下文对图片压缩处理 只能在主线程处理
- (void)scaleImage{
    
    
    UIImage *image = [UIImage imageNamed:@"bigImage.jpg"];
    CGSize imageSize = CGSizeMake(100, 100);
   
    UIGraphicsBeginImageContext(imageSize);
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self saveImageToLocal:@"testTT png" fromData:UIImageJPEGRepresentation(newImage,1)];
    
}

// 可以在线程处理
- (void)scaleImageThead{
    
    UIImage *image = [UIImage imageNamed:@"bigImage.jpg"];
    
    
    CGFloat width = 100;
    CGFloat height = 100;
    
    CGColorSpaceRef colorspaceRef = CGColorSpaceCreateDeviceRGB();
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, bitsPerComponent, bytesPerRow, colorspaceRef, kCGBitmapByteOrderDefault|kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image.CGImage);
    CGImageRef imageRef =  CGBitmapContextCreateImage(context);
    // UIImageOrientationUp 参数有坐标旋转效果， 富文本会涉及到坐标
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:UIScreen.mainScreen.scale orientation:UIImageOrientationUp];
    
    [self saveImageToLocal:@"testCCpng" fromData:UIImageJPEGRepresentation(newImage,1)];
    
}

// 保存图片数据到本地
- (void)saveImageToLocal:(NSString*)fileName fromData:(NSData*)data{
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    NSLog(@"filePath:%@", filePath);
    [data writeToFile:filePath atomically:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self scaleImage];
    [self scaleImageThead];
    
}


@end
