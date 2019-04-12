//
//  CyRefreshShadowView.m
//  IOS_B01
//
//  Created by Casey on 22/01/2019.
//  Copyright © 2019 Casey. All rights reserved.
//

#import "AliRefreshShadowView.h"
#import <CoreGraphics/CoreGraphics.h>



@interface AliRefreshShadowView ()<CAAnimationDelegate>{
    
    BOOL _circelAnimation;
    UIBezierPath *_path;
    
    UIColor *_shadowColor;
    BOOL _animationIng;
}


@property (nonatomic, assign)CGFloat rateWidth; 
@property (nonatomic, strong)CAShapeLayer *shapeLayer;

@end


@implementation AliRefreshShadowView



- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _shadowColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        
        _shapeLayer = [[CAShapeLayer alloc] init];
        _shapeLayer.frame = self.bounds;
        _shapeLayer.fillColor  = _shadowColor.CGColor;
        
    }
    
    return self;
}


- (void)setVisibleValueY:(CGFloat)visibleValueY{
    
    _visibleValueY = visibleValueY;
    _circelAnimation = NO;
    [_shapeLayer removeFromSuperlayer];
    [self setNeedsDisplay];

    
}

- (void)drawRect:(CGRect)rect {

    [super drawRect:rect];
    
    if (!_circelAnimation) {
        
        CGFloat height  = self.frame.size.height;
        CGFloat width  = self.frame.size.width;
        
        CGFloat shadowWidth = _visibleValueY*self.rateWidth;
        
        _path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width/2 - shadowWidth/2, 0, shadowWidth, height)];
        [_shadowColor set];
        [_path fill];
        [_path stroke];
        
        _shapeLayer.path = _path.CGPath;
        
    }
    

    
}



- (void)animationCirle:(CGFloat)animationTime{
    
 
    _circelAnimation = YES;
    if (_animationIng) {
        return;
    }
   
    
    if (_shapeLayer.superlayer == nil) {
        [self.layer addSublayer:_shapeLayer];
    }
    
    _animationIng = YES;
    
    CGFloat height  = self.frame.size.height;
    CGFloat width  = self.frame.size.width;
    CGFloat shadowWidth = 10;
    _shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width/2 - shadowWidth/2, 0, shadowWidth, height)].CGPath;
    
    CABasicAnimation *baseAnimation = [CABasicAnimation animation];
    baseAnimation.keyPath = @"path";
    baseAnimation.duration = animationTime;
    baseAnimation.fromValue = (__bridge id)_shapeLayer.path;
    baseAnimation.toValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:CGRectMake(width/2 - shadowWidth/2, 0, 10, height)].CGPath;
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    baseAnimation.autoreverses = NO;
    baseAnimation.fillMode = kCAFillModeForwards;
    baseAnimation.delegate = self;
    [_shapeLayer addAnimation:baseAnimation forKey:@"baseAnimationPath"];
    
    
}

- (void)animationOval:(CGFloat)animationTime{
    
    
    _circelAnimation = YES;
    [_shapeLayer removeAnimationForKey:@"baseAnimationPath"];
    
    
    if (_shapeLayer.superlayer == nil) {
        [self.layer addSublayer:_shapeLayer];
    }
    
    _animationIng = YES;
    
    CGFloat height  = self.frame.size.height;
    CGFloat width  = self.frame.size.width;
    CGFloat shadowWidth = 37;
    _shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(width/2 - shadowWidth/2, 0, shadowWidth, height)].CGPath;
    
    CABasicAnimation *baseAnimation = [CABasicAnimation animation];
    baseAnimation.keyPath = @"path";
    baseAnimation.duration = animationTime;
    baseAnimation.fromValue = (__bridge id)_shapeLayer.path;
    baseAnimation.toValue = (__bridge id)[UIBezierPath bezierPathWithOvalInRect:CGRectMake(width/2 - shadowWidth/2, 0, shadowWidth, height)].CGPath;
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    baseAnimation.autoreverses = NO;
    baseAnimation.fillMode = kCAFillModeForwards;
    baseAnimation.delegate = self;
    [baseAnimation setValue:@"1" forKey:@"animationOval"];
    [_shapeLayer addAnimation:baseAnimation forKey:@"baseAnimationPath"];
    
    
}

- (void)animationDidStop:(CABasicAnimation *)anim finished:(BOOL)flag {
    
    [_shapeLayer removeAnimationForKey:@"baseAnimationPath"];
    if ([anim valueForKey:@"animationOval"]) {
        [_shapeLayer removeFromSuperlayer];
    }
    _animationIng = NO;
}

 // 最大宽度是37， _visibleValueY最大值是 25
- (CGFloat)rateWidth {
    
    return 37/25.0;
}



@end
