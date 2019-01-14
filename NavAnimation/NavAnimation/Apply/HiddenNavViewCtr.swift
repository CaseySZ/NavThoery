//
//  HiddenNavViewCtr.swift
//  NavAnimation
//
//  Created by Casey on 14/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class HiddenNavViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HiddenNav"
        
        self.view.backgroundColor = .white
        
       // self.navigationController?.isNavigationBarHidden = true
       // self.navigationController?.isNavigationBarHidden = false
        
       // self.navigationController?.navigationBar.isHidden = true
      //  self.navigationController?.navigationBar.isHidden = false
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.navigationController?.pushViewController(ThreeViewCtr(), animated: true)
        
    }
    
    
   

}
