//
//  TestOneView.m
//  EventTheory
//
//  Created by sy on 2018/7/19.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "TestOneView.h"

@implementation TestOneView


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
