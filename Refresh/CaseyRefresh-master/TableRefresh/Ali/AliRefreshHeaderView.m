//
//  CyRefreshHeaderDefaultView.m
//  TableRefresh
//
//  Created by Casey on 05/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "AliRefreshHeaderView.h"
#import "UIView+CyRefreshFrame.h"
#import "CyStringWidthModel.h"
#import "AliRefreshAnimationView.h"

@interface AliRefreshHeaderView (){
    
    
    BOOL isEndRefreshing;
}

@property (nonatomic, assign)CGFloat idleTextWidth;
@property (nonatomic, assign)CGFloat loadOperationTextWidth;
@property (nonatomic, assign)CGFloat willLoadTextWidth;
@property (nonatomic, assign)CGFloat loadingTextWidth;


@end

@implementation AliRefreshHeaderView{
    
    AliRefreshAnimationView *_animationView;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _animationView  = [[AliRefreshAnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, self.frame.size.height)];
        [self addSubview:_animationView];
        
        self.automaticallyChangeAlpha = NO;
    }
    
    return self;
    
}


//
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    _animationView.frame = CGRectMake((self.frame.size.width-100)/2, 0, 100, self.frame.size.height);
    
    switch (self.state) {
            
        case CyRefreshStateRefreshing:
            [self loadingStatusView];
            break;
       
        default:
            break;
    }
}



- (void)beginRefreshing {
    
    [super beginRefreshing];
    UIScrollView *superView = (UIScrollView*)self.superview;
    if ([superView isKindOfClass:[UIScrollView class]]) {
        [_animationView animationScrollViewOffsetY:-self.cy_height];
    }
}


- (void)endRefreshing {
    
    isEndRefreshing = YES;
    [CATransaction flush];
    [_animationView animationEndLoading:^{
        [super endRefreshing];
        self->isEndRefreshing = NO;
    }];
    
    [CATransaction commit];
}

- (void)scrollViewMoving {
    
    UIScrollView *superView = (UIScrollView*)self.superview;
    if ([superView isKindOfClass:[UIScrollView class]]) {
        if (superView.dragging){
            
            [_animationView animationScrollViewOffsetY:superView.contentOffset.y];
            
        }else {
            
            if (self.state == CyRefreshStateRefreshing && !isEndRefreshing) {
                [_animationView animationFlush];
            }else {
                
            }
            
        }
        
    }
    
}


//正在加载
- (void)loadingStatusView {
    
    [_animationView animationFlush];
    
}




@end
