//
//  ChartDrawOperation.h
//  TestCircle
//
//  Created by Casey on 21/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChartCircleView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChartDrawOperation : NSOperation


@property (nonatomic, strong)UIView *view;
@property (nonatomic, strong)NSArray<CircleInfoModel*> *dataArr;

@end

NS_ASSUME_NONNULL_END
