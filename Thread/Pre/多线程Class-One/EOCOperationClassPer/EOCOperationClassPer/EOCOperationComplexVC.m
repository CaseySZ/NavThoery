//
//  EOCOperationComplexVC.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/20.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCOperationComplexVC.h"
#import "EOCOperationQueue.h"
#import "EocOperation.h"

/*
 ⚠️ operation 的队列优先级只决定当前所有 isReady 状态为 YES 的 operation 的执行顺序
 优先级高的任务，调用的几率会更大
 
 */
@interface EOCOperationComplexVC (){
    
    EOCOperationQueue *operationQueue;
    EocOperation *eocOperaion;
    NSBlockOperation *blockOp;
}

@end

@implementation EOCOperationComplexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"依赖、优先级";

    
    operationQueue = [EOCOperationQueue new];
    operationQueue.maxConcurrentOperationCount = 3;
    
    eocOperaion = [EocOperation new];
    [eocOperaion setQueuePriority:NSOperationQueuePriorityVeryHigh];
    
    blockOp = [NSBlockOperation new];
    
    [blockOp addExecutionBlock:^{
        NSLog(@"One start");
        sleep(1);
        NSLog(@"One finish");
    }];
    
    NSBlockOperation *blockOpTwo = [NSBlockOperation new];
    
    [blockOpTwo addExecutionBlock:^{
        NSLog(@"Two start");
        sleep(1);
        NSLog(@"Two finish");
    }];
    
//    [eocOperaion addDependency:blockOp];
//    [blockOp addDependency:blockOpTwo];

    // 入队列之前 处理好关系
    
    [operationQueue addOperation:eocOperaion];
    [operationQueue addOperation:blockOp];
    [operationQueue addOperation:blockOpTwo];
    
    
//    if (eocOperaion.isReady) {
//        NSLog(@"eocOperaion ready");
//    }
//    if (blockOp.isReady) {
//        NSLog(@"blockOp ready");
//    }
//    if (blockOpTwo.isReady) {
//        NSLog(@"blockOpTwo ready");
//    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [eocOperaion removeDependency:blockOp];
}



@end
