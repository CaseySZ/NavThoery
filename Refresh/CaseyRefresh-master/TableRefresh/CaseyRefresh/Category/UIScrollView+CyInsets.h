//
//  UIScrollView+CyInsets.h
//  TableRefresh
//
//  Created by Casey on 05/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (CyInsets)


@property (readonly, nonatomic) UIEdgeInsets cy_inset;

@property (assign, nonatomic) CGFloat cy_insetT;
@property (assign, nonatomic) CGFloat cy_insetB;
@property (assign, nonatomic) CGFloat cy_insetL;
@property (assign, nonatomic) CGFloat cy_insetR;

@property (assign, nonatomic) CGFloat cy_offsetX;
@property (assign, nonatomic) CGFloat cy_offsetY;

@property (assign, nonatomic) CGFloat cy_contentW;
@property (assign, nonatomic) CGFloat cy_contentH;


@end

NS_ASSUME_NONNULL_END
