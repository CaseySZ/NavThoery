//
//  UIResponder+Nav.h
//  XPSPlatform
//
//  Created by sy on 2018/3/31.
//  Copyright © 2018年 EOC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIResponder (Nav)


@property (nonatomic, strong, readonly)UINavigationController *syNav;


- (UINavigationController*)syNav;

@end
