//
//  FrameViewCtr.swift
//  EventThoery
//
//  Created by Casey on 03/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class FrameViewCtr: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var _tableview:UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Frame"
        if let headerView =  Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as? HeaderView {
        
            headerView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)
            _tableview?.tableHeaderView = headerView
            
        }
    }

    
    
    //MARK: tableview delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 64
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = String(indexPath.row)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }


}
