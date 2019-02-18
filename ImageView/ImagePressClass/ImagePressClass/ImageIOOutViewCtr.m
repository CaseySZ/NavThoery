//
//  ImageIOOutViewCtr.m
//  ImagePressClass
//
//  Created by Casey on 16/01/2019.
//  Copyright © 2019 EOC. All rights reserved.
//

#import "ImageIOOutViewCtr.h"
#import <ImageIO/ImageIO.h>
#import <CoreServices/CoreServices.h>

@interface ImageIOOutViewCtr (){
    
    
    IBOutlet UIImageView *_imageView;
    
    CGImageDestinationRef destination;
    
    NSMutableArray *mArray;
    
}

@end

@implementation ImageIOOutViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"gif";
    
    mArray = [NSMutableArray new];
    
    
    
    for (int i = 1; i <= 9; i++) {
        
        UIImage *image = [UIImage imageNamed:[@(i) description]];
        [mArray addObject:image];
        
    }
    _imageView.image = [UIImage imageNamed:@"gif.gif"];
    [_imageView startAnimating];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self createGifImage];
 
    
    [self compress];
}


- (void)createGifImage{
    
    NSMutableData *data = [NSMutableData new];
    
    CFMutableDataRef dataRef = (__bridge CFMutableDataRef)data;
    
    //kUTTypeGIF;
    destination = CGImageDestinationCreateWithData(dataRef, (__bridge CFStringRef)@"com.compuserve.gif", mArray.count, nil);
    
    // 给gif添加信息
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@(2) forKey:(NSString *)kCGImagePropertyGIFLoopCount];
    
    NSDictionary *gifProperties = [NSDictionary dictionaryWithObject:dict forKey:(NSString *)kCGImagePropertyGIFDictionary];
   // CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)gifProperties);
    
    
    //设置gif的信息，播放时隔事件，基本数据和delay事件
    NSDictionary *frameProperties = [NSDictionary dictionaryWithObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:0.18],(NSString *)kCGImagePropertyGIFDelayTime, nil] forKey:(NSString *)kCGImagePropertyGIFDictionary];
    // 合成gif（把所有图片遍历添加到图像目标）
    for (UIImage *dImg in mArray)
    {
        CGImageDestinationAddImage(destination, dImg.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    
    // 写入gif图
    CGImageDestinationFinalize(destination);
    
    
    //释放目标图像
    CFRelease(destination);

    _imageView.image =  [UIImage imageWithData:data];
    [_imageView startAnimating];
    
    NSString *gifFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    gifFilePath = [gifFilePath stringByAppendingPathComponent:@"test22.gif"];
    [data writeToFile:gifFilePath atomically:YES];
    
}



- (void)compress {
    
    
    NSMutableData *data = [NSMutableData new];
    
    CFMutableDataRef dataRef = (__bridge CFMutableDataRef)data;
    
    UIImage *image = [UIImage imageNamed:@"11.jpg"];
   // NSDictionary *optionsDes = @{(id)kCGImageDestinationEmbedThumbnail: @(YES)}; // 启动和禁用 略缩图
    
    NSDictionary *optionsDes = @{(id)kCGImageDestinationImageMaxPixelSize: @(200)};
    destination = CGImageDestinationCreateWithData(dataRef, kUTTypeJPEG, 1, (CFDictionaryRef)optionsDes);
    
    CGFloat quality = 0.2;
    NSDictionary *options = @{(id)kCGImageDestinationLossyCompressionQuality : @(quality)};
    
    CGImageDestinationAddImage(destination, image.CGImage, (CFDictionaryRef)optionsDes);
    
    CGImageDestinationFinalize(destination);
    
    CFRelease(destination);
    
    NSString *gifFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    gifFilePath = [gifFilePath stringByAppendingPathComponent:@"testOne.jpg"];
    [data writeToFile:gifFilePath atomically:YES];
    
    _imageView.image =  [UIImage imageWithData:data];
    
    
}



@end
