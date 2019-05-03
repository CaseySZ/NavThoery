//
//  BaseViewController.swift
//  EventThoery
//
//  Created by Casey on 03/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapEvent))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func tapEvent() {
        
        print("tapEvent")
    }


   

}
