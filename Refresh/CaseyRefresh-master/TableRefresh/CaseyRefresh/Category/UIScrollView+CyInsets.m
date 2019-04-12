//
//  UIScrollView+CyInsets.m
//  TableRefresh
//
//  Created by Casey on 05/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "UIScrollView+CyInsets.h"
#import <objc/runtime.h>


@implementation UIScrollView (CyInsets)





- (UIEdgeInsets)cy_inset
{
    if (@available(iOS 11.0, *)) {
        
        return self.adjustedContentInset;
        
    }else {
        
        return self.contentInset;
    }
   
    
   
}

- (void)setCy_insetT:(CGFloat)cy_insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = cy_insetT;
    if (@available(iOS 11.0, *)) {
        inset.top -= (self.adjustedContentInset.top - self.contentInset.top);
    }
        
    self.contentInset = inset;
    
}

- (CGFloat)cy_insetT
{
    return self.cy_inset.top;
}

- (void)setCy_insetB:(CGFloat)cy_insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = cy_insetB;

    if (@available(iOS 11.0, *)) {
        inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom);
    }

    self.contentInset = inset;
    
}

- (CGFloat)cy_insetB
{
    return self.cy_inset.bottom;
}

- (void)setCy_insetL:(CGFloat)cy_insetL
{
    UIEdgeInsets inset = self.contentInset;
    inset.left = cy_insetL;
    if (@available(iOS 11.0, *)) {
        inset.left -= (self.adjustedContentInset.left - self.contentInset.left);
    }
    
    self.contentInset = inset;
}

- (CGFloat)cy_insetL
{
    return self.cy_inset.left;
}

- (void)setCy_insetR:(CGFloat)cy_insetR
{
    UIEdgeInsets inset = self.contentInset;
    inset.right = cy_insetR;
    
    if (@available(iOS 11.0, *)) {
        inset.right -= (self.adjustedContentInset.right - self.contentInset.right);
    }
    self.contentInset = inset;
}

- (CGFloat)cy_insetR
{
    return self.cy_inset.right;
}

- (void)setCy_offsetX:(CGFloat)cy_offsetX
{
    CGPoint offset = self.contentOffset;
    offset.x = cy_offsetX;
    self.contentOffset = offset;
}

- (CGFloat)cy_offsetX
{
    return self.contentOffset.x;
}

- (void)setCy_offsetY:(CGFloat)cy_offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = cy_offsetY;
    self.contentOffset = offset;
}

- (CGFloat)cy_offsetY
{
    return self.contentOffset.y;
}

- (void)setCy_contentW:(CGFloat)cy_contentW
{
    CGSize size = self.contentSize;
    size.width = cy_contentW;
    self.contentSize = size;
}

- (CGFloat)cy_contentW
{
    return self.contentSize.width;
}

- (void)setCy_contentH:(CGFloat)cy_contentH
{
    CGSize size = self.contentSize;
    size.height = cy_contentH;
    self.contentSize = size;
}

- (CGFloat)cy_contentH
{
    return self.contentSize.height;
}


@end
