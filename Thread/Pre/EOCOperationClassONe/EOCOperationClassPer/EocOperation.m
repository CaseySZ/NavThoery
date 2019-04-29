//
//  EocOperation.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EocOperation.h"

/*
 start
 main
 */
/*
  改变_finished状态 YES
 */
@implementation EocOperation{
    
    NSTimer *_timer;
}
@synthesize finished = _finished;


- (void)main{

    // 主要的业务逻辑放到这里处理
    NSLog(@"main2");
    _finished = YES;
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] run];
}

- (void)timeCount{
    static int count = 0;
    count++;
    if (count > 5) {
        [_timer invalidate];
    }
    NSLog(@"timeCount");
    
}


- (void)start{

    //异常处理
    NSLog(@"%@", [NSThread currentThread]);
    //[NSThread detachNewThreadSelector:@selector(main) toTarget:self withObject:nil];
    // self.finished = YES
    if (_finished) {
        return;
    }
    if (self.isExecuting) {
        return;
    }
    NSLog(@"start");
    
    [self main];
}

/*
 dealloc 没被执行，是因为EocOperation的状态为未完成状态 _finished = NO；
 self.finished属性是仅读的，
 */
- (void)dealloc{
    
    NSLog(@"start::%s", __func__);
}


@end
