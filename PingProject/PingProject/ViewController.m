//
//  ViewController.m
//  PingProject
//
//  Created by Casey on 29/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "ViewController.h"
#import "NewPNetPing.h"
#import "CheckGatewayView.h"
#import "CheckNetDetailViewCtr.h"

@interface ViewController ()<NewPNetPingDelegate>{
    
    NewPNetPing *netPing;
}

@end

@implementation ViewController

//// https://www.jianshu.com/p/54e93303f0d7
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
     netPing = [[NewPNetPing alloc] init];
     netPing.delegate = self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
   
    
    NSArray *urlArr = @[@"https//232r.cet.c", @"http://c01nike.gateway.com", @"http://www.baidu.com", @"http://www.bejson.com"];
    
    
    [CheckGatewayView showCheck:urlArr diagnose:^{
        
        [self.navigationController pushViewController:[CheckNetDetailViewCtr new] animated:YES];
        
    }];
    
    
    
}



- (void)appendPingLog:(NSString *)pingLog{
    
    NSLog(@"log:::%@", pingLog);
    
}
- (void)netPingDidEnd {
    
    NSLog(@"netPingDidEnd");
    
}
// 响应时长回调，单位是: ms 毫秒
- (void)appendPingLog:(NSString *)pingLog responseSecond:(long)secon {
    
    NSLog(@"cc:%@, %ld", pingLog, secon);
    
}

@end
