//
//  GestureSettingViewCtr.m
//  SafeGesture
//
//  Created by Casey on 26/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import "GestureSettingViewCtr.h"
#import "GestureLockView.h"


@interface GestureSettingViewCtr ()<SysSafeHandleProtocol>

@property (nonatomic, strong)GestureLockView *gestureLockView;

@end

@implementation GestureSettingViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置手势密码";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.view.backgroundColor = UIColor.whiteColor;
    
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    self.gestureLockView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
}


- (void)backAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.completion = nil;
    
}


#pragma mark - SysSafeHandleProtocol

- (void)handleSuccess:(NSString*)result{
    
    if (self.completion) {
        self.completion(SafeTypeGesture, SysSafeAuthSuccess);
        self.completion = nil;
    }
    
    [SysSafeIDModel setSafeLockType:SafeTypeGesture];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)handleError:(SysSafeHandleStatus)errorStatus {
    

}


- (GestureLockView*)gestureLockView {
    
    if (!_gestureLockView) {
        _gestureLockView = [[GestureLockView alloc] init];
        _gestureLockView.delegate = self;
        _gestureLockView.isSettingLockStyle = YES;
        [self.view addSubview:_gestureLockView];
    }
    
    return _gestureLockView;
}


@end
