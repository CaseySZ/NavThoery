//
//  TranslucentViewCtr.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/1.
//  Copyright © 2019年 sy. All rights reserved.
//

/*
 
 拟物化 -》 扁平化  不透明 -〉 透明的
 内容区 （self.view） 全屏
 autoAdjust 针对scollerview
 UIRectEdgeNone 内容区在导航栏下面 （失去自动调节）
 
 */

#import "TranslucentViewCtr.h"

@interface TranslucentViewCtr ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation TranslucentViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"透明分析";
    self.view.backgroundColor = [UIColor redColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UITableView *tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    
    [self.view addSubview:tableview];
    
    
//    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 50, 100, 100)];
//    blueView.backgroundColor = UIColor.blueColor;
//    [self.view addSubview:blueView];
    
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
