//
//  SQLFrameViewCtr.swift
//  SQLSwift
//
//  Created by Casey on 25/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class SQLFrameViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileItem = UIBarButtonItem.init(title: "file", style: .plain, target: self, action: #selector(sqlCreateDBFileAndOpen))
        let tableItem = UIBarButtonItem.init(title: "table", style: .plain, target: self, action: #selector(sqlCreateTable))
        let insertItem = UIBarButtonItem.init(title: "insert", style: .plain, target: self, action: #selector(insertData))
        let readItem = UIBarButtonItem.init(title: "read", style: .plain, target: self, action: #selector(readSqlData))
        
        self.navigationItem.rightBarButtonItems = [fileItem, tableItem, insertItem, readItem];
    }
    
    let studentTable = StudentTable()
    @objc func sqlCreateDBFileAndOpen()  {
       
        
        
       
    }
    
   
    @objc func sqlCreateTable()  {
        
        
      
        
    }
    
    
    @objc func insertData()  {
        
        
        
    }
    
    
    @objc func readSqlData() {
        
        
        
        
        
    }
    

}



