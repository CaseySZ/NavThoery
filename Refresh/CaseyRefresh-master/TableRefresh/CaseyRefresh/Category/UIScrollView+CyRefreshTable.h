//
//  UIScrollView+RefreshTable.h
//  TableRefresh
//
//  Created by Casey on 04/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CyRefreshHeaderBaseView;
@class CyRefreshFooterBaseView;

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (CyRefreshTable)


@property (strong, nonatomic) CyRefreshHeaderBaseView *cy_header;
@property (strong, nonatomic) CyRefreshFooterBaseView *cy_footer;


@end

NS_ASSUME_NONNULL_END
