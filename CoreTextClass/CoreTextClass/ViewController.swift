//
//  ViewController.swift
//  CoreTextClass
//
//  Created by Casey on 30/01/2019.
//  Copyright © 2019 n. All rights reserved.
//

import UIKit

//https://reactnative.cn/docs/state/
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        
        let textLabel =  ImageTextLabel.init(frame: CGRect.init(x: 10, y: 100, width: 200, height: 200))
        self.view.addSubview(textLabel)
        
        textLabel.backgroundColor = .yellow
        
        
        let textVLabel =  VerticalGlyphLabel.init(frame: CGRect.init(x: 10, y: 300, width: 200, height: 200))
        self.view.addSubview(textVLabel)
        textVLabel.backgroundColor = .red
        
    }
    
    
    


}

