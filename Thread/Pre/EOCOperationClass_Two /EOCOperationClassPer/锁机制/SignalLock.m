//
//  SignalLock.m
//  ThreadClass
//
//  Created by sunyong on 17/3/7.
//  Copyright © 2017年 @八点钟学院. All rights reserved.
//

#import "SignalLock.h"
#import <pthread.h>

@interface SignalLock (){
   
    NSLock *mutexLock;
    dispatch_semaphore_t sema;
    int count;
}
@end

@implementation SignalLock

- (instancetype)init{
    self = [super init];
    if (self) {
        
        mutexLock = [NSLock new];
        sema = dispatch_semaphore_create(0);
        
    }
    return self;
}

- (void)signalLock{
    
    [NSThread detachNewThreadSelector:@selector(threadOne) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(threadTwo) toTarget:self withObject:nil];
}

- (void)threadOne{
    
    [self signalLockWrite];
}


- (void)threadTwo{
    
     [self signalLockRead];
}

#pragma mark -  信号量+ 互斥锁（死锁）
///////// 信号量 + 互斥锁（死锁）
- (void)signalLockWrite{
    
    while (1) {
        [mutexLock lock];
        if (count >= 10) {
            // 没有内存了
            NSLog(@"空间满了");
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER); // 阻塞
        }else{
            
            count++;
            NSLog(@"空间:%d", count);
        }
        [mutexLock unlock];
    }
}
- (void)signalLockRead{
    
    while (1) {
        [mutexLock lock];
        
        if (count >= 10) {
            count--;
            NSLog(@"释放空间");
            dispatch_semaphore_signal(sema);
        }else{
            count++;
        }
        [mutexLock unlock];
    }
}

@end
