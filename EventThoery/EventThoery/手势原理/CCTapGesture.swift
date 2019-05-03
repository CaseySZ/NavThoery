//
//  CCTapGesture.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class CCTapGesture: UITapGestureRecognizer {
    
    
 
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {

        print("CCTapGesture touchesBegan")
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        
        print("CCTapGesture touchesMoved")
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        
        print("CCTapGesture touchesEnded")
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        
        print("CCTapGesture touchesCancelled")
        super.touchesCancelled(touches, with: event)
    }
    
    
}
