//
//  CircleView.h
//  TestCircle
//
//  Created by Casey on 21/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChartCircleView : UIView


- (void)drawCircle;


@property (nonatomic, strong)NSArray<CircleInfoModel*> *dataArr;


@end

NS_ASSUME_NONNULL_END
