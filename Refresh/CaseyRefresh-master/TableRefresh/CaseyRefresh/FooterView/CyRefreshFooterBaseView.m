//
//  CyRefreshFooterBaseView.m
//  TableRefresh
//
//  Created by Casey on 05/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "CyRefreshFooterBaseView.h"
#import "UIView+CyRefreshFrame.h"
#import "UIScrollView+CyInsets.h"

@interface CyRefreshFooterBaseView()


@property (assign, nonatomic) CGFloat lastBottomDelta;
@property (assign, nonatomic) NSInteger lastRefreshCount;

@property (weak, nonatomic, readonly) UIScrollView *scrollView;
@property (copy, nonatomic) CyBeginRefreshingBlock beginRefreshingBlock;

/** 记录scrollView刚开始的inset */
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;

/** 是否正在刷新 */
@property (assign, nonatomic, readonly) BOOL isRefreshing;

/** 拉拽的百分比(交给子类重写) */
@property (assign, nonatomic) CGFloat pullingPercent;


@end

@implementation CyRefreshFooterBaseView

+ (instancetype)footerWithRefreshingBlock:(CyBeginRefreshingBlock)beginRefreshingBlock
{
    CyRefreshFooterBaseView *footerView = [[self alloc] init];
    footerView.beginRefreshingBlock = beginRefreshingBlock;
    return footerView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.cy_height = CyRefreshFooterHeight;
        self.backgroundColor = [UIColor clearColor];
        self.automaticallyChangeAlpha = YES;
    }
    
    return self;
    
}




- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.state == 0){ // 初始化第一次，默认状态
        self.state = CyRefreshStateIdle;
        [self scrollViewContentSizeDidChange:nil];
    }
    
    self.cy_x = -_scrollView.cy_insetL;
    self.cy_width = self.superview.cy_width;
    self.cy_height = CyRefreshHeaderHeight;
    
    if (self.state == CyRefreshStateWillRefresh) {
        // 预防view还没显示出来就调用了beginRefreshing
        self.state = CyRefreshStateRefreshing;
    }
    
    
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    _scrollView = (UIScrollView *)newSuperview;
    _scrollView.alwaysBounceVertical = YES;
    
    // 记录UIScrollView最开始的contentInset
    _scrollViewOriginalInset = _scrollView.cy_inset;
    
    [self addObservers];
    
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:KVOKeyPathContentOffset];
    [self.superview removeObserver:self forKeyPath:KVOKeyPathContentSize];
    
}

- (void)addObservers{
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:KVOKeyPathContentOffset options:options context:nil];
    [self.scrollView addObserver:self forKeyPath:KVOKeyPathContentSize options:options context:nil];
    
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    if ([keyPath isEqualToString:KVOKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
    }
    if ([keyPath isEqualToString:KVOKeyPathContentSize]) {
        [self scrollViewContentSizeDidChange:change];
    }
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change{
    
    // 内容的高度
    CGFloat contentHeight = self.scrollView.cy_contentH ;
    // 表格的高度
    CGFloat scrollHeight = self.scrollView.cy_height - self.scrollViewOriginalInset.top - self.scrollViewOriginalInset.bottom;
    // 设置位置和尺寸
    self.cy_y = MAX(contentHeight, scrollHeight);
    
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    
    // 如果正在刷新，直接返回
    if (self.state == CyRefreshStateRefreshing) {
        return;
    }
    
    _scrollViewOriginalInset = self.scrollView.cy_inset;
    
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.cy_offsetY;
    // 尾部控件刚好出现的offsetY
    CGFloat reponseRefreshOffsetY = [self reponseRefreshOffsetY];
    // 如果是向下滚动到看不见尾部控件，直接返回
    if (currentOffsetY <= reponseRefreshOffsetY) return;
    
    CGFloat pullingPercent = (currentOffsetY - reponseRefreshOffsetY) / self.cy_height;
    
    // 如果已全部加载，仅设置pullingPercent，然后返回
    if (self.state == CyRefreshStateNoMoreData) {
        self.pullingPercent = pullingPercent;
        return;
    }
    
    if (self.scrollView.isDragging) {
        self.pullingPercent = pullingPercent;
        // 普通 和 即将刷新 的临界点
        CGFloat normal2pullingOffsetY = reponseRefreshOffsetY + self.cy_height;
        
        if (self.state == CyRefreshStateIdle && currentOffsetY > normal2pullingOffsetY) {
            // 转为即将刷新状态
            self.state = CyRefreshStatePulling;
        } else if (self.state == CyRefreshStatePulling && currentOffsetY <= normal2pullingOffsetY) {
            // 转为普通状态
            self.state = CyRefreshStateIdle;
        }
    } else if (self.state == CyRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        [self beginRefreshing];
        
    } else if (pullingPercent < 1) {
        self.pullingPercent = pullingPercent;
    }
    
}

#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)heightForContentBreakView
{
    CGFloat height = self.scrollView.frame.size.height - self.scrollViewOriginalInset.bottom - self.scrollViewOriginalInset.top;
    return self.scrollView.contentSize.height - height;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)reponseRefreshOffsetY{
    
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.scrollViewOriginalInset.top;
    } else {
        return - self.scrollViewOriginalInset.top;
    }
}



- (void)beginRefreshing{
    
    
    [UIView animateWithDuration:CyRefreshFastAnimationDuration animations:^{
        self.alpha = 1.0;
    }];
    // 只要正在刷新，就完全显示
    if (self.window) {
        self.state = CyRefreshStateRefreshing;
    } else {
        // 预防正在刷新中时，调用本方法使得header inset回置失败
        if (self.state != CyRefreshStateRefreshing) {
            
            self.state = CyRefreshStateWillRefresh;
            // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
            [self setNeedsLayout];
        }
    }
}

- (void)endRefreshing{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = CyRefreshStateIdle;
    });
    
}

- (void)endRefreshingNoMoreData{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = CyRefreshStateNoMoreData;
    });
}

- (void)endRefreshingNoMoreDataNoImply{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.state = CyRefreshStateNoMoreDataNoImply;
    });
}

#pragma mark 是否正在刷新
- (BOOL)isRefreshing
{
    return self.state == CyRefreshStateRefreshing || self.state == CyRefreshStateWillRefresh;
}

#pragma mark 根据拖拽进度设置透明度
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    if (pullingPercent > 1){
        _pullingPercent = 1;
    }else{
        _pullingPercent = pullingPercent;
    }
    
    if (self.automaticallyChangeAlpha) {
        
        if (self.isRefreshing){
            
            self.alpha = 1;
            
        }else{
            
            self.alpha = pullingPercent;
        }
        
        
    }
}

- (void)setState:(CyRefreshState)state
{
    CyRefreshState oldState = _state;
    if (state == oldState) {
        return;
    }
    _state = state;
    
    
    // 根据状态来设置属性
    if (state == CyRefreshStateNoMoreData || state == CyRefreshStateIdle) {
        // 刷新完毕
        if (CyRefreshStateRefreshing == oldState) {
            [UIView animateWithDuration:CyRefreshSlowAnimationDuration animations:^{
                self.scrollView.cy_insetB -= self.lastBottomDelta;
                
                
            } completion:^(BOOL finished) {
                self.pullingPercent = 0.0;
            }];
        }
        
        CGFloat deltaH = [self heightForContentBreakView];
        // 刚刷新完毕 mj_totalDataCount
        if (CyRefreshStateRefreshing == oldState && deltaH > 0 && self.cy_totalDataCount != self.lastRefreshCount) {
            self.scrollView.cy_offsetY = self.scrollView.cy_offsetY;
        }
    } else if (state == CyRefreshStateRefreshing) {
        
        // 记录刷新前的数量
        self.lastRefreshCount = self.cy_totalDataCount;
        
        [UIView animateWithDuration:CyRefreshFastAnimationDuration animations:^{
            CGFloat bottom = self.cy_height + self.scrollViewOriginalInset.bottom;
            CGFloat deltaH = [self heightForContentBreakView];
            if (deltaH < 0) { // 如果内容高度小于view的高度
                bottom -= deltaH;
            }
            self.lastBottomDelta = bottom - self.scrollView.cy_insetB;
            self.scrollView.cy_insetB = bottom;
            self.scrollView.cy_offsetY = [self reponseRefreshOffsetY] + self.cy_height;
        } completion:^(BOOL finished) {
            
            if (self.beginRefreshingBlock){
                self.beginRefreshingBlock();
            }
            
        }];
    }
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setNeedsLayout];
    });
}


#pragma mark - other
- (NSInteger)cy_totalDataCount
{
    NSInteger totalCount = 0;
    
    if ([self.scrollView isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self.scrollView ;
        
        for (NSInteger section = 0; section<tableView.numberOfSections; section++) {
            totalCount += [tableView numberOfRowsInSection:section];
        }
    } else if ([self.scrollView  isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollView ;
        
        for (NSInteger section = 0; section<collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}



@end
