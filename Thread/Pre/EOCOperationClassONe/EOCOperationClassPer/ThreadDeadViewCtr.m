//
//  ThreadDeadViewCtr.m
//  EOCOperationClassPer
//
//  Created by sy on 2017/10/26.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ThreadDeadViewCtr.h"

@interface ThreadDeadViewCtr (){
    
    NSPort *port;
    NSTimer *_timer;
}

@end

@implementation ThreadDeadViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSThread detachNewThreadSelector:@selector(ThreadTwo) toTarget:self withObject:nil];
    
}

- (void)ThreadOne{
    
    NSLog(@"start thread");
    port = [NSPort new];
    [self performSelector:@selector(endThread:) withObject:nil afterDelay:2];
    [[NSRunLoop currentRunLoop] addPort:port forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
    
    NSLog(@"finish thread");
    for (int i = 0; i < 5; i ++) {
        NSLog(@"%d", i);
    }
}

- (void)ThreadTwo{
    
    NSLog(@"start thread");
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(stopTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] run];
    
    NSLog(@"finish thread");
    for (int i = 0; i < 5; i ++) {
        NSLog(@"%d", i);
    }
}

- (IBAction)startThread:(id)sender{
    
    [_timer invalidate];
}

- (IBAction)endThread:(id)sender{
    
    [[NSRunLoop currentRunLoop] removePort:port forMode:NSDefaultRunLoopMode];
    NSLog(@"IBAction Two");
}

- (IBAction)stopTimer:(id)sender{
    
    NSLog(@"stopTimer");
    
    static int count = 0;
    count++;
    if (count > 5) {
        [_timer invalidate];
    }
    
}

- (IBAction)removePort:(id)sender{
    
        
}


@end


