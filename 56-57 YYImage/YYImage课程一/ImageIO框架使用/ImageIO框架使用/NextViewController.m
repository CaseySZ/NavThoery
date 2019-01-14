//
//  NextViewController.m
//  ImageIO框架使用
//
//  Created by 八点钟学院 on 2017/7/23.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "NextViewController.h"
#import <ImageIO/ImageIO.h>

@interface NextViewController () {
    
    UIImage *allImg;
    UIImageView *imgView;
    CGContextRef twoContext;
    int count;
    
}

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    count = 0;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];

}

- (void)btnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
        NSString * path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
        
        NSData *data = [NSData dataWithContentsOfFile:path];

        
        for (int i=0; i<1; i++) {
            
            UIImage *tmpImg = [UIImage imageWithData:data];
            
            imgView = [[UIImageView alloc] initWithImage:tmpImg];
            imgView.frame = CGRectMake(100.f, 100.f+100.f*i, 100.f, 100.f);
            [self.view addSubview:imgView];
            
        }
    
}

- (UIImage *)customImage {
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"mew_baseline" ofType:@"jpg"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    CFDataRef dataRef = (__bridge CFDataRef)data;
    CFStringRef myKeys[2];
    CFTypeRef myValues[2];
    
    //解码就缓存
    myKeys[0] = kCGImageSourceShouldCache;
    myValues[0] = kCFBooleanFalse;
    myKeys[1] = kCGImageSourceShouldCacheImmediately;
    myValues[1] = kCFBooleanFalse;
    
    CFDictionaryRef options = CFDictionaryCreate(NULL, (const void **)myKeys, (const void **)myValues, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    
    CGImageSourceRef source = CGImageSourceCreateWithData(dataRef, options);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(source, 0, options);
    
    UIImage *tmpImg = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(source);
    CGImageRelease(imageRef);
    CFRelease(options);
    return tmpImg;
    
}

- (UIImage *)customImageThree {
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    
    NSData *tmpData = [NSData dataWithContentsOfFile:path];
    allImg = [UIImage imageWithData:tmpData];
    
    CGImageRef imageRef = allImg.CGImage;
    
    CGColorSpaceRef space = CGImageGetColorSpace(imageRef);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    if (!dataProvider) return NULL;
    CFDataRef data = CGDataProviderCopyData(dataProvider); // decode
    if (!data) return NULL;
    
    CGDataProviderRef newProvider = CGDataProviderCreateWithCFData(data);
    CFRelease(data);
    if (!newProvider) return NULL;
    
    CGImageRef newImage = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, space, bitmapInfo, newProvider, NULL, false, kCGRenderingIntentDefault);
    CFRelease(newProvider);

    return [UIImage imageWithCGImage:newImage];
}

- (UIImage *)customImageTwo {
    
    NSString * path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"];
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    allImg = [UIImage imageWithData:data];
    
    CGImageRef cgImage = allImg.CGImage;
    
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(cgImage) & kCGBitmapAlphaInfoMask;
    BOOL hasAlpha = NO;
    if (alphaInfo == kCGImageAlphaPremultipliedLast ||
        alphaInfo == kCGImageAlphaPremultipliedFirst ||
        alphaInfo == kCGImageAlphaLast ||
        alphaInfo == kCGImageAlphaFirst) {
        hasAlpha = YES;
    }
    
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrder32Host;
    bitmapInfo |= hasAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst;
    
    if (!twoContext) {
        
        //字节对齐：bytePerRow：260，64字节整数倍来读取的，64字节的整数倍：bytePerRow*height
        twoContext = CGBitmapContextCreate(NULL, width, height, 8, 0, CGColorSpaceCreateDeviceRGB(), bitmapInfo);
        
    }
    
    CGContextDrawImage(twoContext, CGRectMake(0, 0, width, height), cgImage);
    CGImageRef newImage = CGBitmapContextCreateImage(twoContext);
//    CGContextClearRect(twoContext, CGRectMake(0, 0, width, height));
    
    return [UIImage imageWithCGImage:newImage];
}

@end
