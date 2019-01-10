//
//  AnimationNavigationCtr.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/5.
//  Copyright © 2019年 sy. All rights reserved.
//

#import "AnimationNavigationCtr.h"
#import "NavAnimation.h"

@interface AnimationNavigationCtr ()<UINavigationControllerDelegate, UIViewControllerTransitioningDelegate>{
    
    UIPercentDrivenInteractiveTransition *percentAnimation;
}

@end

@implementation AnimationNavigationCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.delegate = self;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:panGesture];
    
}


- (void)panGesture:(UIPanGestureRecognizer*)gesture{
    
    // 获取 当前view（fromview）  pop的view（toView）
    
    
    CGPoint movePoint = [gesture translationInView:self.view];
    float precent = movePoint.x/[UIScreen mainScreen].bounds.size.width;
    
    UIViewController *popViewCtr = nil;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
       
        
        
        percentAnimation = [[UIPercentDrivenInteractiveTransition alloc] init];
        popViewCtr = [self popViewControllerAnimated:YES];

        
        
    }else if (gesture.state == UIGestureRecognizerStateChanged){
        
        [percentAnimation updateInteractiveTransition:precent];
        
    }else {
        
        if (percentAnimation.percentComplete > 0.5) {
            
            [percentAnimation finishInteractiveTransition];
            
        }else {
            NSLog(@"cancelInteractiveTransition");
            [percentAnimation cancelInteractiveTransition];
            //[self pushViewController:popViewCtr animated:YES];
        }
        percentAnimation = nil;
    }
    
    
}

// 返回动画进度对象
- (nullable id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                                   interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    
    if ([animationController isKindOfClass:[NavAnimation class]]) {


        return percentAnimation;
    }
    return nil;
}

// 返回动画对象
- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    
    if (operation == UINavigationControllerOperationPop) {
        return [[NavAnimation alloc] init];
    }
    return nil;
}




@end
