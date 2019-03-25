//
//  SimpleSQLViewCtr.swift
//  SQLSwift
//
//  Created by Casey on 21/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import SQLite3




class SimpleSQLViewCtr: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        
        let fileItem = UIBarButtonItem.init(title: "file", style: .plain, target: self, action: #selector(sqlCreateDBFileAndOpen))
        let tableItem = UIBarButtonItem.init(title: "table", style: .plain, target: self, action: #selector(sqlCreateTable))
        let insertItem = UIBarButtonItem.init(title: "insert", style: .plain, target: self, action: #selector(insertData))
        let readItem = UIBarButtonItem.init(title: "read", style: .plain, target: self, action: #selector(readSqlData))
        
        self.navigationItem.rightBarButtonItems = [fileItem, tableItem, insertItem, readItem];
        
    }
    

   // static var dataBase:sqlite3_file?
    
    fileprivate var _handle: OpaquePointer? = nil
    @objc func sqlCreateDBFileAndOpen()  {
        
        if let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let dbFilePath = documentPath.appendingFormat("/data.db")
            print(dbFilePath)
            
            let status =  sqlite3_open_v2(dbFilePath, &_handle, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX, nil)
          
            if status != SQLITE_OK {
                print("sqlError: sqlite_open Fail")
            }
        }
    }
    
    var _handleStmt: OpaquePointer? = nil
    @objc func sqlCreateTable()  {
        
        
        if let sqlHandle = _handle {
        
            let sqlStr = "create table if not exists firstT(id char, name char, iphone char)"
            
            var status = sqlite3_prepare_v2(sqlHandle, sqlStr, -1, &_handleStmt, nil)
            if status != SQLITE_OK {
                
                print("sqlError: sqlite_prepare Fail")
                sqlite3_finalize(_handleStmt)
                return
            }
            
            status = sqlite3_step(_handleStmt)
            if status != SQLITE_DONE  {
        
                print("sqlError: sqlite3_step Fail")
            }
            
            sqlite3_finalize(_handleStmt)
        }
        
    }
    

    @objc func insertData()  {
        
        if let sqlHandle = _handle {
            
            let sqlStr = String.init(format: "insert into firstT values('%@', '%@', '%@')", "1", "one", "131")
            
            var status = sqlite3_prepare_v2(sqlHandle, sqlStr, -1, &_handleStmt, nil)
            if status != SQLITE_OK {
                
                print("sqlError: sqlite_prepare Fail")
                sqlite3_finalize(_handleStmt)
                return
            }
            
            status = sqlite3_step(_handleStmt)
            if status != SQLITE_DONE  {
                
                print("sqlError: sqlite3_step Fail")
            }
            
            sqlite3_finalize(_handleStmt)
        }
        
    }
    
    
    @objc func readSqlData() {
        
        
        if let sqlHandle = _handle {
            
            let sqlStr = String.init(format: "select *from firstT")
            
            let status = sqlite3_prepare_v2(sqlHandle, sqlStr, -1, &_handleStmt, nil)
            if status != SQLITE_OK {
                
                print("sqlError: sqlite_prepare Fail")
                sqlite3_finalize(_handleStmt)
                return
            }
            
            
            while sqlite3_step(_handleStmt) == SQLITE_ROW {
                
                // 获取数据： 从_handleStmt提取
                let columnCount =  Int(sqlite3_column_count(_handleStmt))
                let columnName = String.init(cString: sqlite3_column_name(_handleStmt, 0))
                
                let idPoint =  sqlite3_column_text(_handleStmt, 0)
                let namePoint = sqlite3_column_text(_handleStmt, 1)
                let phonePoint = sqlite3_column_text(_handleStmt, 2)
                //UnsafePointer<Int32>
                
                let id = String.init(cString: idPoint!)
                let name = String.init(cString: namePoint!)
                let phone = String.init(cString: phonePoint!)
                
                print("\(id), \(name), \(phone)")
                
            }
            
            
            sqlite3_finalize(_handleStmt)
        }
        
        
        
        
    }
    
    
    
}
