//
//  CyRefreshHeaderDefaultView.m
//  TableRefresh
//
//  Created by Casey on 05/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "CyRefreshHeaderDefaultView.h"
#import "UIView+CyRefreshFrame.h"


@implementation CyRefreshHeaderDefaultView{
    
    UILabel *_descLabel;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _descLabel = [[UILabel alloc] init];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_descLabel];
        
    }
    
    return self;
    
}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _descLabel.frame = self.bounds;
    
    switch (self.state) {
        case CyRefreshStateIdle:
            _descLabel.text = @"闲置状态";
            break;
        case CyRefreshStatePulling:
            _descLabel.text = @"松开就可以进行刷新的状态";
            break;
        case CyRefreshStateRefreshing:
            _descLabel.text = @"正在刷新中的状态";
            break;
        case CyRefreshStateWillRefresh:
            _descLabel.text = @" 即将刷新的状态";
            break;
        case CyRefreshStateNoMoreData:
            _descLabel.text = @"所有数据加载完毕，没有更多的数据了";
            break;
        default:
            break;
    }
}



@end
