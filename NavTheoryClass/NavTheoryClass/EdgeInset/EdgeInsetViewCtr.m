//
//  EdgeInsetViewCtr.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/5.
//  Copyright © 2019年 sy. All rights reserved.
//

#import "EdgeInsetViewCtr.h"

@interface EdgeInsetViewCtr (){
    
    UIView *redView;
    
    UIScrollView *_scrollview;
}

@end

@implementation EdgeInsetViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self edgeInsetStudy];
    
}
/*
 UIEdgeInsets
 
*/
- (void)edgeInsetStudy {
    

    
    _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 200, 200)];
    _scrollview.backgroundColor = [UIColor redColor];
    _scrollview.contentInset =  UIEdgeInsetsMake(0, 0, 50, 0);;
    [self.view addSubview:_scrollview];
    
    
//    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
//    blueView.backgroundColor = UIColor.blueColor;
//    [_scrollview addSubview:blueView];
    
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, 50, 50)];
    yellowView.backgroundColor = UIColor.yellowColor;
    [_scrollview addSubview:yellowView];
    
    
    _scrollview.contentSize = CGSizeMake(201, 201);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
}

@end
