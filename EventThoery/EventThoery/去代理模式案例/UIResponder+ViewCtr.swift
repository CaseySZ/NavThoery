//
//  UIResponder+ViewCtr.swift
//  EventThoery
//
//  Created by Casey on 03/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {
    
    
    func nearNav() -> UINavigationController? {
        
        if self.isKind(of: UIWindow.self) {
            
            return nil
        }
        
        if let tabbarController = self as? UITabBarController {
            
            if let nav = tabbarController.selectedViewController?.navigationController {
                return nav
            }
            
            if let nav = tabbarController.selectedViewController as? UINavigationController {
                return nav
            }
            
        }
        
        if let nav = self as? UINavigationController {
            return nav
        }
        
        if let viewCtr = self as? UIViewController {
            
            if let nav = viewCtr.navigationController {
                return nav
            }
        }
        
        if let nextRes =  self.next {
            
            return nextRes.nearNav()
            
        }
        return nil
    }
    
}
