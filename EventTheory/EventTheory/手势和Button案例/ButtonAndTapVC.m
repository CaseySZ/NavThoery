//
//  ButtonAndTapVC.m
//  EventTheory
//
//  Created by sy on 2018/7/20.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "ButtonAndTapVC.h"

@interface ButtonAndTapVC ()<UIGestureRecognizerDelegate>

@end

@implementation ButtonAndTapVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *_button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
    [_button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [_button setTitle:@"我是按钮" forState:UIControlStateNormal];
    _button.backgroundColor = [UIColor redColor];
    [self.view addSubview:_button];
    
    
    UIPanGestureRecognizer *tap = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(gestureRecon:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{


    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}


- (void)buttonPress:(id)sender{
    
    NSLog(@"buttonPress");
}

- (void)gestureRecon:(id)sender{
    
    NSLog(@"gestureRecon");
}




@end
