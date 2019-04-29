//
//  TestTwoView.m
//  EventTheory
//
//  Created by sy on 2018/7/19.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "TestTwoView.h"

@implementation TestTwoView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
      
    }
    
    return self;
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"%s", __func__);

}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"%s", __func__);

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"%s", __func__);


}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    NSLog(@"%s", __func__);
}


@end
