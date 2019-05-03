//
//  TestViewCtr.m
//  SafeGesture
//
//  Created by Casey on 01/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import "TestViewCtr.h"
#import "GestureLockView.h"
#import "YWGesturesUnlockView.h"
#import "GestureLockMiniView.h"
#import "SystemAuthView.h"
#import "SafeLockPlugIn.h"

@interface TestViewCtr ()

@end

@implementation TestViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationController.navigationBar.translucent = NO;
    
    GestureLockMiniView *gestureSaveView = [GestureLockMiniView instance];
    
    gestureSaveView.frame = CGRectMake(0, 100, 60, 60);
   // [self.view addSubview:gestureSaveView];
    
    
    
    
    GestureLockView *lockView = [[GestureLockView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400)];
   // lockView.isSettingLockStyle = YES;
   
    
    //[self.view addSubview:lockView];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
    
    [SafeLockPlugIn openUnlockView:^(SysSafeHandleStatus finsishStatus) {
        
    } changeLoginMethod:^{
        
    }];
    
    
}


@end
