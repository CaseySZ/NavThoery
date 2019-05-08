//
//  AnimationGroupViewCtr.m
//  Animation
//
//  Created by Casey on 08/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "AnimationGroupViewCtr.h"

/*
 CABasicAnimation和CAKeyframeAnimation仅仅作用于单独的属性,
 而CAAnimationGroup可以把这些动画组合在一起。
 CAAnimationGroup是另一个继承于CAAnimation的子类，它添加了一个animations数组的属性，用来组合别的动画
 
 */

@interface AnimationGroupViewCtr ()

@end

@implementation AnimationGroupViewCtr

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
   
    UIBarButtonItem *groupBt = [[UIBarButtonItem alloc] initWithTitle:@"group" style:UIBarButtonItemStylePlain target:self action:@selector(groupAnimation)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:groupBt, nil];
    
}


- (void)groupAnimation{
    
    
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(50, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(125, 0) controlPoint2:CGPointMake(275, 300)];
    
    // 路径layer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    
    // 颜色layer
    CALayer *colorLayer = [CALayer layer];
    colorLayer.frame = CGRectMake(0, 0, 64, 64);
    colorLayer.position = CGPointMake(50, 150);
    colorLayer.backgroundColor = [UIColor greenColor].CGColor;
    [self.view.layer addSublayer:colorLayer];
    
    
    // position动画
    CAKeyframeAnimation *animation1 = [CAKeyframeAnimation animation];
    animation1.keyPath = @"position";
    animation1.path = bezierPath.CGPath;
    animation1.rotationMode = kCAAnimationRotateAuto;
    
    //color动画
    CABasicAnimation *animation2 = [CABasicAnimation animation];
    animation2.keyPath = @"backgroundColor";
    animation2.toValue = (__bridge id)[UIColor redColor].CGColor;
    
    //动画组
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[animation1, animation2];
    groupAnimation.duration = 4.0;
   
    // 添加动画
    [colorLayer addAnimation:groupAnimation forKey:nil];
    
}

@end
