//
//  ViewController.m
//  ImageDeep
//
//  Created by Casey on 13/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <CoreGraphics/CoreGraphics.h> // CGDataProvider.h
#import <CoreServices/CoreServices.h>


/*
 UIImage  --  CoreGraphics(CGImageRef, CGDataProvider)  --  ImageIO
 
 */

/*
 用TimeProfiler一步一步来看创建UIImage过程中内部调用的函数可以帮助我们解决问题，
 由于TimeProfiler统计函数栈为间隔一段时间统计一次，导致没有记录下所有函数的调用而且每次函数栈还可能不一致，
 所以没法精确判断函数栈是如何调用的，但是可以大概推测出每步做了什么
 
 */
@interface ViewController (){
    
    
    IBOutlet UIImageView *imageView;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *imageJPGItem = [[UIBarButtonItem alloc] initWithTitle:@"JPG" style:UIBarButtonItemStylePlain target:self action:@selector(uiimageJPG)];
    UIBarButtonItem *imageItem = [[UIBarButtonItem alloc] initWithTitle:@"Png" style:UIBarButtonItemStylePlain target:self action:@selector(uiimageloadPng)];
    UIBarButtonItem *imageTItem = [[UIBarButtonItem alloc] initWithTitle:@"imageT" style:UIBarButtonItemStylePlain target:self action:@selector(uiimageTwoload)];
    
   
    UIBarButtonItem *contextItem = [[UIBarButtonItem alloc] initWithTitle:@"Context" style:UIBarButtonItemStylePlain target:self action:@selector(contextImage)];
    UIBarButtonItem *desItem = [[UIBarButtonItem alloc] initWithTitle:@"Destination" style:UIBarButtonItemStylePlain target:self action:@selector(imageDestination)];
    
    
    
    self.navigationItem.rightBarButtonItems = @[imageItem, imageTItem, imageJPGItem, contextItem, desItem];
   
}


/*
 
 能看到 有个分支 GetImageAtPath，
 获取 CGImageSoureRef
 通过CGImageSourceCreateImageAtIndex();
 AppleJPEG 操作
 */
- (void)uiimageJPG {
    
    
    imageView.image = [UIImage imageNamed:@"bigImage.jpg"];
    
}




/*
 
*/

- (void)uiimageloadPng {
    
    
    
    //imageView.image = [UIImage imageNamed:@"11.png"];
    
    
    NSString *resource = [[NSBundle mainBundle] pathForResource:@"11" ofType:@"png"];
    NSData *data = [NSData dataWithContentsOfFile:resource options:0 error:nil];
    
    CFDataRef dataRef = (__bridge CFDataRef)data;
    
    CGImageSourceRef source = CGImageSourceCreateWithData(dataRef, nil);
    
    CGImageRef cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil);
    
    UIImage *image = [UIImage imageWithCGImage:cgImage];
   // CGImageSourceCreateImageAtIndex(<#CGImageSourceRef  _Nonnull isrc#>, <#size_t index#>, <#CFDictionaryRef  _Nullable options#>)
   
}



- (void)uiimageTwoload {
    
    UIImage *image = [UIImage imageNamed:@"11.png"];
  //  imageView.image = [UIImage imageNamed:@"11.png"];
    
}



/*
 CGContextDrawImage 里面
 CGDataProvideRetainData
 IOImageProvideInfo相关操作 读取相关图像
 PNGReadPlugin

*/

- (void)contextImage {
    
    
    
    UIGraphicsBeginImageContext(CGSizeMake(200, 200));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIImage *oldImage =  [UIImage imageNamed:@"11.png"];
    CGContextDrawImage(context, CGRectMake(0, 0, 200, 200), oldImage.CGImage);
    
    UIImage *image =  UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    imageView.image = image;
    
}

/*
 
 CGImageDestinationAddImage 涉及到CoreGraphices 对图片的信息获取，如 colorComponents
 
 CGImageDestinationFinalize  有PNGWritePlugin 生成图片， 也涉及到CoreGraphics， CGImageProviderCopyImageBlockSetiWithOptions （这个方法底层是ImageIO）
 */
- (void)imageDestination {
    
    UIImage *oldImage =  [UIImage imageNamed:@"11.png"];
    CFMutableDataRef buffer = CFDataCreateMutable(kCFAllocatorDefault, 0);
    CGImageDestinationRef destination = CGImageDestinationCreateWithData(buffer, kUTTypePNG, 1, NULL);
    CGImageDestinationAddImage(destination, oldImage.CGImage, nil);
    CGImageDestinationFinalize(destination);
    
  //  NSData *imageData = (__bridge NSData*)buffer;
   // UIImage *image = [UIImage imageWithData:imageData];
}



@end
