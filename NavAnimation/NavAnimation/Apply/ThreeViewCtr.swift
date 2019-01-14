//
//  ThreeViewCtr.swift
//  NavAnimation
//
//  Created by Casey on 14/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class ThreeViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "three"
        self.view.backgroundColor = .blue
       // self.navigationController?.navigationBar.isHidden = false
       // self.navigationController?.isNavigationBarHidden = false
        if self.navigationController?.navigationBar.superview == nil {
            
            self.navigationController?.isNavigationBarHidden = false
            
        }else {
            self.navigationController?.navigationBar.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
