//
//  RefreshHeaderDefaultView.swift
//  Refresh
//
//  Created by Casey on 10/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class RefreshHeaderDefaultView: RefreshHeaderBaseView {

  
    let _descLabel = UILabel.init()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        _descLabel.font = UIFont.systemFont(ofSize: 14)
        _descLabel.textColor = .black
        _descLabel.textAlignment = .center
        self.addSubview(_descLabel)
        
    
        self.automaticallyChangeAlpha = false;
        
        self.backgroundColor = .red
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        _descLabel.frame = CGRect.init(x: 0, y: 0, width: self.width, height: self.height)
        
        switch self.state {
        case .idle:
            idleStatusView()
            
        case .pulling:
            loadOperationStatusView()
            
        case .refreshing:
            loadingStatusView()
            
        case .willRefresh:
            willLoadingStatusView()
            
        default:
            break
            
        }
        
        
        
        
        
    }
    
    func idleStatusView()  {
        
        let descDetail = "下拉刷新"
        _descLabel.text = descDetail
    
        
    }
    
    func loadOperationStatusView() {
        
        let descDetail = "松开即可加载"
        _descLabel.text = descDetail
        
        
    }
    
    func willLoadingStatusView() {
        
        let descDetail = "即将加载"
        _descLabel.text = descDetail
        
        
    }
    
    
    func loadingStatusView() {
        
        let descDetail = "正在加载..."
        _descLabel.text = descDetail
        
        
    }
}
