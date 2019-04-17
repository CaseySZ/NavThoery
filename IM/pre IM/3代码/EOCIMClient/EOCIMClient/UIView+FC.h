//
//  UIView+FC.h
//  WeiXinFriendCircle
//
//  Created by sunyong on 16/12/30.
//  Copyright © 2016年 @八点钟学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FC)

- (void)removeAllSubView;

// 返回高度
+ (float)backLinesHighInView:(CGFloat)viewWidth string:(NSString *)contentS font:(UIFont*)font;

// 返回宽度
+ (float)backWidthInViewString:(NSString *)contentS font:(UIFont*)font;

// 返回Size 不准
+ (CGSize)backSizeInView:(CGFloat)viewWidth string:(NSString *)contentS font:(UIFont*)font;

@end
