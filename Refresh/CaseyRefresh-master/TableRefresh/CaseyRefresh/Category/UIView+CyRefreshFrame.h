//
//  UIView+RefreshFrame.h
//  TableRefresh
//
//  Created by Casey on 04/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (CyRefreshFrame)


@property(nonatomic, assign)CGFloat cy_x;
@property(nonatomic, assign)CGFloat cy_y;
@property(nonatomic, assign)CGFloat cy_width;
@property(nonatomic, assign)CGFloat cy_height;
@property(nonatomic, assign)CGFloat cy_centerY;
@property(nonatomic, assign)CGFloat cy_centerX;

@end

NS_ASSUME_NONNULL_END
