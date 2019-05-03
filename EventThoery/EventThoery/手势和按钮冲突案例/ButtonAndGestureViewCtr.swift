//
//  ButtonAndTapViewCtr.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class ButtonAndGestureViewCtr: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Button And Gesture"
        self.view.backgroundColor = .white
        
        let button = UIButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        button.setTitle("press", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = .black
        self.view.addSubview(button)
        
        
        let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureEvent(_:)))
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
        
        // 最佳响应view 是 button， 所以点击button不会响应这个
        let tapGestre = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureEvent))
        self.view.addGestureRecognizer(tapGestre)
        
    }
    
    @objc func tapGestureEvent() {
        
        print("tapGestureEvent")
    }
    
    
    @objc func panGestureEvent(_ gesture: UIPanGestureRecognizer) {
        
        
        print("panGestureEvent")
        
    }
    
    
    @objc func buttonPress() {
        
        print("buttonPress")
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view!.isKind(of: UIButton.self) {
            
            return false
        }
        
        return true
    }
    

}
