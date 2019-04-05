//
//  ViewController.swift
//  Refresh
//
//  Created by Casey on 05/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.navigationController?.pushViewController(BunisessViewCtr(), animated: true)
        
    }

}

