//
//  BlueView.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class BlueView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .blue
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        print("BlueView histTest")
        let result =  super.hitTest(point, with: event) // 里面执行了point
       // let result =  self.ccHitTest(point, with: event)
        return result
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        print("BlueView point inside")
        return super.point(inside: point, with: event)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("BlueView touchesBegan")
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("BlueView touchesMoved")
        super.touchesMoved(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("BlueView touchesEnded")
        super.touchesEnded(touches, with: event)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("BlueView touchesCancelled")
       super.touchesCancelled(touches, with: event)
    }
}
