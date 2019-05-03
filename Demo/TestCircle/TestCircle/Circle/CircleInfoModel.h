//
//  CircleInfoModel.h
//  TestCircle
//
//  Created by Casey on 21/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CircleInfoModel : NSObject

@property (nonatomic, strong)UIColor *color; // 圆颜色
@property (nonatomic, assign)CGFloat radius; // 圆半径
@property (nonatomic, assign)CGFloat x; // 圆心坐标 x
@property (nonatomic, assign)CGFloat y; // 圆心坐标 y


@property (nonatomic, assign, readonly)BOOL isHaveLine; // 是否有直线穿过园
@property (nonatomic, assign)CGPoint startLinePoint; // 直线起始位置
@property (nonatomic, assign)CGPoint endLinePoint;  // 直线结束位置


@end

NS_ASSUME_NONNULL_END
