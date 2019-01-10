//
//  ViewController.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/1.
//  Copyright © 2019年 sy. All rights reserved.
//

#import "ViewController.h"
#import "RegionViewCtr.h"
#import "TranslucentViewCtr.h"
#import "NoTranslucentViewCtr.h"
#import "SafeAreaViewCtr.h"
#import "NavFlushViewCtr.h"
#import "EdgeInsetViewCtr.h"
#import "NavAnimaThoeryViewCtr.h"
#import "NavAdvanceAnimaViewCtr.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"导航条";
}


- (void)viewWillLayoutSubviews{
    
    [super viewWillLayoutSubviews];
    
}
#pragma mark - tableView delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
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
        cell.textLabel.text = @"导航条原理分析";
    }else if(indexPath.row == 1){
        cell.textLabel.text = @"导航条透明分析";
    }else if(indexPath.row == 2){
        cell.textLabel.text = @"导航条非透明分析";
    }
    else if(indexPath.row == 3){
        cell.textLabel.text = @"UIEdgeInsets";
        
    }else if(indexPath.row == 4){
        cell.textLabel.text = @"SafeArea的作用";
        
    }else if(indexPath.row == 5){
        cell.textLabel.text = @"导航条的刷新机制";
    }else if(indexPath.row == 6){
        cell.textLabel.text = @"导航条动画原理";
    }else if(indexPath.row == 7){
        cell.textLabel.text = @"导航条高级动画";
    }else{
        cell.textLabel.text = @"";
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        [self.navigationController pushViewController:[RegionViewCtr new] animated:YES];
        
    }
    if (indexPath.row == 1) {
        [self.navigationController pushViewController:[TranslucentViewCtr new] animated:YES];
    }
    if (indexPath.row == 2) {
        [self.navigationController pushViewController:[NoTranslucentViewCtr new] animated:YES];
    }
    if (indexPath.row == 3) {
        [self.navigationController pushViewController:[EdgeInsetViewCtr new] animated:YES];
        
    }
    if (indexPath.row == 4) {
        [self.navigationController pushViewController:[SafeAreaViewCtr new] animated:YES];
       
    }
    if (indexPath.row == 5) {
        [self.navigationController pushViewController:[NavFlushViewCtr new] animated:YES];
    }
    if (indexPath.row == 6) {
        [self.navigationController pushViewController:[NavAnimaThoeryViewCtr new] animated:YES];
        
    }
    if (indexPath.row == 7) {
        
        [self presentViewController:[NavAdvanceAnimaViewCtr newNavViewCtr] animated:YES completion:nil];
    }
    
}
@end
