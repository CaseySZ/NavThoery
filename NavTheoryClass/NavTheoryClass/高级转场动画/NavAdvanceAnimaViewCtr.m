//
//  NavAdvanceAnimaViewCtr.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/5.
//  Copyright © 2019年 sy. All rights reserved.
//

#import "NavAdvanceAnimaViewCtr.h"
#import "SecondViewCtr.h"
#import "AnimationNavigationCtr.h"
@interface NavAdvanceAnimaViewCtr ()

@end

@implementation NavAdvanceAnimaViewCtr

+ (AnimationNavigationCtr*)newNavViewCtr{
    
 
    return [[AnimationNavigationCtr alloc] initWithRootViewController:[NavAdvanceAnimaViewCtr new]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"高级动画";
    self.view.backgroundColor = UIColor.redColor;

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.navigationController pushViewController:[SecondViewCtr new] animated:YES];
    
}

- (void)backAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
