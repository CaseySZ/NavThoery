//
//  EOCOpererationVC.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/19.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCOpererationVC.h"
#import "EocOperation.h"
#import "SimpleOperation.h"


@interface EOCOpererationVC (){
    
    NSOperationQueue *queue;
}

@end

@implementation EOCOpererationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自定义";
    queue = [NSOperationQueue new];
    
    EocOperation *eocOperation = [EocOperation new];
   // SimpleOperation *simpOperation = [SimpleOperation new];
    
    [queue addOperation:eocOperation];
   // [queue addOperation:simpOperation];
    
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    
}

- (void)dealloc{
     NSLog(@"%s", __func__);
}

@end
