//
//  ClientViewCtr.swift
//  IM
//
//  Created by Casey on 17/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class ClientViewCtr: UIViewController {

    
    @IBOutlet var textField:UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "client"
       
    }

    let chatClient = ChatClient()
    @IBAction func connectServer() {
        
        do {
            
            try  chatClient.connectServer()
            
        }catch {
            
        }
        
    }
    
    @IBAction func senderData() {
    
        chatClient.sendData(textField?.text ?? "")
        
    
    }



}
