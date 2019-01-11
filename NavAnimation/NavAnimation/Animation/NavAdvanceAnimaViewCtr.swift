//
//  NavAdvanceAnimaViewCtr.swift
//  NavAnimation
//
//  Created by Casey on 11/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class NavAdvanceAnimaViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "animation"
        
        self.view.backgroundColor = .red
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "back", style: .plain, target: self, action: #selector(backAction))
    }
    
    
    @objc func backAction() {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        self.navigationController?.pushViewController(SecondViewCtr(), animated: true)
        
    }

   
}
