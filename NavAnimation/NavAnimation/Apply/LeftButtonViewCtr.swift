//
//  LeftButtonViewCtr.swift
//  NavAnimation
//
//  Created by Casey on 14/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class LeftButtonViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
       // leftButton();
        
        leftMultipleButton();
    }
    
    func leftButton()  {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(backAction))
        
    }
    
    func leftMultipleButton()  {
        
        let backItem =  UIBarButtonItem.init(title: "返回", style: .plain, target: self, action: #selector(backAction))
        let gapItem =  UIBarButtonItem.init(title: "", style: .plain, target: nil, action: nil)
        gapItem.width = 150
        
        let actionItem = UIBarButtonItem.init(title: "点击", style: .plain, target: self, action: #selector(backAction))
        
        self.navigationItem.leftBarButtonItems = [backItem, gapItem, actionItem]
        
        
    }
    

    @objc func backAction()  {
        self.navigationController?.popViewController(animated: true)
    }
   
}
