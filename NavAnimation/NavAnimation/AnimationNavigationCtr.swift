//
//  AnimationNavigationCtr.swift
//  NavAnimation
//
//  Created by Casey on 11/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

import UIKit

class AnimationNavigationCtr: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.delegate = self
        
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        if operation == .pop {
            return NavAnimation()
        }
        
        return nil
    }
    
    


}
