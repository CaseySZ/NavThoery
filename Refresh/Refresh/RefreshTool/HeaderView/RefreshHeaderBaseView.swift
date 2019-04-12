//
//  RefreshHeaderBaseView.swift
//  Refresh
//
//  Created by Casey on 10/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class RefreshHeaderBaseView: UIView {

    var refreshCallBack:(() -> Void)?
    static func headerWithRefreshBlock(_ block: (() -> Void)? ) ->  RefreshHeaderBaseView{
        
        let refreshView = self.init()
        refreshView.refreshCallBack = block
        return refreshView
        
    }
    
    var automaticallyChangeAlpha = true
    
    weak var _scrollView:UIScrollView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.height = RefreshHeaderHeight
        self.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        if self.state == RefreshState.noState {
            self.state = RefreshState.idle
        }
        
        if let scrollview = _scrollView {
            self.x = -scrollview.insetLeft
            self.y = -RefreshHeaderHeight
            self.width = scrollview.width
            self.height = RefreshHeaderHeight
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
        _scrollViewOriginalInset =  _scrollView?.inset ?? UIEdgeInsets.zero 
        
        if newSuperview != nil {
            addObservers()
        }
        
    }
    
    //MARK: KVO
    
    func removeObservers()  {
        
        if let superview = self.superview {
            
            superview.removeObserver(self, forKeyPath: KVOKeyPathContentOffset)
        }
        
    }
    
    func addObservers()  {
        
        if let scrollview = _scrollView {
            
            scrollview.addObserver(self, forKeyPath: KVOKeyPathContentOffset, options: .new, context: nil)
        }
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if self.isUserInteractionEnabled == false {
            return
        }
        if keyPath?.elementsEqual(KVOKeyPathContentOffset) == true{
            
            scrollviewContentOffsetDidChange(change)
            scrollViewMoving()
        }
        
        
    }
    
    
    func scrollViewMoving()  {
        
    }
    
    var _insetTopSuspend:CGFloat =  0 // 追加的距离，其值是 headerview高度的负数
    func scrollviewContentOffsetDidChange(_ change:Dictionary<NSKeyValueChangeKey, Any>?) {
        
        // 在刷新的refreshing状态
        print("state::\(self.state)")
        if  self.state == .refreshing {
            
            if self.window == nil {
                return
            }
            
            // 停留解决
            if let scrollview = _scrollView {
                
                var insetTop = (-scrollview.offsetY > _scrollViewOriginalInset.top) ? (-scrollview.offsetY) : _scrollViewOriginalInset.top
                if insetTop > self.height + _scrollViewOriginalInset.top {
                    insetTop = self.height + _scrollViewOriginalInset.top
                }
                scrollview.insetTop = insetTop // 悬停位置 inset的top + height
                
                
                _insetTopSuspend = _scrollViewOriginalInset.top - insetTop
                
                
            }
            return
        }
        
        if let scrollview = _scrollView{
            
            // 跳转到下一个控制器时，contentInset可能会变
            _scrollViewOriginalInset = scrollview.inset;
            
            // 当前的contentOffset
            let offsetY = scrollview.offsetY
            
            // 头部控件刚好出现的offsetY
            let happenOffsetY = -_scrollViewOriginalInset.top;
            
            // 如果是向上滚动到看不见头部控件，直接返回
            if offsetY > happenOffsetY {
                return
            }
            
            
            // 普通 和 即将刷新 的临界点
            
            let normalPullingOffsetY = happenOffsetY - self.height;
            let pullingPercent = (happenOffsetY - offsetY) / self.height;
            
            _pullingPercent = pullingPercent;
            if (scrollview.isDragging) { // 如果正在拖拽
                
                if (self.state == .idle && offsetY < normalPullingOffsetY) {
                    
                    // 转为即将刷新状态
                    
                    
                    self.state = .pulling;
                    
                } else if (self.state == .pulling && offsetY >= normalPullingOffsetY) {
                    // 转为普通状态
                    
                    self.state = .idle;
                }
            } else if (self.state == .pulling) {// 即将刷新 && 手松开
                
                // 开始刷新
                beginRefreshing()
                
            } else{
                
            }
            
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
    
    
    var lastBottomDelta:CGFloat = 0
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
            if state == .idle {
                
                if oldState == .refreshing {
                    
                    // 恢复inset和offset
                    UIView.animate(withDuration: RefreshSlowAnimationDuration, animations: {
                        
                        if let scrollview = self._scrollView {
                            
                            scrollview.insetTop += self._insetTopSuspend
                            
                            if self.automaticallyChangeAlpha {
                                self.alpha = 0.0
                            }
                            
                        }
                        
                    }) { (finish) in
                        
                        self._pullingPercent = 0.0
                    }
                    
                }
                
                
            }else if state == .refreshing {
                
                
                DispatchQueue.main.async {
                    
                    
                    UIView.animate(withDuration: RefreshFastAnimationDuration, animations: {
                        
                        if let scrollView = self._scrollView {
                            
                            if scrollView.panGestureRecognizer.state != .cancelled {
                                
                                let top = self._scrollViewOriginalInset.top + self.height
                                // 增加滚动区域top
                                scrollView.insetTop = top;
                                // 设置滚动位置
                                var offset = scrollView.contentOffset;
                                offset.y = -top;
                                scrollView.setContentOffset(offset, animated: false)
                            }
                            
                        }
                        
                    }, completion: { (finish) in
                        
                        self.refreshCallBack?()
                        
                    })
                    
                }
                
            }
            
            
            
            
            // 刷新界面
            DispatchQueue.main.async {
                
                self.setNeedsLayout()
            }
            
        }
        
        
        
    }
    
}
