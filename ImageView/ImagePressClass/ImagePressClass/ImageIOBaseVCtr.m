//
//  ImageIOBaseVCtr.m
//  ImagePressClass
//
//  Created by Casey on 17/01/2019.
//  Copyright © 2019 EOC. All rights reserved.
//

#import "ImageIOBaseVCtr.h"
#import <ImageIO/ImageIO.h>

/*

 CGImageSource 文件：
 1 属性 ：方法调用的传参
 2 系统支持的图片类型， ID
 3 CGImageSourceRef 的创建
 4 图片属性的获取
 5 元数据的获取CGImageMetadataRef
 6 CGImageRef 的生成
 7 略缩图的生成
 8 渐进式的 CGImageSourceRef 创建
 9 图片状态的获取
 
*/

@interface ImageIOBaseVCtr ()

@end

@implementation ImageIOBaseVCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIBarButtonItem *supportTypeBt = [[UIBarButtonItem alloc] initWithTitle:@"Type" style:UIBarButtonItemStylePlain target:self action:@selector(supportImageType)];
    UIBarButtonItem *imageTypeBt = [[UIBarButtonItem alloc] initWithTitle:@"ImageType" style:UIBarButtonItemStylePlain target:self action:@selector(getImageType)];
    UIBarButtonItem *imageProBt = [[UIBarButtonItem alloc] initWithTitle:@"ImageInfo" style:UIBarButtonItemStylePlain target:self action:@selector(getImageInfo)];
     UIBarButtonItem *metaInfoBt = [[UIBarButtonItem alloc] initWithTitle:@"meta" style:UIBarButtonItemStylePlain target:self action:@selector(getMetaInfo)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:supportTypeBt, imageTypeBt, imageProBt,metaInfoBt, nil];
    
    
}


// 获取系统支持的图片类型
- (void)supportImageType {
    
    CFArrayRef typeArr =  CGImageSourceCopyTypeIdentifiers();
    NSLog(@"%@", typeArr);
    CFRelease(typeArr);
}

- (void)getImageType {
    
    
    // 获取图片类型
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigSize" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)fileData, NULL);
    CFStringRef fileType =  CGImageSourceGetType(source);
    NSLog(@"type:::%@", fileType);
    
    CFRelease(source);
}


- (void)getImageInfo {
    
    /*
     CGImageSourceRef抽象了对读图像数据的通道，读取图像要通过它，它自己本身不读取图像的任何数据
     在你调用CGImageSourceCopyPropertiesAtIndex的时候会才去读取图像元数据
     */
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigSize" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)fileData, NULL);
    CFDictionaryRef fileInfo =  CGImageSourceCopyProperties(source, NULL); //获取imagesource属性
    NSLog(@"%@", fileInfo);
    CFDictionaryRef imageInfo =  CGImageSourceCopyPropertiesAtIndex(source, 0, NULL); //  image 图像源指定位置的图片属性
    
    NSLog(@":::%@", imageInfo);
    
    CFRelease(source);
    CFRelease(fileInfo);
    CFRelease(imageInfo);
    
}

- (void)getMetaInfo {
    
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bigSize" ofType:@"jpg"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    CGImageSourceRef  source = CGImageSourceCreateWithData((__bridge CFDataRef)fileData, NULL);
    CGImageMetadataRef imageMetaData =  CGImageSourceCopyMetadataAtIndex(source, 0, NULL);
    NSLog(@":::%@", imageMetaData);
    CFRelease(source);
    CFRelease(imageMetaData);
    
    
}




@end
