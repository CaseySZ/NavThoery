//
//  CCScrollview.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class CCScrollview: UIScrollView {

   
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
    
        let rect = CGRect.init(x: -50, y: self.bounds.origin.y, width: self.bounds.width+100, height: self.bounds.height)
        if rect.contains(point) {
            return self
        }
        
        return super.hitTest(point, with: event)
        
    }
    

}
