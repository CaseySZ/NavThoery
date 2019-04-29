//
//  EOCOperationComplexVC.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/20.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCOperationComplexVC.h"
#import "EocOperation.h"


@interface EOCOperationComplexVC (){
    
    NSOperationQueue *queue;
}

@end

@implementation EOCOperationComplexVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"依赖";
    queue = [NSOperationQueue new];
    
    NSBlockOperation *eocOperation = [[NSBlockOperation alloc] init];
    [eocOperation addExecutionBlock:^{
        NSLog(@"one block task");
    }];
    [eocOperation addExecutionBlock:^{
        NSLog(@"two block task");
    }];
    
    NSBlockOperation *twoOperation = [[NSBlockOperation alloc] init];
    [twoOperation addExecutionBlock:^{
        NSLog(@"Three block task");
    }];
    [twoOperation addExecutionBlock:^{
        NSLog(@"Four block task");
    }];
    
    // 先后顺序关系 twoOperation 先，然后再eocOperation
    // 在执行之前，把依赖关系建立好
    [eocOperation addDependency:twoOperation];
    
    [queue addOperation:eocOperation];
    [queue addOperation:twoOperation];
    
    [twoOperation addObserver:self forKeyPath:@"finished" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    NSLog(@"%@", keyPath);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    

}



@end
