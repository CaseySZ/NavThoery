//
//  ButtonViewCtr.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class ButtonViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Button"
        self.view.backgroundColor = .white
        
        let button = CCButton.init(frame: CGRect.init(x: 100, y: 100, width: 100, height: 100))
        //button.addTarget(self, action: #selector(buttonPress), for: .touchUpInside)
        button.addTarget(self, action: #selector(buttonPress), for: .touchDown)
        button.setTitle("press", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        self.view.addSubview(button)
    
    }
    

    @objc func buttonPress() {
        
        print("buttonPress")
    }
   

}
