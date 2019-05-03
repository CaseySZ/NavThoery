//
//  GestureCoexistVCtr.m
//  EventTheory
//
//  Created by sy on 2018/7/20.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "GestureCoexistVCtr.h"
#import "SYPanGestureOne.h"
#import "SYPanGestureTwo.h"

@interface GestureCoexistVCtr ()<UIGestureRecognizerDelegate>{
    
}

@end

@implementation GestureCoexistVCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(50, 130.f, 300, 300)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(50, 150, 150, 150)];
    yellowView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:yellowView];
    
    
    SYPanGestureOne *gestureOne = [[SYPanGestureOne alloc] initWithTarget:self action:@selector(oneAction:)];
   // gestureOne.delegate = self;
    [redView addGestureRecognizer:gestureOne];
    
    SYPanGestureTwo *gestureTwo = [[SYPanGestureTwo alloc] initWithTarget:self action:@selector(twoAction:)];
    gestureOne.delegate = self;
    [yellowView addGestureRecognizer:gestureTwo];
}

- (void)oneAction:(id)sender{
    
    NSLog(@"oneAction");
    
}

- (void)twoAction:(id)sender{
    
    NSLog(@"twoAction");
}


/*
  YES 两个手势共存， // touch
 注意 共存之间有响应链级别关系
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}



@end
