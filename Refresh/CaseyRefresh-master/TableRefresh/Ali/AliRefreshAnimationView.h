//
//  CyRefreshAnimationView.h
//  IOS_B01
//
//  Created by Casey on 22/01/2019.
//  Copyright © 2019 Casey. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface AliRefreshAnimationView : UIView

- (void)animationScrollViewOffsetY:(CGFloat)offsetY;

- (void)animationFlush;

- (void)animationEndLoading:(void (^)(void))completion;

@end


