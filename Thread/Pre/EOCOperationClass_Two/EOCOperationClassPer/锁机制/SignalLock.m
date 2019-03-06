//
//  SignalLock.m
//  ThreadClass
//
//  Created by sunyong on 17/3/7.
//  Copyright © 2017年 @八点钟学院. All rights reserved.
//

#import "SignalLock.h"

@interface SignalLock (){
    
    dispatch_semaphore_t _sema;
    NSLock *lock;
    int _count;
}
@end

@implementation SignalLock

- (instancetype)init{
    self = [super init];
    if (self) {
        lock = [[NSLock alloc] init];
        _sema = dispatch_semaphore_create(0);
        _count = 0; // 代表内存空间
    }
    return self;
}

- (void)signalLock{
    
    [NSThread detachNewThreadSelector:@selector(signalLockWrite) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(signalLockRead) toTarget:self withObject:nil];
}

#pragma mark -  信号量+ 互斥锁（死锁）
///////// 信号量+ 互斥锁（死锁）
- (void)signalLockWrite{
    
    while (1) {
        [lock lock];
        NSLog(@"signalLockWrite lock");
        if (_count >= 10) {
            NSLog(@"空间满了，等待中--%d", _count);
            dispatch_semaphore_wait(_sema, DISPATCH_TIME_FOREVER);// 
        }
        _count++;
        [lock unlock];
        NSLog(@"signalLockWrite unlock");
    }
}

- (void)signalLockRead{
    
    while (1) {
        NSLog(@"signalLockRead lock");
        [lock lock];
        if (_count > 10) {
            _count--;
            NSLog(@"释放空间～");
            dispatch_semaphore_signal(_sema);//_sema++
        }else {
            _count++;
        }
        NSLog(@"signalLockRead lock");
        [lock unlock];
    }
    
}

@end
