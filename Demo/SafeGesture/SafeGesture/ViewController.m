//
//  ViewController.m
//  SafeGesture
//
//  Created by Casey on 01/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import "ViewController.h"
#import "TestViewCtr.h"
#import "SysSafeIDModel.h"
#import "UnlockSafeLoginView.h"
#import "SafeLockPlugIn.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event  {
    
    
//    [SafeLockPlugIn alertOpenSettingLockView:^(SysSafeType type, SysSafeHandleStatus resultStatus) {
//
//
//        NSLog(@"%d--%d", type, resultStatus);
//
//    }];
    
    [SafeLockPlugIn openUnlockView:^(SysSafeHandleStatus finsishStatus) {

        NSLog(@"finsishStatus::%d", finsishStatus);

    } changeLoginMethod:^{



    }];
    
//    [SafeLockPlugIn alterOpenSafeLock:^(SysSafeType type, NSError *error) {
//        
//        if (!error) {
//            NSLog(@"成功");
//        }else {
//            NSLog(@"%@", error);
//        }
//    }];
//    [SysSafeIDModel isSupportSysAuthentication];
//    
//    
//    UnlockSafeLoginView *UnlockSafeLoginView = [[UnlockSafeLoginView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//    //UnlockSafeLoginView.isSettingLock = YES;
//    [self.view addSubview:UnlockSafeLoginView];
//    
//    return;
    
//    [SysSafeIDModel callSysSafeVerify:^(SysSafeHandleStatus status) {
//
//        NSLog(@"%d", status);
//    }];
//
//    TestViewCtr *testViewCtr = [TestViewCtr new];
//    [self.navigationController pushViewController:testViewCtr animated:YES];
    
}


@end
