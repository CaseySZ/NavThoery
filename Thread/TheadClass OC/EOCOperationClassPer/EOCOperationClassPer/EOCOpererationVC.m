//
//  EOCOpererationVC.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/19.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCOpererationVC.h"
#import "EocOperation.h"
#import "EOCOperationQueue.h"

/*
 
 1 内存泄漏问题，需要finish状态为YES（且队列里面有Opretion，队列就不会被释放）
 1先重写系统的finish的Get函数，返回YES，发现Operation移除队列了
 2然后在main后面把finish置为YES， 发现Operation没有移除队列
 3在main后面添加手动发送finish属性变化通知（KVO）， Operation移除队列了
 
 2 取消问题：
 需要在不同的时间节点检查是否取消，并配置相关属性
 
 3 自定义需要重写属性状态值
 
 */

@interface EOCOpererationVC (){
    
    EOCOperationQueue *operationQueue;
    EocOperation *eocOperaion;
}

@end

@implementation EOCOpererationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义";
 
    operationQueue = [EOCOperationQueue new];
    
    eocOperaion = [EocOperation new];
    
    [operationQueue addOperation:eocOperaion];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    //[operationQueue cancelAllOperations];
   // [eocOperaion cancel];
    
}

- (void)dealloc{
     NSLog(@"%s", __func__);
}

@end
