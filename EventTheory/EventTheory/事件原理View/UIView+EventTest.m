//
//  UIView+Event.m
//  EventTheory
//
//  Created by sy on 2018/7/18.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "UIView+EventTest.h"

@implementation UIView (Event)

- (UIView *)syHitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    
    if (!self.userInteractionEnabled || self.hidden || self.alpha <= 0.01) {
        return nil;
    }
    
    if ([self pointInside:point withEvent:event]) {
        // 发生在我的区域
        
        NSArray *subViews = [[self.subviews reverseObjectEnumerator]  allObjects]; //子view 倒序
        
        UIView *suitView = nil;
        for (UIView *subView in subViews){
            
            // 转换坐标系 ，然后判断是否在子view的区域
            CGPoint convertPoint = [self convertPoint:point toView:subView];
            suitView = [subView syHitTest:convertPoint withEvent:event];
            
        }
        
        if (suitView == nil) {
            suitView = self;
        }
        
        return suitView;
        
    }
    
    return nil;
}

@end
