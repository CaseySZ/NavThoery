//
//  ConflictViewCtr.m
//  EventTheory
//
//  Created by sy on 2018/7/19.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "MultiEventViewCtr.h"
#import "TestOneView.h"
#import "TestTwoView.h"

/*
 
 */

@interface MultiEventViewCtr ()

@end

@implementation MultiEventViewCtr


- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
   // [self touchUp];
    [self gestureUp];
}

// touch
- (void)touchUp{
    
    TestOneView *oneView = [[TestOneView alloc] initWithFrame:CGRectMake(50, 100, 200, 300)];
    oneView.backgroundColor = [UIColor redColor]; // super
    [self.view addSubview:oneView];
    
    TestTwoView *twoView = [[TestTwoView alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
    twoView.backgroundColor = [UIColor blueColor]; // no super
    [self.view addSubview:twoView];
    
}

// 手势
- (void)gestureUp{
    
    
    TestOneView *oneView = [[TestOneView alloc] initWithFrame:CGRectMake(50, 100, 300, 300)];
    oneView.backgroundColor = [UIColor redColor];
    [self.view addSubview:oneView];
    
    
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
//    [self.view addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *tapGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)tapGesture:(UITapGestureRecognizer*)gesture{
    
    NSLog(@"tapGesture");
    
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
