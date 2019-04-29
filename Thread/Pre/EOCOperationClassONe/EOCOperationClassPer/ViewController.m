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
#import "ThreadDeadViewCtr.h"
#import "ThreadUseViewCtr.h"


@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>{
    

}

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 6;
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
        cell.textLabel.text = @"NSThread";
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"系统：BlockOperation";
    }else if(indexPath.row == 2){
        cell.textLabel.text = @"系统：InvocationOperation";
    }else if(indexPath.row == 3){
        cell.textLabel.text = @"自定义Operation对象";
    }else if(indexPath.row == 4){
        cell.textLabel.text = @"依赖";
    }else if(indexPath.row == 5){
        cell.textLabel.text = @"僵死线程";
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UIViewController *viewCtr = nil;
    if (indexPath.row == 0){
        viewCtr = [ThreadUseViewCtr new];
    }
    else if (indexPath.row == 1) {
        viewCtr = [EOCBlockOperationVC new];
    }else if(indexPath.row == 2){
        viewCtr = [EOCInvocationOperationVC new];
    }else if(indexPath.row == 3){
        viewCtr = [EOCOpererationVC new];
    }else if(indexPath.row == 4){
        viewCtr = [EOCOperationComplexVC new];
    }else if(indexPath.row == 5){
        viewCtr = [ThreadDeadViewCtr new];
    }
    
    [self.navigationController pushViewController:viewCtr animated:YES];
}


@end
