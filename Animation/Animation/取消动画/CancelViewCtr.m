//
//  CancelViewCtr.m
//  Animation
//
//  Created by Casey on 09/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "CancelViewCtr.h"

@interface CancelViewCtr ()<CAAnimationDelegate>{
    
    
    CALayer *_animationLayer;
    
    UIView *_contentView;
}

@end

@implementation CancelViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *startBt = [[UIBarButtonItem alloc] initWithTitle:@"start" style:UIBarButtonItemStylePlain target:self action:@selector(startAnimation)];
    
    UIBarButtonItem *cancelBt = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAnimation)];
    
    UIBarButtonItem *startUIViewBt = [[UIBarButtonItem alloc] initWithTitle:@"UIViewAni" style:UIBarButtonItemStylePlain target:self action:@selector(startUIViewAnmation)];
    
    UIBarButtonItem *stopBt = [[UIBarButtonItem alloc] initWithTitle:@"stopUIView" style:UIBarButtonItemStylePlain target:self action:@selector(stopAnimation)];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:startBt, cancelBt, startUIViewBt, stopBt, nil];
    
}


- (void)startAnimation{
    
    [_animationLayer removeFromSuperlayer];
    
    _animationLayer = [CALayer layer];
    _animationLayer.frame = CGRectMake(0, 0, 128, 128);
    _animationLayer.position = CGPointMake(150, 150);
    _animationLayer.contents = (__bridge id)[UIImage imageNamed: @"feiji.jpg"].CGImage;
    [self.view.layer addSublayer:_animationLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation";
    animation.duration = 5.0;
    animation.byValue = @(M_PI * 2);
    animation.delegate = self;
    [_animationLayer addAnimation:animation forKey:@"rotateAnimation"];
}

- (void)cancelAnimation {
    
    [_animationLayer removeAnimationForKey:@"rotateAnimation"];
    
}


- (void)startUIViewAnmation {
    
    [_contentView removeFromSuperview];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(10, 200, 150, 150)];
    _contentView.backgroundColor = UIColor.redColor;

    [self.view addSubview:_contentView];
    
    /*
     提交了，就不能取消
     */
    [UIView animateWithDuration:3 animations:^{
        
        self->_contentView.frame = CGRectMake(self.view.frame.size.width - 150, 200, 150, 150);
        
    } completion:^(BOOL finished) {
        
        NSLog(@"UIView Animation stopped1 (finished: %@)", finished? @"YES": @"NO");
        
    }];
  
}


- (void)stopAnimation {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
//    [_contentView removeFromSuperview];
//    [_animationLayer removeFromSuperlayer];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    NSLog(@"The animation stopped (finished: %@)", flag? @"YES": @"NO");
}

@end
