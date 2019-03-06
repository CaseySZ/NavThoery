//
//  GCDTwoViewVC.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/24.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "GCDTwoViewVC.h"
// GCD 同步异步， block（task） 资源， 对象
@interface GCDTwoViewVC (){
    dispatch_queue_t queue;
}

@end

@implementation GCDTwoViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    void (*test)() = gcdFct;
//    test();
//    
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        NSLog(@"dispatch_get_main_queue _dispatch_sync");
//    });
//    
    queue = dispatch_queue_create("eoc_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_set_context(queue, gcdFct);
    
    
    
    [self after_fct];
}

// 延时  基于C  MKTime
- (void)after_fct{

    //dispatch_queue_t queue = dispatch_queue_create("eoc_queue", DISPATCH_QUEUE_CONCURRENT);
    void (*test)() = dispatch_get_context(queue);
    test();
    
    return;
    
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; i++) {
            sleep(1);
        }
        dispatch_after(2, queue, ^{
            NSLog(@"dispatch_after:%@", [NSThread currentThread]);
        });
    });
    
    
    
}

void gcdFct(){
    NSLog(@"gcdFct");
}

// 定时器
dispatch_source_t soure;
- (void)targetSource{
    
    dispatch_queue_t queue = dispatch_queue_create("eoc_queue", DISPATCH_QUEUE_CONCURRENT);
    // io
    soure = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(soure, DISPATCH_TIME_NOW, 1, 1);
    
    dispatch_source_set_event_handler(soure, ^{
        
        NSLog(@"soure_event:==%@", [NSThread currentThread]);
    });
    
    
    dispatch_resume(soure);
    
}



@end
