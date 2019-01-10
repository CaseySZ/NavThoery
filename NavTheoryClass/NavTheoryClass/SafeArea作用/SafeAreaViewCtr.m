//
//  SafeAreaViewCtr.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/1.
//  Copyright © 2019年 sy. All rights reserved.
//

#import "SafeAreaViewCtr.h"

/*
 
 
*/

@interface SafeAreaViewCtr ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SafeAreaViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"SafeArea分析";
    self.view.backgroundColor = [UIColor redColor];
    
    UIEdgeInsets inst = UIEdgeInsetsMake(50, 0, 0, 0);
    
   // self.additionalSafeAreaInsets = inst;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    
    if (@available(iOS 11.0, *)) {

        tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    };

    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 100, 100)];
    blueView.backgroundColor = UIColor.blueColor;
    [self.view addSubview:blueView];
    
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.translucent = YES;
}


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
    cell.textLabel.text = [ @(indexPath.row) description];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

@end
