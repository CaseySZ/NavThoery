//
//  ViewController.swift
//  IM
//
//  Created by Casey on 15/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

// https://blog.csdn.net/zkh90644/article/details/52819002
class ViewController: UIViewController {

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    
        
    }
    
    
    
    @IBAction func serverBuild() {
        
        
        if #available(iOS 10.0, *) {
            
            Thread.detachNewThread {
                
                ChatService().buildServer()
            }
            
        } else {
           
        }
       
        
    }
    
    @IBAction func client() {
        
    
        self.navigationController?.pushViewController(ClientViewCtr(), animated: true)
        
    }
    
    
    
}

