//
//  ConflictViewCtr.swift
//  EventThoery
//
//  Created by Casey on 03/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class ConflictViewCtr: BaseViewController, UITableViewDelegate, UITableViewDataSource{

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.title = "Gesture Conflict"
        
        
    }
    
   

    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if let className = NSClassFromString("UITableViewCellContentView") {
            if touch.view!.isKind(of: className) {
                return false
            }
        }

        return true
    }
    
    //MARK: tableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if  cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = String(indexPath.row)
        return  cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        print("tableView didSelectRowAt")
    }
   

}
