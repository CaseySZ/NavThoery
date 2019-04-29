//
//  EOCBlockOperation.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/19.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCBlockOperationVC.h"
/*
 operation 也可以手动开启
 block并不是先添加就先执行，当operation执行，就不能在添加block
 NSBlockOperation里面block块全部结束，那么这个NSBlockOperation才算结束（即finished = YES）
 
 //运用 ：多个任务处理（任务A，任务B，任务C）三个任务完成了，通过KVO监听得到 （任务是block块）

 手动开启的时候，会分配一个到主线程上执行
 
 */

@interface EOCBlockOperationVC (){
    NSBlockOperation *blockOperation;
    NSOperationQueue *operationQueue;
}

@end

@implementation EOCBlockOperationVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    void (^tblock)() = ^{
        
       NSLog(@"tblock:%@", [NSThread currentThread]);
    };
    
    operationQueue = [NSOperationQueue new];
    blockOperation = [[NSBlockOperation alloc] init];
    
    [blockOperation addObserver:self forKeyPath:@"isFinished" options:NSKeyValueObservingOptionNew context:nil];
    
//    [blockOperation addExecutionBlock:^{
//        NSLog(@"one block:%@", [NSThread currentThread]);
//    }];
//    [blockOperation addExecutionBlock:^{
//        NSLog(@"two block:%@", [NSThread currentThread]);
//    }];
    
    [blockOperation addExecutionBlock:tblock];
    
 //   [operationQueue addOperation:blockOperation];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
   
    NSLog(@"%@", keyPath);
    NSLog(@"%@", change);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
 
    /*
     start 没有重复开启： 因为在start方法里面对blockOperation的状态finish状态进行判断，
     如果finish=YES，就不会执行了
     
     main 直接是掉用block
     
     需要注意的点
     */
    [blockOperation start];
 //   [blockOperation start];
  //  [blockOperation main];
}




@end
