//
//  RefreshFooterBaseView.swift
//  Refresh
//
//  Created by Casey on 05/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit




class RefreshFooterBaseView: UIView {

    
    var state = RefreshState.noState
    
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
        
        let refreshView = RefreshFooterBaseView()
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
    
    var  _scrollViewOriginalInset: UIEdgeInsets?
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
        _scrollViewOriginalInset = _scrollView?.inset

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
            
            scrollviewCOntentOffsetDidChange(change)
        }
        
        if keyPath?.elementsEqual(KVOKeyPathContentSize) == true {
            
            scrollViewContentSizeDidChange(change)
        }
        
        
    }
    
    func scrollViewContentSizeDidChange(_ change:Dictionary<NSKeyValueChangeKey, Any>?)  {
        
        
    }
    
    func scrollviewCOntentOffsetDidChange(_ change:Dictionary<NSKeyValueChangeKey, Any>?) {
        
        
    }
    
    
    
    
    func beginRefreshing()  {
        
        
    }
    
    
    func endRefreshing()  {
        
        
    }
    
    
    func endRefreshingNoMoreData()  {
        
    }
    
    
    func endRefreshingNoMoreDataNoImply()  {
        
    }
    
    
   
    
    
    
    
}
