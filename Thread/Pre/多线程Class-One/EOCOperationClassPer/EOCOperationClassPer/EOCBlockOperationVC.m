//
//  EOCBlockOperation.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/19.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCBlockOperationVC.h"
/*
 operationQueue
 结合NSOperation的子类进行操作
 调度任务的需要和系统当前的负载情况来决定当前最多执行数。
 
 
 NSBlockOperation ：我们可以使用 NSBlockOperation来并发执行一个或多个block,
 只有当一个NSBlockOperation所关联的所有block都执行完毕时，这个NSBlockOperation才算执行完成
 
 add block没有先进先出的概念，随机的，每一个block在不同的线程中执行。 手动开启时，第一开启的block在当前线程执行（当前线程为主线程即为主线程）

 */
@interface EOCBlockOperationVC (){
    NSBlockOperation *blockOperation;
    NSOperationQueue *operationQueue;
}

@end

@implementation EOCBlockOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    operationQueue = [NSOperationQueue new];
    
    blockOperation = [NSBlockOperation new];
    
    [blockOperation addExecutionBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"one finish");
    }];
    
    [blockOperation addExecutionBlock:^{
       NSLog(@"%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"two finish");
    }];
    
    [blockOperation addExecutionBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
        sleep(1);
        NSLog(@"three finish");
    }];
    
   // [blockOperation start];
    
   // operationQueue.maxConcurrentOperationCount = 4;
    [operationQueue addOperation:blockOperation];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    
}




@end
