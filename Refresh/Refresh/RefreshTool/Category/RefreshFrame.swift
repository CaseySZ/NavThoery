//
//  RefreshFrame.swift
//  Refresh
//
//  Created by Casey on 05/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

enum RefreshState: Int {
    
    case noState = 0 /**/
    
    case idle = 1 /** 普通闲置状态 */
    
    case pulling = 2 /** 松开就可以进行刷新的状态 */

    case refreshing = 3 /** 正在刷新中的状态 */
    
    case willRefresh = 4 /** 即将刷新的状态 */
    case endRefresh = 5
    case noMoreData = 6 /** 所有数据加载完毕，没有更多的数据了 */
    case noMoreDataNoImply = 7  /** 所有数据加载完毕，没有更多的数据了，且无文本状态 */
    
    
}

extension UIView  {
    
    
    var x:CGFloat{
        
        get {
            return self.frame.origin.x
        }set {
            
            self.frame = CGRect.init(x: newValue, y: self.y, width: self.width, height: self.height)
        }
    }
    
    var y:CGFloat {

        get{
            return self.frame.origin.y
        }set {
            
            self.frame = CGRect.init(x:self.x , y: newValue, width: self.width, height: self.height)
        }
    }
    

    
    var width:CGFloat{
        get {
            return self.frame.size.width
        }set {
            
            self.frame = CGRect.init(x:self.x , y: self.y, width: newValue, height: self.height)
        }
    }
    
    var height:CGFloat{
        get{
            return self.frame.size.height
        }set {
            
            self.frame = CGRect.init(x:self.x , y: self.y, width: self.width, height: newValue)
        }
    }
    
    var centerX:CGFloat {
        
        get{
            
            return self.x + self.width/2
            
        }set{
            
            self.frame = CGRect.init(x:newValue - self.width/2 , y: self.y, width: self.width, height: self.height)
        }
        
    }
    
    var centerY:CGFloat {
        
        get{
            
            return self.y + self.height/2
            
        }set{
            
            self.frame = CGRect.init(x:self.x , y: newValue - self.height/2, width: self.width, height: self.height)
        }
        
    }
}


extension UIScrollView {
    
    var inset:UIEdgeInsets {
        
        get{
            
            if #available(iOS 11.0, *) {
                return self.adjustedContentInset
            } else {
                return self.contentInset
            }
            
        }
        
    }
    
    var insetTop:CGFloat {
        
        get{
            
            return self.inset.top
            
        }set {
            
            var inset = self.contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                
                inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
                
            }
            self.contentInset = inset
            
        }
        
    }
    
    
    var insetBottom:CGFloat {
        
        get {
            
            return self.inset.bottom
            
        }set {
            
            var inset = self.contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                
                inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
                
            }
            self.contentInset  = inset
        }
        
    }
    
    var insetLeft:CGFloat {
        
        get {
            
            return self.inset.left
            
        }set {
            
            var inset = self.contentInset
            inset.left = newValue
            if #available(iOS 11.0, *) {
                
                inset.left -= (self.adjustedContentInset.left - self.contentInset.left)
                
            }
            self.contentInset  = inset
        }
        
    }
    
    
    var insetRight:CGFloat {
        
        get {
            
            return self.inset.right
            
        }set {
            
            var inset = self.contentInset
            inset.right = newValue
            if #available(iOS 11.0, *) {
                
                inset.right -= (self.adjustedContentInset.right - self.contentInset.right)
                
            }
            self.contentInset  = inset
        }
        
    }
    
    var offsetX:CGFloat {
        
        get {
            
            return self.contentOffset.x
            
        }set {
            
            self.contentOffset = CGPoint.init(x: newValue, y: self.offsetY)
        }
    }
    
    var offsetY:CGFloat {
        
        get {
            
            return self.contentOffset.y
            
        }set {
            
            self.contentOffset = CGPoint.init(x:self.offsetX , y: newValue)
        }
    }
    
    var contentWidth:CGFloat {
        
        get{
            return self.contentSize.width
        }set {
            self.contentSize = CGSize.init(width: newValue, height: self.contentHeight)
        }
        
    }
    
    var contentHeight:CGFloat {
        
        get{
            return self.contentSize.height
        }set {
            self.contentSize = CGSize.init(width: self.contentWidth, height: newValue)
        }
        
    }
    
}



extension String {
    
    
    func getWidthWithFont(_ font:UIFont) -> CGFloat {
        
        if self.count <= 0 {
            return 0
        }
        
        let ocString = self as NSString
        let maxSize = CGSize.init(width: 400, height: 30)
        let contentRect = ocString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        
        return contentRect.width
        
    }
    
}





