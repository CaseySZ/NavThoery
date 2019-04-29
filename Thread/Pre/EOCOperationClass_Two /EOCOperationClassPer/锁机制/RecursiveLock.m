//
//  RecursiveLock.m
//  EOCOperationClassPer
//
//  Created by sy on 2017/10/30.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "RecursiveLock.h"
#import <pthread.h>

/*
 OC的锁基于c的封装，锁对象化了
 */

@implementation RecursiveLock{
    
    
    
}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self oc_recursiveLockinit];
        [self c_recursiveLockinit];
    }
    return self;
}


- (void)oc_recursiveLockinit{
    
    recursiveLock = [[NSRecursiveLock alloc] init];
}

- (void)c_recursiveLockinit{
    
    pthread_mutexattr_t attr;
    pthread_mutexattr_init (&attr);
    pthread_mutexattr_settype (&attr, PTHREAD_MUTEX_RECURSIVE);
    pthread_mutex_init (&_reclock, &attr);
    pthread_mutexattr_destroy (&attr);
    
}

- (void)recursiveLock{
    
    NSLog(@"start");
    NSLog(@"result:%d", [self addCount:10]);
    NSLog(@"end");
}

- (void)recursiveLockTheory{
    
    NSLog(@"theory start");
    NSLog(@"theory result:%d", [self addC__Count:10]);
    NSLog(@"theory end");
}
// 递归里面做安全策略，用互斥锁会造成死锁的
- (int)addCount:(int)count{
    
    [recursiveLock lock];
    if (count < 1) {
        return count;
    }
    __block int tmp;
   
    NSLog(@"count::%d", count);
    tmp = count + [self addCount:count-1];
    
    [recursiveLock unlock];
    return tmp;
}

- (int)addC__Count:(int)count{
    
    pthread_mutex_lock(&_reclock);
    if (count < 1) {
        return count;
    }
    __block int tmp;
    
    NSLog(@"theory count::%d", count);
    tmp = count + [self addC__Count:count-1];

    pthread_mutex_unlock(&_reclock);

    return tmp;
}



@end
