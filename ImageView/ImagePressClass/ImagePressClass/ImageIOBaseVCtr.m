//
//  ImageIOBaseVCtr.m
//  ImagePressClass
//
//  Created by Casey on 17/01/2019.
//  Copyright © 2019 EOC. All rights reserved.
//

#import "ImageIOBaseVCtr.h"
#import <ImageIO/ImageIO.h>


@interface ImageIOBaseVCtr ()

@end

@implementation ImageIOBaseVCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"base";
    
}


// 获取系统支持的图片类型
- (void)supportImageType {
    
    
    CFArrayRef typeArr =  CGImageSourceCopyTypeIdentifiers();
    NSLog(@"%@", typeArr);
    
}

- (void)getImageType {
    
    // 获取图片类型
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigSize" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)fileData, NULL);
    CFStringRef fileType =  CGImageSourceGetType(source);
    NSLog(@"type:::%@", fileType);
    
}


- (void)getImageInfo {
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigSize" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)fileData, NULL);
    CFDictionaryRef fileInfo =  CGImageSourceCopyProperties(source, NULL); //获取source属性
    NSLog(@"%@", fileInfo);
    fileInfo =  CGImageSourceCopyPropertiesAtIndex(source, 0, NULL); // 图像源指定位置的图片属性
    
    NSLog(@":::%@", fileInfo);
    
}

- (void)getMetaInfo {
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigSize" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)fileData, NULL);
    CGImageMetadataRef imageMetaData =  CGImageSourceCopyMetadataAtIndex(source, 0, NULL);
  //  NSData *imageData = (__bridge NSData*)imageMetaData;
  //  NSLog(@"%s", [imageData bytes]);//
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    [self getImageType];
    
    [self getImageInfo];
    
    [self getMetaInfo];
    
}


@end
