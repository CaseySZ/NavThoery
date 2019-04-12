//
//  RefreshFooterBaseView.swift
//  Refresh
//
//  Created by Casey on 05/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit




class RefreshFooterBaseView: UIView {

    
    var automaticallyChangeAlpha = true
    
    weak var _scrollView:UIScrollView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.height = RefreshFooterHeight
        self.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var refreshCallBack:(() -> Void)?
    
    static func footerWithRefreshBlock(_ block: (() -> Void)? ) ->  RefreshFooterBaseView{
        
        let refreshView = self.init()
        refreshView.refreshCallBack = block
        return refreshView
        
    }

    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        if self.state == RefreshState.noState {
            self.state = RefreshState.idle
            scrollViewContentSizeDidChange(nil)
        }
        
        if let scrollview = _scrollView {
            self.x = -scrollview.insetLeft
            self.width = scrollview.width
            self.height = RefreshFooterHeight
        }
        
        if self.state == .willRefresh {
            // 预防view还没显示出来就调用了 beginRefreshing
            self.state = .refreshing
        }
        
        
    }
    
    var  _scrollViewOriginalInset: UIEdgeInsets = UIEdgeInsets.zero
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        // 如果不是UIScrollView ，不处理
        if let nSuperView = newSuperview {
            if !nSuperView.isKind(of: UIScrollView.self) {
                return
            }
        }
        
        removeObservers()
        
        _scrollView = newSuperview as? UIScrollView
        _scrollView?.alwaysBounceVertical = true
        
        // 记录UIScrollview最开始的contentInset
        _scrollViewOriginalInset = _scrollView?.inset ?? UIEdgeInsets.zero

        addObservers()
        
    }
    
    //MARK: KVO
    
    func removeObservers()  {
        
        if let superview = self.superview {
            
            superview.removeObserver(self, forKeyPath: KVOKeyPathContentOffset)
            superview.removeObserver(self, forKeyPath: KVOKeyPathContentSize)
        }
        
    }
    
    func addObservers()  {
        
        if let scrollview = _scrollView {
            
            scrollview.addObserver(self, forKeyPath: KVOKeyPathContentOffset, options: .new, context: nil)
            scrollview.addObserver(self, forKeyPath: KVOKeyPathContentSize, options: .new, context: nil)
        }
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if self.isUserInteractionEnabled == false {
            return
        }
        if keyPath?.elementsEqual(KVOKeyPathContentOffset) == true {
            
            scrollviewContentOffsetDidChange(change)
        }
        
        if keyPath?.elementsEqual(KVOKeyPathContentSize) == true {
            
            scrollViewContentSizeDidChange(change)
        }
        
        
    }
    
    func scrollViewContentSizeDidChange(_ change:Dictionary<NSKeyValueChangeKey, Any>?)  {
        
        if let scrollview = _scrollView {
            // 内容的高度
            let contentHeight = scrollview.contentHeight

            // 表的高度
            let scrollHeight = scrollview.height - _scrollViewOriginalInset.top - _scrollViewOriginalInset.bottom
            
            // 设置位置
            self.y = (scrollHeight > contentHeight) ? scrollHeight : contentHeight
            
        }
    }
    
    
    
    
    func scrollviewContentOffsetDidChange(_ change:Dictionary<NSKeyValueChangeKey, Any>?) {
        
        // 如果正在刷新，直接返回
        if self.state == .refreshing {
            return
        }
        
        if let scrollview = _scrollView {
            
            _scrollViewOriginalInset = scrollview.inset
            
            // 当前的contentOffset
            let currentOffsetY = scrollview.offsetY
            
            // 尾部控件刚好出现的offsetY
            let responRefreshOffsetY = responseRefreshOffsetY()
            
            // 如果是向下滚动到看不见尾部控件，直接返回
            if currentOffsetY <= responRefreshOffsetY {
                return
            }
            
            
            let pullingPercent = (currentOffsetY - responRefreshOffsetY)/self.height
            
             // 如果已全部加载，仅设置pullingPercent，然后返回
            if self.state == .noMoreData || self.state == .noMoreDataNoImply {
                _pullingPercent = pullingPercent
                return
            }
            
            if scrollview.isDragging {
                
                _pullingPercent = pullingPercent
                
                // 普通 和 即将刷新 的临界点
                let normalPullingOffsetY = responRefreshOffsetY + self.height
                
                if self.state == .idle && currentOffsetY > normalPullingOffsetY {
                    
                    // 转为即将刷新状态
                    self.state = .pulling
                    
                }else if self.state == .pulling && currentOffsetY <= normalPullingOffsetY {
                    
                    // 转为普通状态
                    self.state = .idle
                   
                    
                }else {
                    
                }
                
            }else if self.state == .pulling { // 即将刷新 && 手松开
                
                // 开始刷新
                beginRefreshing()
                
            }else if pullingPercent < 1 {
                
                _pullingPercent = pullingPercent
                
            }else {
                
            }
            
            
        }
    }
    
    // MARK:  获得scrollView的内容 超出 view 的高度
    
    func heightForContentBreakView() -> CGFloat {
        
        if let scrollview = _scrollView {
            
            let height = scrollview.height - _scrollViewOriginalInset.bottom - _scrollViewOriginalInset.top
            return scrollview.contentHeight - height
        }
        
        return 0
        
        
    }
    
    // MARK: 刚好看到上拉刷新控件时的contentOffset.y，准备响应
    func responseRefreshOffsetY() -> CGFloat  {
        
        let deltaH = heightForContentBreakView()
            
        if deltaH > 0 {
            
            return deltaH - _scrollViewOriginalInset.top
            
        }else {
            
            return -_scrollViewOriginalInset.top
        }
            
        
        
        
    }
    
    //MARK: 根据拖拽进度设置透明度
    var _pullingPercent:CGFloat = 0 {
        
        didSet{
            
            if automaticallyChangeAlpha {
                
                if isRefreshing() {
                    
                    self.alpha = 1
                    
                }else {
                    
                    self.alpha = _pullingPercent
                }
                
            }
            
        }
        
    }
    
    //MARK: 是否正在刷新
    func isRefreshing() -> Bool {
        
        return self.state == .refreshing || self.state == .willRefresh
        
    }
    
    
    //MARK: 状态操作
    func beginRefreshing()  {
        
        
        UIView.animate(withDuration: RefreshFastAnimationDuration) {
            self.alpha = 1.0
        }
        
        // 只要正在刷新，就完全显示
        
        if self.window != nil{
            
            self.state = .refreshing
            
        } else {
            
            // 预防正在刷新中时，调用本方法使得header inset回置失败
            if self.state != .refreshing {
                
                self.state = .willRefresh
                // 刷新(预防从另一个控制器回到这个控制器的情况，回来要重新刷新一下)
                setNeedsLayout()
                
            }
            
        }
        
    }
    
    
    func endRefreshing()  {
        
        DispatchQueue.main.async {
            
            self.state = .idle
        }
        
        
    }
    
    
    func endRefreshingNoMoreData()  {
        
        DispatchQueue.main.async {
            
            self.state = .noMoreData
        }
    }
    
    
    func endRefreshingNoMoreDataNoImply()  {
        
        DispatchQueue.main.async {
            
            self.state = .noMoreDataNoImply
        }
    }
    
    
    
    var lastBottomDelta:CGFloat = 0
    
    //MARK: state Set
    var _state =  RefreshState.noState
    var state:RefreshState {
        
        get {
            return _state
        }
        set {
            
            if _state == newValue {
                return
            }
            
            let oldState = _state
            _state = newValue
            
            // 根据状态来设置属性
            if _state == .noMoreData || _state == .idle {
                
                // 刷新完毕
                if oldState == .refreshing {
                    
                    UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
                        
                        if let scrollview = self._scrollView {
                            
                            scrollview.insetBottom -= self.lastBottomDelta
                            
                        }
                        
                    }) { (finish) in
                        
                        self._pullingPercent = 0.0
                    }
                    
                }
                
            }else if (state == .refreshing) {
                
                // 记录刷新前的数量
                UIView.animate(withDuration: RefreshFastAnimationDuration, animations: {
                    
                    var bottom = self.height + self._scrollViewOriginalInset.bottom
                    let deltaH = self.heightForContentBreakView()
                    if deltaH < 0 {
                        bottom -= deltaH
                    }
                    
                    if let scrollview = self._scrollView{
                        self.lastBottomDelta = bottom - scrollview.insetBottom
                        scrollview.insetBottom = bottom
                        scrollview.offsetY = self.responseRefreshOffsetY() + self.height
                    }
                    
                }) { (finish) in
                    
                    if let callBack = self.refreshCallBack {
                        
                        callBack()
                    }
                    
                    
                }
                
                
            }else   {
                
            }
            
            
            // 刷新界面
            DispatchQueue.main.async {
                
                self.setNeedsLayout()
            }
            
        }
        

        
    }
    
    
}
