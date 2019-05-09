//
//  HandleAnimationViewCtr.m
//  Animation
//
//  Created by Casey on 09/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "HandleAnimationViewCtr.h"

@interface HandleAnimationViewCtr (){
    
    
    CALayer *_contentLayer;
}

@end

@implementation HandleAnimationViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.view.layer.sublayerTransform = perspective;
    
    
    _contentLayer = [CALayer layer];
    _contentLayer.frame = CGRectMake(0, 0, 130, 260);
    _contentLayer.position = CGPointMake(150, 260);
    _contentLayer.anchorPoint = CGPointMake(0, 0.5);
    _contentLayer.contents = (__bridge id)[UIImage imageNamed:@"door.png"].CGImage;
    [self.view.layer addSublayer:_contentLayer];
   
    
    _contentLayer.speed = 0.0;
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 1.0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [_contentLayer addAnimation:animation forKey:nil];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    
}


- (void)pan:(UIPanGestureRecognizer *)pan
{
    
    CGFloat x = [pan translationInView:self.view].x;
    x /= 200.0f;
    CFTimeInterval timeOffset = _contentLayer.timeOffset;
    
    
    timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
    
    _contentLayer.timeOffset = timeOffset;
   
    [pan setTranslation:CGPointZero inView:self.view];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        NSLog(@"end");
       // _contentLayer.speed = 1.0;
    }
    
}



@end
