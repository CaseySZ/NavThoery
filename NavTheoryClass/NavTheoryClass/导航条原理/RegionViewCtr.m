//
//  RegionViewCtr.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/1.
//  Copyright © 2019年 sy. All rights reserved.
//

/*
 
 UINavigationController 是一个  UIViewController
 他管理着 多个控制器（子控制器）  viewControllers 容器
 
 1 导航条区域 narbar   64/88
 2 内容区  self.view   导航条下，底部区上 （self.view）
 3 底部区  toolbar    44/83
 
 
 */

#import "RegionViewCtr.h"

@interface RegionViewCtr (){
    
    UIView *_testView;
}

@end

@implementation RegionViewCtr


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"区域分析";
    self.view.backgroundColor = UIColor.redColor;
}


- (void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = YES;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}






@end
