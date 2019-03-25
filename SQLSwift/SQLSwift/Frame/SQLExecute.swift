//
//  SQLExecute.swift
//  SQLSwift
//
//  Created by Casey on 25/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import SQLite3

class SQLExecute {
    
    var _sqlFile:SQLFileHandle?
    var _sqlCommand:String
    init(sqlFile:SQLFileHandle?, sqlCommand:String) {
        
        _sqlFile = sqlFile
        _sqlCommand = sqlCommand
    }
    
    func excuteReadOperation() -> Array<Dictionary<String, Any>>? {
        
        
        
        if let sqlHandle = _sqlFile {
            
            var handleStmt: OpaquePointer? = nil
            let sqlStr = String.init(format: "select *from firstT")
            
            let status = sqlite3_prepare_v2(sqlHandle, sqlStr, -1, &handleStmt, nil)
            if status != SQLITE_OK {
                
                print("sqlError: sqlite_prepare Fail")
                sqlite3_finalize(handleStmt)
                return nil
            }
            
            var resultArr = Array<Dictionary<String, Any>>()
            while sqlite3_step(handleStmt) == SQLITE_ROW {
                
                if let record =  handleStmt?.getSqlValues() {
                    resultArr.append(record)
                }
            }
            sqlite3_finalize(handleStmt)
            
            return resultArr
        }
        
        return nil
        
    }
    
    
    func excuteWriteOperation()  {
        
        if let sqlHandle = _sqlFile {
            
            var handleStmt: OpaquePointer? = nil
            let sqlStr = String.init(format: "select *from firstT")
            
            var status = sqlite3_prepare_v2(sqlHandle, sqlStr, -1, &handleStmt, nil)
            if status != SQLITE_OK {
                
                print("sqlError: sqlite_prepare Fail")
                sqlite3_finalize(handleStmt)
                return
            }
            
            status = sqlite3_step(handleStmt)
            if status != SQLITE_DONE  {
                
                print("sqlError: sqlite3_step Fail")
            }
            
            sqlite3_finalize(handleStmt)
            
        }
        
    }
    
}

fileprivate extension OpaquePointer {
    
    // 获取数据： 从_handleStmt提取
    func getSqlValues() -> Dictionary<String, Any> {
        
        let columnCount = Int32(sqlite3_column_count(self))
        
        var backInfo = Dictionary<String, Any>()
        for index in 0...columnCount-1 {
            
            let columnName = String.init(cString: sqlite3_column_name(self, index))
            if let valuePoint =  sqlite3_column_text(self, index) {
                
                let valueString = String.init(cString: valuePoint)
                backInfo[columnName] = valueString
                
            }
        }
        
        return backInfo
    }
    
}
