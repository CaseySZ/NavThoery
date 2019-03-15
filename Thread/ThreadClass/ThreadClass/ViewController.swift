//
//  ViewController.swift
//  BreakLoadAndUpdate
//
//  Created by Casey on 04/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    //MARK: tableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        if indexPath.row == 0 {
            cell?.textLabel?.text = "NSThread"
        }
        if indexPath.row == 1 {
            cell?.textLabel?.text = "Operation base"
        }
        if indexPath.row == 2 {
            cell?.textLabel?.text = "Operation complex"
        }
        if indexPath.row == 3 {
            cell?.textLabel?.text = "GCD"
        }
        if indexPath.row == 4 {
            cell?.textLabel?.text = "Lock"
        }
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.row == 0 {
            
            self.navigationController?.pushViewController(ThreadViewCtr(), animated: true)
            
        }else if indexPath.row == 1 {
            
            self.navigationController?.pushViewController(OperationBaseViewCtr(), animated: true)
            
        }else if indexPath.row == 2 {
            
            self.navigationController?.pushViewController(OperationViewCtr(), animated: true)
            
        }else if indexPath.row == 3{
            
            self.navigationController?.pushViewController(GCDViewCtr(), animated: true)
            
        }else if indexPath.row == 4{
            
            self.navigationController?.pushViewController(LockViewCtr(), animated: true)
        }
        
        
        
        
    }

    

}

