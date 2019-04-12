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
private var _refreshHeader: Void?
extension UIScrollView {
    
    
    
    var refreshFooter:RefreshFooterBaseView? {
        
        get {
            
    
            return objc_getAssociatedObject(self, &_refreshFooter) as? RefreshFooterBaseView

            
        }set {
            
            if let tableview = self as? UITableView {
                tableview.estimatedRowHeight = 0
            }
            if self.refreshFooter != newValue {
                
                self.refreshFooter?.removeFromSuperview()
                if let newView = newValue {
                    self.insertSubview(newView, at: 0)
                }
            }
            objc_setAssociatedObject(self, &_refreshFooter, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        }
    
    }
    
    var refreshHeader:RefreshHeaderBaseView? {
        
        get {
            
            
            return objc_getAssociatedObject(self, &_refreshHeader) as? RefreshHeaderBaseView
            
            
        }set {
            
            if let tableview = self as? UITableView {
                tableview.estimatedRowHeight = 0
            }
            if self.refreshHeader != newValue {
                
                self.refreshHeader?.removeFromSuperview()
                if let newView = newValue {
                    self.insertSubview(newView, at: 0)
                }
            }
            objc_setAssociatedObject(self, &_refreshHeader, newValue, .OBJC_ASSOCIATION_RETAIN)
            
        }
        
    }
   
    
    
    
    
    
    
}

