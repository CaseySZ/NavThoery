//
//  ViewController.swift
//  AudioPlay
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.navigationController?.pushViewController(AudioPlayerViewCtr(), animated: true)
        
       // self.navigationController?.pushViewController(AudioNetPlayerViewCtr(), animated: true)
    }
}

