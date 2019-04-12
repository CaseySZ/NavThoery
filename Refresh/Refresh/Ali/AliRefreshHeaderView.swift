//
//  AliRefreshHeaderView.swift
//  Refresh
//
//  Created by Casey on 12/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class AliRefreshHeaderView: RefreshHeaderBaseView {

    
    let _animationView = AliRefreshAnimationView.init(frame: CGRect.init(x: 0, y: 0, width: 100, height: RefreshHeaderHeight))
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        self.addSubview(_animationView)
        
        self.automaticallyChangeAlpha = false
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        _animationView.centerX = self.width/2
        
        // 不需要捕获状态 更具偏移位置来操作
        
    }
    
    // 开始刷新
    override func beginRefreshing() {
        
        super.beginRefreshing()
        
        if let _ = self.superview as? UIScrollView {
            
            _animationView.animationScrollViewOffsetY(-self.height)
        }
        
        
        
    }
    
    // 结束刷新
    var _isEndRefreshing = false // 正在执行结束刷新操作
    override func endRefreshing() {
        
        _isEndRefreshing = true
        
        CATransaction.flush()
        
        weak var weakSelf = self
        _animationView.animationEndLoading {
            
            weakSelf?.endrefreshFinsiAnimation()
        }
        
        CATransaction.commit()
        
    }
    
    func endrefreshFinsiAnimation()  {
        
        super.endRefreshing()
        _isEndRefreshing = false
        
    }
    
    // 滑动
    override func scrollViewMoving() {
        
        super.scrollViewMoving()
        
        
        if let scrollView = self.superview as? UIScrollView {
            
            if scrollView.isDragging {
                
                _animationView .animationScrollViewOffsetY(scrollView.contentOffset.y)
                
            }else {
                
                if self.state == .refreshing && !_isEndRefreshing { // 开始执行加载动画
                    
                    // _isEndRefreshing的条件作用：当在执行结束刷新动画的过程中，不能执行刷新动画，因为刷新结束操作没有完成
                    _animationView.animationStartLoading()
                }
                
            }
            
        }
        
        
    }
    
}
