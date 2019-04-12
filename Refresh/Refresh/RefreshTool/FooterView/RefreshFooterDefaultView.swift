//
//  RefreshFooterDefaultView.swift
//  Refresh
//
//  Created by Casey on 10/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class RefreshFooterDefaultView: RefreshFooterBaseView {

    let _descLabel = UILabel.init()
    let _arrowUpImageView = UIImageView.init()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        _descLabel.font = UIFont.systemFont(ofSize: 14)
        _descLabel.textColor = .black
        _descLabel.textAlignment = .center
        self.addSubview(_descLabel)
        
        _arrowUpImageView.frame = CGRect.init(x: 0, y: 0, width: 12, height: 14)
        _arrowUpImageView.image = UIImage.init(named: "arrow.png")
        self.addSubview(_arrowUpImageView)
        
        self.backgroundColor = .clear
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        switch self.state {
            case .idle:
                idleStatusView()
            
            case .pulling:
                loadOperationStatusView()
            
            case .refreshing:
                loadingStatusView()
            
            case .willRefresh:
                willLoadingStatusView()
            
            case .noMoreData:
                loadingFinishNoMoreDataStatusView()
            
            case .noMoreDataNoImply:
                cleanStatus()
                
            
            default:
                break
            
        }
        
        
    }
    
    func cleanStatus()  {
        
        _descLabel.text = ""
        _arrowUpImageView.isHidden = true
        
    }
    
    func idleStatusView()  {
        
        
        if let superV = self.superview as? UIScrollView {
            
            if superV.isDragging {
                
                let descDetail = "上拉获取更多"
                let descWidth = descDetail.getWidthWithFont(_descLabel.font)
                let startX = (self.width - (12 + 4 + descWidth))/2
                
                _descLabel.text = descDetail
                _descLabel.frame = CGRect.init(x: startX + 12 + 4, y: 0, width: descWidth, height: self.height)
                
                _arrowUpImageView.frame = CGRect.init(x: startX, y: (self.height-14)/2, width: 12, height: 14)
                _arrowUpImageView.isHidden = false
                
                
            }else {
                
                cleanStatus()
                
            }
            
            
            
        }
        
    }
    
    func loadOperationStatusView() {
        
        let descDetail = "松开即可加载"
        let descWidth = descDetail.getWidthWithFont(_descLabel.font)
    
        let startX = (self.width - descWidth)/2
        
        _descLabel.text = descDetail;
        _descLabel.frame = CGRect.init(x: startX, y: 0, width: descWidth, height: self.height)
        
        _arrowUpImageView.isHidden = true
        
        
    }
    
    func willLoadingStatusView() {
        
        let descDetail = "即将加载"
        let descWidth = descDetail.getWidthWithFont(_descLabel.font)
        
        let startX = (self.width - descWidth)/2
        
        _descLabel.text = descDetail;
        _descLabel.frame = CGRect.init(x: startX, y: 0, width: descWidth, height: self.height)
        
        _arrowUpImageView.isHidden = true
        
        
    }
    
    
    func loadingStatusView() {
        
        let descDetail = "正在加载..."
        let descWidth = descDetail.getWidthWithFont(_descLabel.font)
        
        let startX = (self.width - descWidth)/2
        
        _descLabel.text = descDetail;
        _descLabel.frame = CGRect.init(x: startX, y: 0, width: descWidth, height: self.height)
        
        _arrowUpImageView.isHidden = true
        
        
    }
    
    func loadingFinishNoMoreDataStatusView() {
        
        let descDetail = "数据已全部加载完"
        let descWidth = descDetail.getWidthWithFont(_descLabel.font)
        
        let startX = (self.width - descWidth)/2
        
        _descLabel.text = descDetail;
        _descLabel.frame = CGRect.init(x: startX, y: 0, width: descWidth, height: self.height)
        
        _arrowUpImageView.isHidden = true
        
        
    }
    
//    override var state: RefreshState {
//
//        get {
//
//            return super.state
//
//        }set {
//
//            super.state = newValue
//
//        }
//    }
    
    
}
