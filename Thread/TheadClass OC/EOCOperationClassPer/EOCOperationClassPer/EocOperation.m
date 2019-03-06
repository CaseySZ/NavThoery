//
//  EocOperation.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EocOperation.h"

/*
 
 */

@implementation EocOperation

@synthesize finished = _finished;
@synthesize executing = _executing;



- (void)main{
    
    NSLog(@"%s--%@", __func__, [NSThread currentThread]);
    if (self.isCancelled) {
        [self overStatus];
        return;
    }
    
    for (int i = 0; i < 5; i++) {
        if (self.isCancelled) {
            [self overStatus];
            return;
        }
        NSLog(@"处理业务%d", i);
        sleep(1);
    }
    
    [self overStatus];
}


- (void)overStatus{
    
    [self willChangeValueForKey:@"isFinished"];
    _finished = YES;
    [self didChangeValueForKey:@"isFinished"];
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = NO;
    [self didChangeValueForKey:@"isExecuting"];
    
}

- (void)configfinishNO{
    _finished = NO;
    
}

- (void)start{
    
    NSLog(@"%s--%@", __func__, [NSThread currentThread]);
    
    
    if (self.isCancelled) {
        [self overStatus];
        return;
    }
    if (self.isExecuting) {
        
        return;
    }
    
    if (self.finished) {
        [self overStatus];
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing = YES;
    [NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    [self didChangeValueForKey:@"isExecuting"];
    
    
    
    
}


- (BOOL)isFinished{
    
    return _finished;
}



- (void)dealloc{
    
    NSLog(@"%s", __func__);
}


@end
