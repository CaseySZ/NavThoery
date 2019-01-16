//
//  NextViewController.m
//  NSProxy使用
//
//  Created by 八点钟学院 on 2017/7/28.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "NextViewController.h"
#import "EOCProxy.h"
#import "EOCObject.h"

@interface NextViewController () {
    
    CADisplayLink *link;
    
}

@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(100.f, 100.f, 100.f, 100.f);
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    EOCProxy *proxy = [EOCProxy proxyWithTarget:self];
    NSLog(@"proxy %@", proxy);
    
    link = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(testLink)];
//    [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)btnAction {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)testLink {
    
    NSLog(@"link!!");
    
}

- (void)dealloc {
    
    [link invalidate];
    NSLog(@"delloc");
    
}

@end
