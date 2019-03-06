//
//  EOCLockVC.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/21.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCLockVC.h"
#import <pthread.h>
#import "SignalLock.h"
#import "C_ConditionLock.h"

/*
 死锁
 GCD
 GCD 源码
 GCD runloop关系
 */
@interface EOCLockVC (){
    
}

@end

@implementation EOCLockVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    SignalLock *signlc = [SignalLock new];
//    [signlc signalLock];
    
    C_ConditionLock *condit = [C_ConditionLock new];
    [condit conditionLockTheory];
}






@end
