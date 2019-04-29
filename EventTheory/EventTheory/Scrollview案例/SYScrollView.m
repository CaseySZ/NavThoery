//
//  SYScrollView.m
//  EventTheory
//
//  Created by sy on 2018/7/20.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "SYScrollView.h"

@implementation SYScrollView


- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSLog(@"%f",point.x);
    CGRect rect = self.bounds;
    rect.origin.x -= 50;
    rect.size.width = [UIScreen mainScreen].bounds.size.width;
    if (CGRectContainsPoint(rect, point)) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}





@end
