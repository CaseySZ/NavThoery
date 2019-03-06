//
//  GCDViewCtr.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/23.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "GCDViewCtr.h"

@interface GCDViewCtr ()

@end

@implementation GCDViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // main global(4)
    
    [self serialQueue];
}

/*
 
 ------- 1
 ------- 2
    |
    ————————
    |
    ---------
 并行（线程）
 并发（任务task）
 当有多线程操作时， 如果系统只有一个cpu ，根本不可能真正同时进行一个以上的线程， 只能把cup运行时间划分，若干段， 在讲时间分配给各个线程执行，在一个时间段的线程代码运行时，其他的处于挂起状态，并发
 
  系统一个以上cpu时，线程才有可能非并发，一个cpu执行一个线程， 另cpu也执行一个线程， 两相互抢，同时进行，并行
 
 */
// 全局队列
- (void)global_queue{
    dispatch_queue_t queue1 =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_queue_t queue2 =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_queue_t queue3 =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_queue_t queue4 =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
    NSLog(@"%p, %p, %p, %p", queue1, queue2,queue3 ,queue4);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    dispatch_queue_t queue1 =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    NSLog(@"%p", queue1);
}

// 串行队列 没有并发，每次执行一个任务 先进先出
// 同步： 这段代码必须返回来（执行完），下面才能继续执行
// dispatch_get_main_queue()  // 在主线程
// DISPATCH_QUEUE_SERIAL  NULL


void ecoFect(){
    
    NSLog(@"ecoFect");
}

- (void)serialQueue{
    
    
    dispatch_queue_t queue = dispatch_queue_create("eoc_queue", NULL);
    
    //dispatch_async_f(queue, NULL, ecoFect);
    
//    dispatch_sync(queue, ^{
//        NSLog(@"One_task:%@", [NSThread currentThread]);
//    });
//    
//    dispatch_async(queue, ^{
//        NSLog(@"Two_task:%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"Three_task:%@", [NSThread currentThread]);
//    });
//    
}

// 并行队列
- (void)concurrentQueue{
    dispatch_queue_t queue = dispatch_queue_create("eoc_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"One_task:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"Two_task:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"Three_task:%@", [NSThread currentThread]);
    });
    
//    dispatch_async(queue, ^{
//        NSLog(@"One_task:%@", [NSThread currentThread]);
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"Two_task:%@", [NSThread currentThread]);
//    });dispatch_async(queue, ^{
//        NSLog(@"Three_task:%@", [NSThread currentThread]);
//    });
    
}


////配置组notify
- (void)group_fct{
    
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("eoc_queue", DISPATCH_QUEUE_CONCURRENT);
//    NSOperationQueue;
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"one_task");
        sleep(1);
        NSLog(@"one_task over");
    });
    
    dispatch_group_notify(group, queue, ^{
        NSLog(@"notify___ no Task");
    });
    
    dispatch_group_async(group, queue, ^{
        
        NSLog(@"4_task");
        sleep(1);
        NSLog(@"4_task over");
    });
    
    //
    dispatch_group_enter(group);
    dispatch_group_leave(group);
    
    
}
// 有一定条件下的业务

//设置屏障
- (void)barrier_fct{

    //(NSOperation net)
    dispatch_queue_t queue = dispatch_queue_create("eoc_queue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"One");
        sleep(1);
        NSLog(@"One finish");
    });
    dispatch_async(queue, ^{
        NSLog(@"Two");
        sleep(2);
        NSLog(@"Two finish");
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"barrier");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"four");
    });
}

- (void)apply_fct{
    
    dispatch_queue_t queue = dispatch_queue_create("eoc_queue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_apply(5, queue, ^(size_t count) {
        NSLog(@"%d====%@",(int)count,  [NSThread currentThread]);
    });
    
}

@end
