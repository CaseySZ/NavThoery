//
//  SYButton.m
//  EventTheory
//
//  Created by sy on 2018/7/18.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "SYButton.h"

@implementation SYButton

/*

 
 */

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    return [super hitTest:point withEvent:event];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    return [super pointInside:point withEvent:event];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    [super touchesEnded:touches withEvent:event];
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    [super touchesCancelled:touches withEvent:event];
}



@end
