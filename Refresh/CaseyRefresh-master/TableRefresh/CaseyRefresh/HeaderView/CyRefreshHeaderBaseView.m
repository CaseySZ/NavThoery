//
//  CaseyRefreshView.m
//  TableRefresh
//
//  Created by Casey on 04/12/2018.
//  Copyright © 2018 Casey. All rights reserved.
//

#import "CyRefreshHeaderBaseView.h"
#import "UIView+CyRefreshFrame.h"
#import "UIScrollView+CyInsets.h"



@interface CyRefreshHeaderBaseView(){
    
    
}

@property (weak, nonatomic, readonly) UIScrollView *scrollView;
@property (copy, nonatomic) CyBeginRefreshingBlock beginRefreshingBlock;


/** 记录scrollView刚开始的inset */
@property (assign, nonatomic, readonly) UIEdgeInsets scrollViewOriginalInset;

// header 悬浮距离
@property (assign, nonatomic) CGFloat insetTopSuspend;

/** 是否正在刷新 */
@property (assign, nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

/** 拉拽的百分比(交给子类重写) */
@property (assign, nonatomic) CGFloat pullingPercent;


@end



@implementation CyRefreshHeaderBaseView

+ (instancetype)headerWithRefreshingBlock:(CyBeginRefreshingBlock)beginRefreshingBlock
{
    CyRefreshHeaderBaseView *headerView = [[self alloc] init];
    headerView.beginRefreshingBlock = beginRefreshingBlock;
    return headerView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.cy_width = UIScreen.mainScreen.bounds.size.width;
        self.cy_height = CyRefreshHeaderHeight;
        self.backgroundColor = [UIColor clearColor];
        
        
        self.automaticallyChangeAlpha = YES;
        
        
    }
    
    return self;
    
}




- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (self.state == 0){ // 初始化第一次，默认状态
        self.state = CyRefreshStateIdle;
    }
    
    
    self.cy_x = -_scrollView.cy_insetL;;
    self.cy_y = -CyRefreshHeaderHeight;
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
    
    if (newSuperview != nil){
        [self addObservers];
    }
    
}

- (void)removeObservers
{
    [self.superview removeObserver:self forKeyPath:KVOKeyPathContentOffset];
}

- (void)addObservers{
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:KVOKeyPathContentOffset options:options context:nil];
    
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 遇到这些情况就直接返回
    if (!self.userInteractionEnabled) return;
    
    // 看不见
    if ([keyPath isEqualToString:KVOKeyPathContentOffset]) {
        [self scrollViewContentOffsetDidChange:change];
        [self scrollViewMoving];
    }
}

- (void)scrollViewMoving{
    
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    
    // 在刷新的refreshing状态
    if (self.state == CyRefreshStateRefreshing) {
        // 暂时保留
        if (self.window == nil) return;
        
        // sectionheader停留解决
        CGFloat insetT = - self.scrollView.cy_offsetY > _scrollViewOriginalInset.top ? - self.scrollView.cy_offsetY : _scrollViewOriginalInset.top;
        insetT = insetT > self.cy_height + _scrollViewOriginalInset.top ? self.cy_height + _scrollViewOriginalInset.top : insetT;
        self.scrollView.cy_insetT = insetT;
        
        self.insetTopSuspend = _scrollViewOriginalInset.top - insetT;
        
        return;
    }
    
    // 跳转到下一个控制器时，contentInset可能会变
    _scrollViewOriginalInset = self.scrollView.cy_inset;
    
    // 当前的contentOffset
    CGFloat offsetY = self.scrollView.cy_offsetY;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = - self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    // >= -> >
    if (offsetY > happenOffsetY) return;
    
    // 普通 和 即将刷新 的临界点
    CGFloat normal2pullingOffsetY = happenOffsetY - self.cy_height;
    CGFloat pullingPercent = (happenOffsetY - offsetY) / self.cy_height;
    self.pullingPercent = pullingPercent;
    if (self.scrollView.isDragging) { // 如果正在拖拽
        
        if (self.state == CyRefreshStateIdle && offsetY < normal2pullingOffsetY) {
            
            // 转为即将刷新状态
            
            
            self.state = CyRefreshStatePulling;
            
        } else if (self.state == CyRefreshStatePulling && offsetY >= normal2pullingOffsetY) {
            // 转为普通状态
            
            self.state = CyRefreshStateIdle;
        }
    } else if (self.state == CyRefreshStatePulling) {// 即将刷新 && 手松开
        // 开始刷新
        
        [self beginRefreshing];
    } else{
        
    }
}

- (void)setState:(CyRefreshState)state
{
    CyRefreshState oldState = _state;
    
    if (state == oldState) {
        return;
    }
    
    NSLog(@"state:%d", state);
    _state = state;
    // 根据状态做事情
    if (state == CyRefreshStateIdle) {
        
        if (oldState != CyRefreshStateRefreshing) {
            return;
        }
        
        // 恢复inset和offset
        [UIView animateWithDuration:CyRefreshSlowAnimationDuration animations:^{
            self.scrollView.cy_insetT += self.insetTopSuspend;
            
            // 自动调整透明度
            if (self.automaticallyChangeAlpha) self.alpha = 0.0;
            
        } completion:^(BOOL finished) {
            
            self.pullingPercent = 0.0;
        }];
        
    } else if (state == CyRefreshStateRefreshing) {
        
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:CyRefreshFastAnimationDuration animations:^{
                if (self.scrollView.panGestureRecognizer.state != UIGestureRecognizerStateCancelled) {
                   
                    CGFloat top = self.scrollViewOriginalInset.top + self.cy_height;
                    // 增加滚动区域top
                    self.scrollView.cy_insetT = top;
                 
                    // 设置滚动位置
                    self.scrollView.contentOffset = CGPointMake(0, -top);
                
                }
            } completion:^(BOOL finished) {
                
                if (weakSelf.beginRefreshingBlock){
                    weakSelf.beginRefreshingBlock();
                }
                
            }];
        });
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self setNeedsLayout];
    });
    
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





@end
