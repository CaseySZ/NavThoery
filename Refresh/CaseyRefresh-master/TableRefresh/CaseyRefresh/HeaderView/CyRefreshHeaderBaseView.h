//
//  CaseyRefreshView.h
//  TableRefresh
//
//  Created by Casey on 04/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CyRefreshBaseData.h"




@interface CyRefreshHeaderBaseView : UIView


+ (instancetype)headerWithRefreshingBlock:(CyBeginRefreshingBlock)beginRefreshingBlock;


@property (assign, nonatomic) CyRefreshState state;


/**
 根据拖拽比例自动切换透明度 default是YES
 */
@property (assign, nonatomic) BOOL automaticallyChangeAlpha;


- (void)endRefreshing;
- (void)beginRefreshing;

- (void)scrollViewMoving; // scrollview移动

@end


