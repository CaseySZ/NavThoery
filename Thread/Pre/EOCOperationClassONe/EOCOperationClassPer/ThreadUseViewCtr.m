//
//  ThreadUseViewCtr.m
//  EOCOperationClassPer
//
//  Created by sy on 2017/10/27.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ThreadUseViewCtr.h"

@interface ThreadUseViewCtr (){
    
    NSThread *_thread;
}

@end

@implementation ThreadUseViewCtr

/*
 NSThread 一线程对象 对应一个线程，当执行完之后，不能重新开启
 一个线程也是单独
 
 作业：用NSThread 实现三个线程任务A，B，C，然后三个任务结束之后，执行D任务
 
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"NSThread";
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 主动开线程
    [NSThread detachNewThreadSelector:@selector(threadOne) toTarget:self withObject:nil];
    
    //手动开启
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadTwo) object:nil];
    [_thread start];
}

- (void)threadOne{
    
    NSLog(@"threadOne:%@", [NSThread currentThread]);
    
}

- (void)threadTwo{
    NSLog(@"threadTwo::%@", [NSThread currentThread]);
    for (int i = 0; i < 5; i++) {
        
        if([NSThread currentThread].isCancelled){
            return;
        }
        
        sleep(2);
        NSLog(@"%d", i);
        // 取消，正在要取消线程要设置取消节点
        if([NSThread currentThread].isCancelled){
            
            return;
        }
    }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [_thread cancel];
}



@end
