//
//  NavAnimation.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/5.
//  Copyright © 2019年 sy. All rights reserved.
//

#import "NavAnimation.h"

@implementation NavAnimation{
    
    id <UIViewControllerContextTransitioning> _transitionContext;
    UIViewController *_toViewCtr;
    UIViewController *_fromViewCtr;
}


// 时间
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    
    
    return 1.0;
    
}


// 过程
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
 
    
    _transitionContext = transitionContext;
    
    UIViewController *toViewCtr = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewCtr = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *transferView =  transitionContext.containerView;

    _toViewCtr = toViewCtr;
    _fromViewCtr = fromViewCtr;
    

  //  [self animateTransition:transitionContext fromVC:fromViewCtr toVC:toViewCtr fromView:fromViewCtr.view toView:toViewCtr.view];
    
    [self animationOne];
    
    
}


- (void)animationOne{
    
    
    
    UIView *transferView =  _transitionContext.containerView;
    [transferView insertSubview:_toViewCtr.view belowSubview:_fromViewCtr.view];
    
    [UIView animateWithDuration:[self transitionDuration:_transitionContext] animations:^{
        
        UIView *fromView = _fromViewCtr.view;
        fromView.frame =  CGRectMake(fromView.frame.size.width, fromView.frame.origin.y, fromView.frame.size.width, fromView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        
        [_transitionContext completeTransition:YES];
        
    }];
}

// context结束
- (void)animationEnded:(BOOL) transitionCompleted{
    
}

// 动画结束
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [_transitionContext completeTransition:![_transitionContext transitionWasCancelled]];
}



- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext fromVC:(UIViewController *)fromVC toVC:(UIViewController *)toVC fromView:(UIView *)fromView toView:(UIView *)toView
{
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    
    //Calculate the direction
    int dir =  -1;
    
    //Create the differents 3D animations
    CATransform3D viewFromTransform;
    CATransform3D viewToTransform;
    
    //We create a content view for do the translate animation
    UIView *generalContentView = [transitionContext containerView];
    
    viewFromTransform = CATransform3DMakeRotation(dir*M_PI_2, 0.0, 1.0, 0.0);
    viewToTransform = CATransform3DMakeRotation(-dir*M_PI_2, 0.0, 1.0, 0.0);
    [toView.layer setAnchorPoint:CGPointMake(dir==1?0:1, 0.5)];
    [fromView.layer setAnchorPoint:CGPointMake(dir==1?1:0, 0.5)];
    
    [generalContentView setTransform:CGAffineTransformMakeTranslation(dir*(generalContentView.frame.size.width)/2.0, 0)];
    
    viewFromTransform.m34 = -1.0 / 200.0;
    viewToTransform.m34 = -1.0 / 200.0;
    
    toView.layer.transform = viewToTransform;
    
    //Create the shadow
    UIView *fromShadow = [self addOpacityToView:fromView withColor:[UIColor blackColor]];
    UIView *toShadow = [self addOpacityToView:toView withColor:[UIColor blackColor]];
    [fromShadow setAlpha:0.0];
    [toShadow setAlpha:1.0];
    
    //Add the to- view
    [generalContentView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        [generalContentView setTransform:CGAffineTransformMakeTranslation(-dir*generalContentView.frame.size.width/2.0, 0)];
        
        fromView.layer.transform = viewFromTransform;
        toView.layer.transform = CATransform3DIdentity;
        
        [fromShadow setAlpha:1.0];
        [toShadow setAlpha:0.0];
        
    } completion:^(BOOL finished) {
        
        //Set the final position of every elements transformed
        [generalContentView setTransform:CGAffineTransformIdentity];
        fromView.layer.transform = CATransform3DIdentity;
        toView.layer.transform = CATransform3DIdentity;
        [fromView.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        [toView.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
        
        [fromShadow removeFromSuperview];
        [toShadow removeFromSuperview];
        
        if ([transitionContext transitionWasCancelled]) {
            [toView removeFromSuperview];
        } else {
            [fromView removeFromSuperview];
        }
        
        // inform the context of completion
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

- (UIView *)addOpacityToView:(UIView *) view withColor:(UIColor *)theColor
{
    UIView *shadowView = [[UIView alloc] initWithFrame:view.bounds];
    [shadowView setBackgroundColor:[theColor colorWithAlphaComponent:0.8]];
    [view addSubview:shadowView];
    return shadowView;
}



@end
