//
//  CyRefreshAnimationView.m
//  IOS_B01
//
//  Created by Casey on 22/01/2019.
//  Copyright © 2019 Casey. All rights reserved.
//

#import "AliRefreshAnimationView.h"
#import "UIView+CyRefreshFrame.h"
#import "CyRefreshBaseData.h"
#import "AliRefreshShadowView.h"

@interface AliRefreshAnimationView (){
    
    
    UIImageView *_logImageView;
    UIImageView *_waterImageView;
    
    AliRefreshShadowView *_shadowView;
    
    UIView *_contentView;
    
    CGFloat logStartY;
    CGFloat logEndY;
    
}


@property (nonatomic, assign)CGFloat moveRate;

@end


@implementation AliRefreshAnimationView


- (instancetype)initWithFrame:(CGRect)frame{
    
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        _waterImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshWater.png"]];
        _waterImageView.hidden = YES;
        _waterImageView.frame = CGRectMake(0, 0, 10, 10);
        [self addSubview:_waterImageView];
        
        
        _shadowView = [[AliRefreshShadowView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 10 - 6, 40, 6)];
        _shadowView.backgroundColor = UIColor.clearColor;
        _shadowView.clipsToBounds = NO;
        _shadowView.cy_centerX = self.cy_width/2;
        [self addSubview:_shadowView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 10)];
        _contentView.clipsToBounds = YES;
        [self addSubview:_contentView];
        
        
        _logImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refreshLog.png"]];//refreshLog.png
        _logImageView.frame = CGRectMake(self.frame.size.width/2 - 29/2, self.frame.size.height, 29, 24);
        [_contentView addSubview:_logImageView];
        

        
        logStartY = _logImageView.frame.origin.y;
        logEndY =  self.frame.size.height/2;
        self.moveRate = (logStartY - logEndY) / self.frame.size.height;
    }
    
    return self;
}



- (void)layoutSubviews {
    
    [super layoutSubviews];
    
}

- (void)animationScrollViewOffsetY:(CGFloat)offsetY {
    

    [self removeShakeAnimation];
    offsetY = 0 - offsetY;
    
    if (offsetY >= self.cy_height) {
        offsetY = self.cy_height;
    }
    
    CGFloat posY = self.moveRate * offsetY;
    _logImageView.cy_y = self.frame.size.height - posY;
    _shadowView.visibleValueY = posY;
    _shadowView.hidden = NO;
}


- (void)animationFlush {
    
    
    [_shadowView animationCirle:0.3];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self->_logImageView.cy_y = self.frame.size.height/2 - self->_logImageView.cy_height/2 - 6;
        
      
        
    } completion:^(BOOL finished) {
        
        [self shakeAnimation];
        
    }];
    
    
}


- (void)shakeAnimation {
    
    
    //初始化一个动画
    CABasicAnimation *baseAnimation = [CABasicAnimation animation];
    baseAnimation.keyPath = @"transform.rotation.z";
    baseAnimation.duration = 0.25;
    baseAnimation.fromValue = [NSNumber numberWithFloat:M_PI/16];
    baseAnimation.toValue = [NSNumber numberWithFloat:-M_PI/16];
    baseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    baseAnimation.autoreverses = YES;
    baseAnimation.repeatCount = 1000;
    baseAnimation.fillMode = kCAFillModeForwards;
    [_logImageView.layer addAnimation:baseAnimation forKey:@"shakeAnimation"];
    

    
}

- (void)removeShakeAnimation {
    
    [_logImageView.layer removeAnimationForKey:@"shakeAnimation"];
}


- (void)animationEndLoading:(void (^) (void))completion {
    
    
    [self removeShakeAnimation];
    
    [_shadowView animationOval:0.25];
    
    _waterImageView.cy_centerX = self.cy_width/2;
    _waterImageView.cy_y = 10;
    _waterImageView.cy_width = 10;
    _waterImageView.cy_height = 10;
    _waterImageView.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self->_logImageView.cy_y = self.frame.size.height;
        self->_waterImageView.frame = CGRectMake(self.cy_width/2-20/2, 5, 20, 20);
        
    } completion:^(BOOL finished) {
        
        if (completion) {
            completion();
        }
        self->_waterImageView.hidden = YES;
    }];
}



@end
