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
        cell.textLabel.text = @"锁机制";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"GCD";
    }else if(indexPath.row == 2){
        cell.textLabel.text = @"GCD_Two";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIViewController *viewCtr = nil;
    
    if(indexPath.row == 0){
        viewCtr = [EOCLockVC new];
    }else if(indexPath.row == 1){
        viewCtr = [GCDViewCtr new];
    }else if(indexPath.row == 2){
        viewCtr = [GCDTwoViewVC new];
    }
    
    [self.navigationController pushViewController:viewCtr animated:YES];
}


@end
