//
//  EOCLockVC.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/21.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCLockVC.h"
#import <pthread.h>

/*

 */

@interface EOCLockVC (){
    

}


@end

@implementation EOCLockVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
   
    NSLock; // 互斥锁 pthread_mutex_t
    NSConditionLock;// 条件锁  能够解决死锁问题 pthread_cond_t; pthread_cond_signal
    dispatch_semaphore_t; //
    
    /*
      解决死锁的原理 通过 c锁机制来追踪
     */
    
    /*
     最容易导致死锁的一个情况
     信号锁 + 互斥锁 ，没处理好，导致死锁
     
     NSConditionLock 解决死锁
     */
}



- (void)mutualLock{
   
    
}

@end
