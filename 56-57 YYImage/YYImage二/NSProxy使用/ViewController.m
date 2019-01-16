//
//  ViewController.m
//  NSProxy使用
//
//  Created by 八点钟学院 on 2017/7/28.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "ViewController.h"
#import "EOCObject.h"
#import "NextViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EOCObject *testObj = [[EOCObject alloc] init];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
   
    
}

- (void)btnAction {
    
    NextViewController *nextViewCtrl = [[NextViewController alloc] init];
    [self presentViewController:nextViewCtrl animated:YES completion:nil];
    
}

@end
