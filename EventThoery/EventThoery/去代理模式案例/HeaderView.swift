//
//  HeaderView.swift
//  EventThoery
//
//  Created by Casey on 03/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
/*
 
这个只是一个简单的，如果这个头部控件比较复杂,很多交互需要处理，如何可以简洁的处理逻辑代码

 
去代理
控制器->tableview->headview
 
 代理
 控制器->tableview->headview->delegate->控制器

 有些情况该代理的还是要代理出去，依情况而定， 多一种方式处理
 
 */

class HeaderView: UIView {

   
    @IBAction func buttonPress() {
        
        
        self.nearNav()?.pushViewController(UIViewController(), animated: true)
        
    }

}
