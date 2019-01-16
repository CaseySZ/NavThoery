//
//  EOCImage.h
//  ImageIO框架使用
//
//  Created by 八点钟学院 on 2017/7/19.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EOCImageCoder.h"

@interface EOCImage : UIImage {
    
    dispatch_semaphore_t _preloadedLock;
    EOCImageDecoder *_decoder;
    NSUInteger _bytesPerFrame;
}

@property (nonatomic, readonly) EOCImageType animatedImageType;
@property (nonatomic, readonly) NSUInteger animatedImageMemorySize;

//需要加宏定义，否则有警告
NS_ASSUME_NONNULL_BEGIN

+ (nullable EOCImage *)imageNamed:(NSString *)name; // no cache!
+ (nullable EOCImage *)imageWithContentsOfFile:(NSString *)path;
+ (nullable EOCImage *)imageWithData:(NSData *)data;
+ (nullable EOCImage *)imageWithData:(NSData *)data scale:(CGFloat)scale;

NS_ASSUME_NONNULL_END

@end
