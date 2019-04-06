//
//  ScrollviewRefresh.swift
//  Refresh
//
//  Created by Casey on 05/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation
import UIKit


private var _refreshFooter: Void?

extension UIScrollView {
    
    
    
    var refreshFooter:RefreshFooterBaseView? {
        
        get {
            
            
            
            return objc_getAssociatedObject(self, &_refreshFooter) as? RefreshFooterBaseView
            
            
        }set {
            
            
            objc_setAssociatedObject(self, &_refreshFooter, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        }
    
    }
    
    
   
    
    
    
    
    
    
}

