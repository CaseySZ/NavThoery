//
//  BunisessViewCtr.swift
//  Refresh
//
//  Created by Casey on 05/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class BunisessViewCtr: UIViewController, UITableViewDelegate, UITableViewDataSource{

    
    @IBOutlet var _tableView: UITableView?
    var dataArr = Array<String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        if #available(iOS 11.0, *) {
            _tableView?.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
       
        
        
        for index in 0...10 {
            
            dataArr.append(String(index))
            
        }
        
        
        weak var weakself = self
        _tableView?.refreshFooter = RefreshFooterDefaultView.footerWithRefreshBlock({
            
            print("footer refresh")
            weakself?.perform(#selector(weakself?.footerLoadData), with: nil, afterDelay: 3)
            
        })
        
        _tableView?.refreshHeader = AliRefreshHeaderView.headerWithRefreshBlock({
            
            print("header refresh")
            weakself?.perform(#selector(weakself?.headerLoadData), with: nil, afterDelay: 5)
        })
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        _tableView?.y = 50
    }
    
    @objc func headerLoadData()  {
        
        dataArr.append(String(dataArr.count))
        _tableView?.reloadData()
        _tableView?.refreshHeader?.endRefreshing()
    }
    
    @objc func footerLoadData()  {
        
        dataArr.append(String(dataArr.count))
        _tableView?.reloadData()
        _tableView?.refreshFooter?.endRefreshing()
    }
    
    
    //MARK: tableview delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = dataArr[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
        
    }
    
    
    
    

    

}
