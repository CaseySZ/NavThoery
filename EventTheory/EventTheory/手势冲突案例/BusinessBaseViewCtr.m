//
//  BusinessBaseViewCtr.m
//  EventTheory
//
//  Created by sy on 2018/7/20.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "BusinessBaseViewCtr.h"

@interface BusinessBaseViewCtr ()

@end

@implementation BusinessBaseViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    /*
     默认是YES， 这种情况下，手势识别器识别手势完之后，发送touchCancel给控件； NO不发送，那么技能响应手势，又能响应touch
    */
    
   // tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    
}

- (void)tapGesture:(id)sender{
    
    NSLog(@"tapGesture");
    
}

@end
