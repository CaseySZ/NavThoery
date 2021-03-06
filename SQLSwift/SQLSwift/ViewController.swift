//
//  ViewController.swift
//  SQLSwift
//
//  Created by Casey on 21/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

//https://github.com/stephencelis/SQLite.swift/blob/master/Documentation/Index.md#create-table-options
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        StudentRecord().test()
    }

    
    //MARK: tableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        if indexPath.row == 0 {
            
            self.navigationController?.pushViewController(SimpleSQLViewCtr(), animated: true)
        }
        if indexPath.row == 1 {
            self.navigationController?.pushViewController(SQLFrameViewCtr(), animated: true)
        }
        
    }
    
    

}

