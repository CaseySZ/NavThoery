//
//  UIView+EOCLayout.h
//  WeiXinFriendCircle
//
//  Created by EOC on 2017/5/8.
//  Copyright © 2017年 @八点钟学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (EOCLayout)


- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)x;
- (CGFloat)y;
- (CGSize)size;
- (CGPoint)origin;
- (CGFloat)centerX;
- (CGFloat)centerY;

- (CGFloat)left;
- (CGFloat)top;
- (CGFloat)bottom;
- (CGFloat)right;


- (void)setX:(CGFloat)x;
- (void)setLeft:(CGFloat)left;
- (void)setY:(CGFloat)y;
- (void)setBottom:(CGFloat)bottom;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;


- (void)equalXToView:(UIView *)view;
- (void)equalYToView:(UIView *)view;

- (void)bottomEqualSuperViewBottom;
- (void)setBottomToSuperBotttomGap:(CGFloat)Gap;


- (void)bottomEqualToTopOfView:(UIView*)targetView;

@end
