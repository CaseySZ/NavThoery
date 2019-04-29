//
//  SYBlueView.m
//  EventTheory
//
//  Created by sy on 2018/7/18.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "SYBlueView.h"
#import "UIView+EventTest.h"

@implementation SYBlueView



- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
    }
    return self;
}


/*
 2 触摸的点是否在范围内，
 */
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    return [super pointInside:point withEvent:event];
    
}

// 1
/*
 
 1如果pointInside返回YES， 倒序遍历他的子view
    1.1 如果点击区域在自己这里，不在子view上，返回自己
    1.2 如果在子view里， 返回子view
 
 2如果pointInside返回NO， 返回nil
 
 */
- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    //return [super hitTest:point withEvent:event];
    return [super syHitTest:point withEvent:event];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{


    NSLog(@"%s", __func__);
   // [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
    NSLog(@"%@", event);
    NSLog(@"%@", touches);
    
    NSLog(@"%s", __func__);
   // [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"%s", __func__);
   // [super touchesEnded:touches withEvent:event];

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"%s", __func__);
   // [super touchesCancelled:touches withEvent:event];
}


@end
