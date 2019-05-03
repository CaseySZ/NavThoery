//
//  CCButton.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

/*
 Button的点击状态，touchUpInside， touchUpOutside 等是通过touch来处理的
 
 */

class CCButton: UIButton {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        print("CCButton histTest")
        return super.hitTest(point, with: event)
        
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        print("CCButton point inside")
        return super.point(inside: point, with: event)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        print("CCButton touchesBegan")
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("CCButton touchesMoved")
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("CCButton touchesEnded")
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("CCButton touchesCancelled")
        super.touchesCancelled(touches, with: event)
    }
}
