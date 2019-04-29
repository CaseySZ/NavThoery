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
    
    NSCondition *_condition;
    int count;
    
    pthread_mutex_t mutex; // NSLock OC的互斥锁
    pthread_cond_t cond;
}

@end;



@implementation C_ConditionLock

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _condition = [NSCondition new];
        count = 0;
        
        pthread_mutex_init(&mutex, 0);
        pthread_cond_init(&cond, 0);
        
    }
    
    return self;
}

- (void)signalLock{
    
    [NSThread detachNewThreadSelector:@selector(threadOne) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(threadTwo) toTarget:self withObject:nil];
}

- (void)conditionLockTheory{
    
    [NSThread detachNewThreadSelector:@selector(conditionLockOne) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(conditionLockTwo) toTarget:self withObject:nil];
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
        
        [_condition lock];
        if (count >= 10) {
            // 没有内存了
            NSLog(@"空间满了");
            [_condition wait];
        }else{
            count++;
        }
        [_condition unlock];
    }
}

- (void)signalLockRead{
    
    while (1) {

        [_condition lock];
        if (count >= 10) {
            count--;
            NSLog(@"释放空间");
            [_condition signal];
        }else{
            count++;
        }
        [_condition unlock];
    }
}

// theory c  OC条件量的c实现
- (void)conditionLockOne{
  
    while (1) {
        
        pthread_mutex_lock(&mutex);
        if (count >= 10) {
            // 没有内存了
            NSLog(@"空间满了");
            pthread_cond_wait(&cond, &mutex);// 阻塞 但是mutex这个解了
        }else{
            count++;
        }
        pthread_mutex_unlock(&mutex);
    }
}

- (void)conditionLockTwo
{
    while (1) {
        
        pthread_mutex_lock(&mutex);
        if (count >= 10) {
            count--;
            NSLog(@"释放空间");
            pthread_cond_signal(&cond);
        }else{
            count++;
        }
        pthread_mutex_unlock(&mutex);
    }
}

@end
