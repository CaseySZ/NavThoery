//
//  YellowView.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class YellowView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .yellow
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        print("YellowView histTest")
        return super.hitTest(point, with: event)
        
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        print("YellowView point inside")
        return super.point(inside: point, with: event)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("YellowView touchesBegan")
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("YellowView touchesMoved")
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("YellowView touchesEnded")
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print("YellowView touchesCancelled")
        
    }
    
}
