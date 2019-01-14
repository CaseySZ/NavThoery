//
//  EOCAnimatedImageView.h
//  ImageIO框架使用
//
//  Created by 八点钟学院 on 2017/7/27.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EOCAnimatedImageView : UIImageView

@property (nonatomic) BOOL autoPlayAnimatedImage;
@property (nonatomic) NSUInteger currentAnimatedImageIndex;
@property (nonatomic, copy) NSString *runloopMode;
@property (nonatomic, readonly) BOOL currentIsPlayingAnimation;
@property (nonatomic) NSUInteger maxBufferSize;

@end

@protocol EOCAnimatedImage <NSObject>

- (NSUInteger)animatedImageFrameCount;
- (NSUInteger)animatedImageLoopCount;
- (NSUInteger)animatedImageBytesPerFrame;
- (nullable UIImage *)animatedImageFrameAtIndex:(NSUInteger)index;
- (NSTimeInterval)animatedImageDurationAtIndex:(NSUInteger)index;

@optional
- (CGRect)animatedImageContentsRectAtIndex:(NSUInteger)index;
@end

NS_ASSUME_NONNULL_END
