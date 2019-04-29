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
#import "RecursiveLock.h"

/*

 */
@interface EOCLockVC (){
    
    SignalLock *_signalLock;
    C_ConditionLock *condition;
    RecursiveLock *recursiveLock;
}

@end

@implementation EOCLockVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
   // NSLock *lock = [NSLock new]; // 基于C的锁进行封装的，进行了对象化
//
//    _signalLock = [SignalLock new];
//    [_signalLock signalLock];

    condition = [C_ConditionLock new];
    [condition signalLock];
    
//    recursiveLock = [RecursiveLock new];
//    [recursiveLock recursiveLock];
//    [recursiveLock recursiveLockTheory];
}








@end
