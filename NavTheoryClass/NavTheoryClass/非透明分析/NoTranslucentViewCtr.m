//
//  NoTranslucentViewCtr.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/1.
//  Copyright © 2019年 sy. All rights reserved.
//

#import "NoTranslucentViewCtr.h"


/*
 非透明： 内容区默认在导航条下
 
 非透明的内容全屏： extendedLayoutIncludesOpaqueBars = YES
 
 总结：内容区在导航下 不自动调节功能
      内容区是全屏的，就自动调节
 
 
 */

@interface NoTranslucentViewCtr ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation NoTranslucentViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"非透明分析";
    self.view.backgroundColor = [UIColor redColor];
    self.navigationController.navigationBar.translucent = NO;
    self.extendedLayoutIncludesOpaqueBars = YES;
    

    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAutomatic;
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    
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
