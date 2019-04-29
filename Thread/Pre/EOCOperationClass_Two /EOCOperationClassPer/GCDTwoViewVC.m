//
//  GCDTwoViewVC.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/24.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "GCDTwoViewVC.h"

@interface GCDTwoViewVC (){
    dispatch_queue_t queue;
}

@end

/*
 第一步dispatch_async
 
 EOCClass 1-7 _dispatch_queue_push_inline ---->dx_wakeup (runloop-->wakeup-->dispatchPort-->_dispatch_main_queue_callback_4CF[GCD]-->_dispatch_main_queue_drain
     ----->_dispatch_continuation_pop_inline--->dx_invoke
 )
 */

/*
 主线程是可以其他队列的任务进行操作的
 mainqueue的任务肯定在是主线程上操作的
 */
@implementation GCDTwoViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    queue = dispatch_queue_create("eoc_queue", DISPATCH_QUEUE_CONCURRENT);
    [self timeSource];

    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"1:%@", [NSThread currentThread]);
    });
    
}

// 定时器  unix (pthread) GCD()
dispatch_source_t soure;
- (void)timeSource{
   // dispatch_object_t;
    // 1 创建一个队列
    dispatch_queue_t eoc_queueOneTT = dispatch_queue_create("eoc_queueOneTT", DISPATCH_QUEUE_SERIAL);
    // io source关联到队列
    soure = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 配置soure的时间
    dispatch_source_set_timer(soure, DISPATCH_TIME_NOW, 1, 1);
    // 配置source的处理事件
    dispatch_source_set_event_handler(soure, ^{
        
        NSLog(@"soure_event:==%@", [NSThread currentThread]);
    });
    // 开启定时器
    dispatch_resume(soure);
    
}



@end
