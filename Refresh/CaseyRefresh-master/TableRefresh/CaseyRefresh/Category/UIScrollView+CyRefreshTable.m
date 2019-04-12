//
//  UIScrollView+RefreshTable.m
//  TableRefresh
//
//  Created by Casey on 04/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "UIScrollView+CyRefreshTable.h"
#import <objc/runtime.h>


NS_ASSUME_NONNULL_BEGIN

@implementation UIScrollView (CyRefreshTable)


- (CyRefreshHeaderBaseView*)cy_header{
    
    return objc_getAssociatedObject(self, @selector(cy_header));
}


- (void)setCy_header:(CyRefreshHeaderBaseView *)cy_header{
    
    
    if (cy_header != self.cy_header){
        UIView *headerView = (UIView*)self.cy_header;
        [headerView removeFromSuperview];
        [self insertSubview:(UIView*)cy_header atIndex:0];
        objc_setAssociatedObject(self, @selector(cy_header),cy_header, OBJC_ASSOCIATION_RETAIN);
    }
}

- (CyRefreshFooterBaseView*)cy_footer{
    
    return objc_getAssociatedObject(self, @selector(cy_footer));
}


- (void)setCy_footer:(CyRefreshFooterBaseView *)cy_footer{
    
    
    if (cy_footer != self.cy_footer){
        UIView *footerView = (UIView*)self.cy_footer;
        [footerView removeFromSuperview];
        [self insertSubview:(UIView*)cy_footer atIndex:0];
        objc_setAssociatedObject(self, @selector(cy_footer),cy_footer, OBJC_ASSOCIATION_RETAIN);
    }
}



@end

NS_ASSUME_NONNULL_END
