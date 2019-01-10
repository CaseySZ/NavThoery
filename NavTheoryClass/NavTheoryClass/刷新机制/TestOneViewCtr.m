
//
//  TestOneViewCtr.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/1.
//  Copyright © 2019年 sy. All rights reserved.
//

#import "TestOneViewCtr.h"


/*
 
*/

@interface TestOneViewCtr ()

@end

@implementation TestOneViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Test2";
    self.view.backgroundColor = UIColor.whiteColor;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 0, 80, 40)];
    view.backgroundColor = UIColor.yellowColor;
    [self.navigationController.navigationBar addSubview:view];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UINavigationBar;
    UINavigationItem;
    self.navigationController.navigationBar.items;
    self.navigationController.viewControllers;
}

@end
