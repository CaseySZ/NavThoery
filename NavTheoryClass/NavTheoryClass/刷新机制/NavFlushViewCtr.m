//
//  NavFlushViewCtr.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/1.
//  Copyright © 2019年 sy. All rights reserved.
//

#import "NavFlushViewCtr.h"
#import "TestOneViewCtr.h"

@interface NavFlushViewCtr ()

@end

@implementation NavFlushViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"刷新机制";
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.navigationController pushViewController:[TestOneViewCtr new] animated:YES];
    
}



@end
