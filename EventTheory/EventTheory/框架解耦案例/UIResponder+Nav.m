//
//  UIResponder+Nav.m
//  XPSPlatform
//
//  Created by sy on 2018/3/31.
//  Copyright © 2018年 EOC. All rights reserved.
//

#import "UIResponder+Nav.h"

@implementation UIResponder (Nav)

- (UINavigationController*)syNav{
    
    if ([self isKindOfClass:[UIWindow class]]) {
        return nil;
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarVC = (UITabBarController *)self;
        if ([tabbarVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
            return (UINavigationController *)tabbarVC.selectedViewController;
        }
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController*)self;
    }
    
    if ([self isKindOfClass:[UIViewController class]]) {
        UIViewController *viewCtr = (UIViewController*)self;
        if (viewCtr.navigationController) {
            return viewCtr.navigationController;
        }
    }
    
    UIViewController *viewCtr = (UIViewController*)[self nextResponder];
    if ([viewCtr isKindOfClass:[UIViewController class]]) {
        if (viewCtr.navigationController) {
            return viewCtr.navigationController;
        }
    }
    return [viewCtr syNav];
}

@end
