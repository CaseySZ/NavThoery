//
//  GestureViewCtr.m
//  EventTheory
//
//  Created by sy on 2018/7/18.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "GestureViewCtr.h"
#import "SYPanGestureRecognizer.h"
#import "SYRedView.h"
#import "SYTapGesture.h"

@interface GestureViewCtr (){
    
    SYRedView *_redView;
}

@end

@implementation GestureViewCtr

- (void)viewDidLoad {
   
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _redView   = [[SYRedView alloc] initWithFrame:CGRectMake(70, 100, 200, 300)];
    [self.view addSubview:_redView];

    
    SYPanGestureRecognizer *gesture = [[SYPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [_redView addGestureRecognizer:gesture];
    
    
//    SYTapGesture *tapGesture = [[SYTapGesture alloc] initWithTarget:self action:@selector(tapGesture:)];
//    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)tapGesture:(SYTapGesture*)gesture{
    
    NSLog(@"tapGesture");
    
}

- (void)panGesture:(SYPanGestureRecognizer*)gesture{
    
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"UIGestureRecognizerStateBegan");
    }
    if (gesture.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
    }
    if (gesture.state == UIGestureRecognizerStateCancelled) {
        NSLog(@"UIGestureRecognizerStateCancelled");
    }else{
        NSLog(@"UIGestureRecognizerState");
    }
    
}



@end
