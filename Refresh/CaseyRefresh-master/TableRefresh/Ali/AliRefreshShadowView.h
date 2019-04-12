//
//  CyRefreshShadowView.h
//  IOS_B01
//
//  Created by Casey on 22/01/2019.
//  Copyright © 2019 Casey. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AliRefreshShadowView : UIView


@property (nonatomic, assign)CGFloat visibleValueY;



- (void)animationCirle:(CGFloat)animationTime;


- (void)animationOval:(CGFloat)animationTime;

@end


