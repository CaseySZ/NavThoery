//
//  GestureCoexistViewCtr.swift
//  EventThoery
//
//  Created by Casey on 03/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

/*
 优先响应的是gestureTwo，可以在代理中，处理gesture共存问题
 各种各样的需求都存在，这里只是简化了代码，当复杂的业务中实现的时候，遇到共存问题，知道通过何种方式解决
 */
class GestureCoexistViewCtr: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "coexist"
        self.view.backgroundColor = .white
        
        
        let redView = UIView.init(frame: CGRect.init(x: 50, y: 130, width: 300, height: 300))
        redView.backgroundColor = .red
        self.view.addSubview(redView)
        
        
        let yellowView = UIView.init(frame: CGRect.init(x: 50, y: 150, width: 150, height: 150))
        yellowView.backgroundColor = .yellow
        self.view.addSubview(yellowView)
        
        let gestureOne = UIPanGestureRecognizer.init(target: self, action:#selector(oneAction))
        redView.addGestureRecognizer(gestureOne)
        
        
        let gestureTwo = UIPanGestureRecognizer.init(target: self, action:#selector(twoAction))
        gestureTwo.delegate = self
        yellowView.addGestureRecognizer(gestureTwo)
        

    }
    
    @objc func oneAction()  {
        
        print("oneAction")
    }
    
    @objc func twoAction()  {
        
        print("twoAction")
    }


    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        
        return true
        
    }
    
}
