//
//  NavAnimaThoeryViewCtr.m
//  NavTheoryClass
//
//  Created by sy on 2019/1/5.
//  Copyright © 2019年 sy. All rights reserved.
//

#import "NavAnimaThoeryViewCtr.h"

@interface NavAnimaThoeryViewCtr (){
    
    UIView *transferView;
    UIView *preView;
    UINavigationBar *preNavBar;
    
}

@end

@implementation NavAnimaThoeryViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"动画原理";
    self.view.backgroundColor = UIColor.whiteColor;
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavTransition:)];
    [self.view addGestureRecognizer:panGes];
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    transferView = [self.view superview]; // 获取转场场景 View
    if (self.navigationController.viewControllers.count >= 2) {
        
        NSArray *viewCtrAry = self.navigationController.viewControllers;
        preView = ((UIViewController*)[viewCtrAry objectAtIndex:viewCtrAry.count -2]).view;
        //上一个控制器的view
    }
}


/*
 导航条的动画
 内容区的动画
 */
- (void)handleNavTransition:(UIPanGestureRecognizer*)gesture{
    
    CGPoint gapPoint = [gesture translationInView:gesture.view];
    [gesture setTranslation:CGPointZero inView:gesture.view];
    float width = gapPoint.x;
    //CGPoint posPoint = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [preView setFrame:CGRectMake(-preView.frame.size.width, preView.frame.origin.y, preView.frame.size.width, preView.frame.size.height)];
        [transferView addSubview:preView];
        
       // [transferView bringSubviewToFront:self.view];
    
        
    }else if(gesture.state == UIGestureRecognizerStateChanged) {
        
        [preView setFrame:CGRectMake(preView.frame.origin.x + width, preView.frame.origin.y, preView.frame.size.width, preView.frame.size.height)];
        [self.view setFrame:CGRectMake(self.view.frame.origin.x + width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
        
        
//        self.navigationController.navigationBar.frame = ({
//            CGRect rect = self.navigationController.navigationBar.frame;
//            rect.origin.x = self.view.frame.origin.x + width;
//            rect;
//        });

    
        
    }else{
        
        // 滑动位置超过一半，就直接pop，小于一半就直接还原
        if (self.view.frame.origin.x > self.view.frame.size.width/2) {
            
            [UIView animateWithDuration:0.3 animations:^{
                [preView setFrame:CGRectMake(0, preView.frame.origin.y, preView.frame.size.width, preView.frame.size.height)];
                [self.view setFrame:CGRectMake(self.view.frame.size.width, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
                
            } completion:^(BOOL finished) {
                
                NSMutableArray *array = [NSMutableArray array];
                [array addObjectsFromArray:self.navigationController.viewControllers];
                [array removeLastObject];
                self.navigationController.viewControllers = array;
                [self.view removeFromSuperview];
                
                
            }];
            
        }else{
            
            [UIView animateWithDuration:0.3 animations:^{
                [preView setFrame:CGRectMake(-preView.frame.size.width, preView.frame.origin.y, preView.frame.size.width, preView.frame.size.height)];
                [self.view setFrame:CGRectMake(0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
                
            } completion:^(BOOL finished) {
                
                [preView removeFromSuperview];
                
                
            }];
            
        }
        
    }
    
    
}




@end
