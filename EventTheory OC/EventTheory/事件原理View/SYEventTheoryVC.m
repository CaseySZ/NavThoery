//
//  SYEventTheoryVC.m
//  EventTheory
//
//  Created by sy on 2018/7/18.
//  Copyright © 2018年 sy. All rights reserved.
//

/*

 */

#import "SYEventTheoryVC.h"
#import "SYRedView.h"
#import "SYGreenView.h"
#import "SYBlueView.h"

@interface SYEventTheoryVC (){
    
    
    SYRedView *_redView;
    SYGreenView *_greenView;
    SYBlueView *_blueView;
}

@end

@implementation SYEventTheoryVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self theoryDemoTwoView];
    
}


- (void)theoryDemoTwoView{

    _redView   = [[SYRedView alloc] initWithFrame:CGRectMake(70, 100, 200, 300)];
    _greenView = [[SYGreenView alloc] initWithFrame:CGRectMake(80, 110, 100, 100)];
    _blueView  = [[SYBlueView alloc] initWithFrame:CGRectMake(90, 120, 100, 100)];
    
    
    [self.view addSubview:_redView];
    [self.view addSubview:_greenView];
    [_redView addSubview:_blueView];
    
}



/*
 响应原理 找到最适合响应这个事件的对象
 查找 {
    1 触摸点是否发生自己身上 （self.view的区域里）
    2 倒序遍历子控件 （找到最适合的子控件来处理，如果找不到，那么就是自己处理事件）
    3 然后子控件，重复 1，2 步骤
 }
 
 点击绿色区域：
     1 点击区域在self.view 上
     2 倒序遍历self.view 的子控件（_blueView）
     3 判断点击区域是否在_blueView上， 发现不在（继续查找）
     4 判断点击区域是否在_redView上，发现在这个view上
     5 倒序遍历_redView 的子控件（_greenView）
     6 判断点击区域是否在_greenView上
     7 发现在_greenView上，继续查找（找不到比_greenView更合适的view了），那么_greenView就响应事件
 
 在查找的过程中， 如果父控件不接收触摸事件，那么子控件也不能接收事件 （UIImageview ，userInteractionEnabled默认就是NO）
*/


- (void)theoryDemoView{
    //self.view.subviews.lastObject
    _redView   = [[SYRedView alloc] initWithFrame:CGRectMake(70, 100, 200, 300)];
    _greenView = [[SYGreenView alloc] initWithFrame:CGRectMake(80, 138, 100, 100)];
    _blueView  = [[SYBlueView alloc] initWithFrame:CGRectMake(90, 120, 100, 100)];
    
    [self.view addSubview:_greenView];
    [self.view addSubview:_redView];
    [self.view addSubview:_blueView];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    // [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    //[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    // [super touchesEnded:touches withEvent:event];
    
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSLog(@"%s", __func__);
    // [super touchesCancelled:touches withEvent:event];
}



@end
