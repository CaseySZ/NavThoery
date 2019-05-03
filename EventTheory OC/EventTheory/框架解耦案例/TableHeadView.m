//
//  TableHeadView.m
//  EventTheory
//
//  Created by sy on 2018/7/23.
//  Copyright © 2018年 sy. All rights reserved.
//

#import "TableHeadView.h"
#import "SYEventTheoryVC.h"

@implementation TableHeadView

+ (instancetype)instance{
    
    TableHeadView *view =  [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    return view;
}


// 千丝万缕 MVVM

- (IBAction)pressButton:(UIButton*)sender{
    
    
    NSLog(@"pressButton");
    // 跳转到另外的控制器
    [self.syNav pushViewController:[SYEventTheoryVC new] animated:YES];
    
}



@end
