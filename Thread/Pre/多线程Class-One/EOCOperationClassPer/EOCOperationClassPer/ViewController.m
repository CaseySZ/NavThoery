//
//  ViewController.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ViewController.h"
#import "EocOperation.h"
#import "EOCBlockOperationVC.h"
#import "EOCInvocationOperationVC.h"
#import "EOCOpererationVC.h"
#import "EOCOperationComplexVC.h"
#import "EOCLockVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    
    NSTimer *_eocTimer;
    NSThread *_eocThread;
    NSRunLoop *_eocRunloop;
    NSPort *_port;

}

@end

@implementation ViewController

/*

 避免僵尸线程
 当前线程的runloop处理，在当前的线程runloop里面操作，如果在其他线程操作runloop，导致runloop残留资源问题，那么线程就结束不了
 
 当runloop里面没有资源了，那么这个runloop结束
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
  //  [NSThread detachNewThreadSelector:@selector(timerThread) toTarget:self withObject:nil];
  //  _eocThread = [[NSThread alloc] initWithTarget:self selector:@selector(timerThreadTwo) object:nil];
  //  [_eocThread start];
}

- (void)timerThreadTwo{
     NSLog(@"timerThreadTwo start");
    _port = [[NSPort alloc] init];
    _eocRunloop = [NSRunLoop currentRunLoop];
    
   // [self performSelector:@selector(canleTimer) withObject:nil afterDelay:5];
    
//    while (bool) {
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
//    }
    [[NSRunLoop currentRunLoop] addPort:_port forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop] run];
    
    NSLog(@"timerThreadTwo finish");
}

- (void)canleTimer{
    
    [_eocRunloop removePort:_port forMode:NSRunLoopCommonModes];
    
    //[_eocTimer invalidate];
}

- (void)timerThread{
    

    _eocTimer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"%@", [NSThread currentThread]);
    }];
    [[NSRunLoop currentRunLoop] addTimer:_eocTimer forMode:NSRunLoopCommonModes];
    
    [self performSelector:@selector(canleTimer) withObject:nil afterDelay:5];
    [[NSRunLoop currentRunLoop] run];
    
    NSLog(@"timerThread finish");
    
}




#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"系统：BlockOperation";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"系统：InvocationOperation";
    }else if(indexPath.row == 2){
        cell.textLabel.text = @"自定义Operation对象";
    }else if(indexPath.row == 3){
        cell.textLabel.text = @"依赖、优先级";
    }else if(indexPath.row == 4){
        cell.textLabel.text = @"锁机制";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    [_eocRunloop removePort:_port forMode:NSRunLoopCommonModes];
//    
//    [self performSelector:@selector(canleTimer) onThread:_eocThread withObject:nil waitUntilDone:YES];
//   // [_eocTimer invalidate];
//    
//    return;
    
    UIViewController *viewCtr = nil;
    
    if (indexPath.row == 0) {
        viewCtr = [EOCBlockOperationVC new];
    }else if(indexPath.row == 1){
        viewCtr = [EOCInvocationOperationVC new];
    }else if(indexPath.row == 2){
        viewCtr = [EOCOpererationVC new];
    }else if(indexPath.row == 3){
        viewCtr = [EOCOperationComplexVC new];
    }else if(indexPath.row == 4){
        viewCtr = [EOCLockVC new];
    }
    
    [self.navigationController pushViewController:viewCtr animated:YES];
}


@end
