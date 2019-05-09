//
//  TimingViewCtr.m
//  Animation
//
//  Created by Casey on 09/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "TimingViewCtr.h"

@interface TimingViewCtr ()<CAAnimationDelegate>{
    
    CALayer *feijiLayer;
}

@end

@implementation TimingViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // CAMediaTiming
    
    
    feijiLayer = [CALayer layer];
    feijiLayer.frame = CGRectMake(0, 0, 64, 64);
    feijiLayer.position = CGPointMake(150, 200);
    feijiLayer.contents = (__bridge id)[UIImage imageNamed: @"feiji.jpg"].CGImage;
    
    
    [self.view.layer addSublayer:feijiLayer];
    
    
    UIBarButtonItem *startBt = [[UIBarButtonItem alloc] initWithTitle:@"start" style:UIBarButtonItemStylePlain target:self action:@selector(start)];
    
    UIBarButtonItem *stopBt = [[UIBarButtonItem alloc] initWithTitle:@"pause" style:UIBarButtonItemStylePlain target:self action:@selector(stopAnimation)];
    UIBarButtonItem *playBt = [[UIBarButtonItem alloc] initWithTitle:@"play" style:UIBarButtonItemStylePlain target:self action:@selector(playAnimation)];
    
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:startBt, stopBt,playBt, nil];
    
}


- (void)start{
    
    CFTimeInterval duration = 10;
    float repeatCount = 0;
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.delegate = self;
    animation.duration = duration;
   // animation.repeatCount = repeatCount;
    
    
 
    animation.keyPath = @"transform.rotation";
    animation.byValue = @(M_PI*2);

   // animation.keyPath = @"position";
   // animation.toValue = @(CGPointMake(200, 200));
    
    //CFTimeInterval time = CACurrentMediaTime();
   // animation.beginTime = time + 3;
    
    
    //animation.timeOffset = 2;
    //animation.speed = 2;
    
   // animation.removedOnCompletion = NO;
  //  animation.fillMode = kCAFillModeForwards;
    
    
    [feijiLayer addAnimation:animation forKey:@"rotateAnimation"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSLog(@"animationDidStop");
}


/*
 另外的暂停方式，自己对呈现层数据拷贝，移除动画，但重新开始的动画的时候，需要得再重新生成动画，计算时间
 */

/*
 可以理解为每个动画和图层在时间上都有它自己的层级概念
 */
- (void)stopAnimation {
    
    feijiLayer.speed = 0;
    //设置动画的时间偏移量，指定时间偏移量的目的是让动画定格在该时间点的位置
    feijiLayer.timeOffset =  CACurrentMediaTime();//取出当前时间,转成动画暂停的时间

}

- (void)playAnimation {
    
    CFTimeInterval pauseTime = feijiLayer.timeOffset;
    feijiLayer.speed = 1;
    feijiLayer.timeOffset = 0;
    //用现在的时间减去时间差,就是之前暂停的时间,从之前暂停的时间开始动画
    feijiLayer.beginTime = CACurrentMediaTime() - pauseTime;
    
}

@end
