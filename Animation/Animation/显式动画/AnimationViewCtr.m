//
//  AnimationViewCtr.m
//  Animation
//
//  Created by Casey on 08/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "AnimationViewCtr.h"
#import <QuartzCore/QuartzCore.h>

@interface AnimationViewCtr ()<CAAnimationDelegate>{
    
    
    CALayer *_colorLayer;
    
}

@end

@implementation AnimationViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    
    UIBarButtonItem *basicBt = [[UIBarButtonItem alloc] initWithTitle:@"Basic" style:UIBarButtonItemStylePlain target:self action:@selector(changeColor)];
    UIBarButtonItem *keyframeBt = [[UIBarButtonItem alloc] initWithTitle:@"keyframe" style:UIBarButtonItemStylePlain target:self action:@selector(keyframe)];
    
    UIBarButtonItem *keyPathframeBt = [[UIBarButtonItem alloc] initWithTitle:@"keyPath" style:UIBarButtonItemStylePlain target:self action:@selector(keyFrameByPath)];
    UIBarButtonItem *virtualPropertyBt = [[UIBarButtonItem alloc] initWithTitle:@"virtualPro" style:UIBarButtonItemStylePlain target:self action:@selector(virtualProperty)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:basicBt, keyframeBt,keyPathframeBt,virtualPropertyBt, nil];
    
    
    _colorLayer  = [CALayer layer];
    _colorLayer.frame = CGRectMake(100, 100, 100, 100);
    _colorLayer.backgroundColor = UIColor.blueColor.CGColor;
    [self.view.layer addSublayer:_colorLayer];
    
    
    
}


- (void)changeColor {
    
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
  
    // 一个起始和结束的值
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)color.CGColor;
   // animation.fromValue = (__bridge id)UIColor.redColor.CGColor;
    animation.delegate = self;
    animation.duration = 1.0;
    [_colorLayer addAnimation:animation forKey:@"basicA"];
    
}

- (void)keyframe {
    
    /*
     CAKeyframeAnimation(关键帧)不限制于设置一个起始和结束的值，而是可以根据一连串随意的值来做动画.
     提供关键的帧，每帧之间剩下的绘制（可以通过关键帧推算出）系统底层计算完成， 并在每帧之间进行插入。
     */
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.duration = 2.0;
    animation.values = @[
                         (__bridge id)[UIColor blueColor].CGColor,
                         (__bridge id)[UIColor redColor].CGColor,
                         (__bridge id)[UIColor greenColor].CGColor,
                         (__bridge id)[UIColor blueColor].CGColor ];

    [_colorLayer addAnimation:animation forKey:nil];
    
    /*
     现象：动画会在开始的时候突然跳转到第一帧的值，然后在动画结束的时候突然恢复到原始的值。所以为了动画的平滑特性，我们需要开始和结束的关键帧来匹配当前属性的值。
     动画通过颜色不断循环，但效果看起来有些奇怪，原因在于动画以一个恒定的步调在运行，当在每个动画之间过渡的时候并没有减速，这就产生了一个略微奇怪的效果，为了让动画看起来更自然，我们需要调整一下缓冲，后续单独讲缓冲。
     */
}


//CAKeyframeAnimation可以使用CGPathpath来指定动画路径

- (void)keyFrameByPath {
    
    // 贝塞尔曲线
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(50, 200)];
    [bezierPath addCurveToPoint:CGPointMake(350, 200) controlPoint1:CGPointMake(125, 50) controlPoint2:CGPointMake(275, 350)];
    
    //路径
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.view.layer addSublayer:pathLayer];
    
    //飞机
    CALayer *feijiLayer = [CALayer layer];
    feijiLayer.frame = CGRectMake(0, 0, 64, 64);
    feijiLayer.position = CGPointMake(50, 200);
    feijiLayer.contents = (__bridge id)[UIImage imageNamed: @"feiji.jpg"].CGImage;
    [self.view.layer addSublayer:feijiLayer];
    
    //添加动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
   // animation.rotationMode = kCAAnimationRotateAuto;
    [feijiLayer addAnimation:animation forKey:nil];
    
    /*
     飞机的动画有点不太真实，飞行的时候永远执行右边，而不是执行曲线的切线方向， 通过rotationMode属性来修改，图层将会根据曲线的切线自动旋转
     */
    
}



- (void)virtualProperty{
    
    CALayer *feijiLayer = [CALayer layer];
    feijiLayer.frame = CGRectMake(0, 0, 128, 128);
    feijiLayer.position = CGPointMake(100, 280);
    feijiLayer.contents = (__bridge id)[UIImage imageNamed: @"feiji.jpg"].CGImage;
    [self.view.layer addSublayer:feijiLayer];
    
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = 2.0;
    
    animation.keyPath = @"transform.rotation";
    animation.byValue = @(M_PI * 2);
    
  //  animation.keyPath = @"transform";
  //  animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI, 0, 0, 1)];
    
    [feijiLayer addAnimation:animation forKey:nil];

    /*
     transform.rotation属性, 它其实并不存在, 且CATransform3D并不是一个对象，它实际上是一个结构体，也没有符合KVC相关属性，
     所以transform.rotation实际上是一个CALayer用于处理动画变换的虚拟属性, 但做动画时，Core Animation自动地来计算的值来更新transform属性.
     这样处理的好处，不需要去不用创建CATransform3D， 使用一个简单的数值来指定， 而且可以用相对值而不是绝对值旋转（设置byValue而不是toValue）。
     */
   
}

// 
- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {

    
 //   [CATransaction begin];
  //  [CATransaction setDisableActions:YES];
   // _colorLayer.backgroundColor = (__bridge CGColorRef  )anim.toValue;
   // [CATransaction commit];

}

@end
