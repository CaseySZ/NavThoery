//
//  C_ConditionLock.m
//  ThreadClass
//
//  Created by sunyong on 17/3/7.
//  Copyright © 2017年 @八点钟学院. All rights reserved.
//

#import "C_ConditionLock.h"
#import <pthread.h>

@interface C_ConditionLock(){
    NSLock *lock;
    NSCondition *conditionLock; // 条件量+信号量
    pthread_mutex_t mutex_t;
    pthread_cond_t cond_t;
    int _count;
}

@end;



@implementation C_ConditionLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        lock = [NSLock new];
        conditionLock = [NSCondition new];
        
        pthread_mutex_init(&mutex_t, 0);
        pthread_cond_init(&cond_t, 0);
        
    }
    return self;
}

- (void)conditionLock{
    [NSThread detachNewThreadSelector:@selector(conditionLockOne) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(conditionLockTwo) toTarget:self withObject:nil];
}

- (void)conditionLockTheory
{
    [NSThread detachNewThreadSelector:@selector(threadOne) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(threadTwo) toTarget:self withObject:nil];
}

#pragma mark - 条件俩 + 互斥锁(防止死锁) OC
- (void)conditionLockOne{
    
    while (1) {
        [conditionLock lock];
        NSLog(@"signalLockWrite lock");
        if (_count >= 10) {
            NSLog(@"空间满了，等待中--%d", _count);
            [conditionLock wait];
        }
        _count++;
        [conditionLock unlock];
        NSLog(@"signalLockWrite unlock");
    }
    
}

- (void)conditionLockTwo
{
    while (1) {
        NSLog(@"signalLockRead lock");
        [conditionLock lock];
        if (_count > 10) {
            _count--;
            NSLog(@"释放空间～");
            [conditionLock signal];
        }else {
            _count++;
        }
        NSLog(@"signalLockRead lock");
        [conditionLock unlock];
    }
    
}


#pragma mark - C用法条件量 （原理）
- (void)threadOne{
    
    while (1) {
        pthread_mutex_lock(&mutex_t);
        NSLog(@"signalLockWrite lock");
        if (_count >= 10) {
            NSLog(@"空间满了，等待中--%d", _count);
           // [conditionLock wait];
            pthread_cond_wait(&cond_t, &mutex_t);
        }
        _count++;
        pthread_mutex_unlock(&mutex_t);
        NSLog(@"signalLockWrite unlock");
    }
}

- (void)threadTwo{
    
    while (1) {
        NSLog(@"signalLockRead lock");
        pthread_mutex_lock(&mutex_t);
        if (_count > 10) {
            _count--;  
            NSLog(@"释放空间～");
           // [conditionLock signal];
            pthread_cond_signal(&cond_t);
        }else {
            _count++;
        }
        NSLog(@"signalLockRead lock");
        pthread_mutex_unlock(&mutex_t);
    }
}

@end
