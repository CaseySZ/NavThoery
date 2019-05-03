//
//  ViewController.swift
//  EventThoery
//
//  Created by Casey on 02/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
    }
    
    
    //MARK: tableview delegate
    let titleArr = ["Event Thoery", "Gesture", "Button", "Button And Gesture", "Scrollview", "Gesture Conflict", "Common Exist", "Frame delegate"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = titleArr[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row == 0 {
            
            self.navigationController?.pushViewController(EventTheoryVC(), animated: true)
            
        }else if indexPath.row == 1 {
            
            self.navigationController?.pushViewController(GestureViewCtr(), animated: true)
            
        }else if indexPath.row == 2 {
            
            self.navigationController?.pushViewController(ButtonViewCtr(), animated: true)
        }else if indexPath.row == 3 {
            
            self.navigationController?.pushViewController(ButtonAndGestureViewCtr(), animated: true)
        }else if indexPath.row == 4 {
            
            self.navigationController?.pushViewController(ScrollerMenuViewCtr(), animated: true)
        }else if indexPath.row == 5 {
            
            self.navigationController?.pushViewController(ConflictViewCtr(), animated: true)
        }else if indexPath.row == 6 {
            
            self.navigationController?.pushViewController(GestureCoexistViewCtr(), animated: true)
            
        }else if indexPath.row == 7 {
            
            self.navigationController?.pushViewController(FrameViewCtr(), animated: true)
            
        }
        
    }

    
}

