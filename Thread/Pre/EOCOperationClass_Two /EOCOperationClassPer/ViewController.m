//
//  ViewController.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ViewController.h"
#import "EOCLockVC.h"
#import "GCDViewCtr.h"
#import "GCDTwoViewVC.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_queue_t queue = dispatch_queue_create("serQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        for (int i = 0; i < 30; i++) {
//            sleep(1);
//            NSLog(@"%d", i);
//        }
//        NSLog(@"finish");
//    });
}


- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if(indexPath.row == 0){
        cell.textLabel.text = @"GCD";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"GCD_Two";
    }else if(indexPath.row == 2){
        cell.textLabel.text = @"锁机制";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *viewCtr = nil;
    
   if(indexPath.row == 0){
        viewCtr = [GCDViewCtr new];
    }else if(indexPath.row == 1){
        viewCtr = [GCDTwoViewVC new];
    }else if(indexPath.row == 2){
        viewCtr = [EOCLockVC new];
    }
    
    [self.navigationController pushViewController:viewCtr animated:YES];
}


// 同步
- (void)netLoadSync
{
    NSString *urlstr = [NSString stringWithFormat:@"%@?versions_id=1&system_type=1", URLPath];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        
        NSDictionary *infoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"ing-->%@", infoDict);
        
    }];
    [task resume];
    
}

@end
