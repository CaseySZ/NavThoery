//
//  UIViewEventTest.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    
    func ccHitTest(_ point: CGPoint, with event:UIEvent? ) ->  UIView? {
        
        
        if self.isUserInteractionEnabled == false || self.isHidden == true || self.alpha <= 0.01 {
            return nil
        }
        
        if self.point(inside: point, with: event) {
            
            
            let subViewArr = self.subviews.reversed() // 子view 倒序
            
            var suitView:UIView?
            
            for subview in subViewArr {
                
                let convertPoint = self.convert(point, to: subview)
                suitView = subview.ccHitTest(convertPoint, with: event)
                
            }
            
            if suitView == nil {
                return self
            }
            
            return suitView
        }
        
        
        return nil
    }
    
    
}

