//
//  ViewController.swift
//  NavAnimation
//
//  Created by Casey on 11/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let nav = AnimationNavigationCtr.init(rootViewController: NavAdvanceAnimaViewCtr())
        
        self.present(nav, animated: true, completion: nil)
    
    }
}

