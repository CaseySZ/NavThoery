//
//  FDBaseTable.swift
//  SQLSwift
//
//  Created by Casey on 25/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import SQLite3

@objc protocol FDBaseTableProtocol {
    
    func dataBaseName() -> String
    
    func tableName() -> String
    
    func columnValue() -> Dictionary<String, String>
    
    //@objc optional func recordClass<T>() -> T
    
    
}


class FDBaseTable: NSObject {
    
    
    var dataBase: DataBase?
    override init() {
        super.init()
        
        if self.conforms(to: FDBaseTableProtocol.self) {
            
            if let tableProcol = self as? FDBaseTableProtocol {
                
                let dataBaseName = tableProcol.dataBaseName()
                let tableName = tableProcol.tableName()
                let columnValue = tableProcol.columnValue()
                
                dataBase = DataBasePool.shareInstance.file(dataBaseName)
                createTable(tableName, columnValue)
            
            }
            
            
            
        }else {
            
            let exception = NSException.init(name: NSExceptionName.init("FDBaseTableProtocol"), reason: "no conforms", userInfo: nil)
            exception.raise()
        }
        
    }
    
    
    private func createTable(_ tableName:String, _ columnValue:Dictionary<String, String>)  {
        
        var columnPro = String.init()
        for (key, value) in columnValue {
            
            let pro = String.init(format: "%@ %@", key, value)
            if columnPro.count > 0 {
                columnPro.append(",")
            }
            columnPro.append(pro)
        }
        
        let sqlStr = String.init(format: "create table if not exists %@ (%@)", tableName, columnPro)
        
        let sqlExe =  SQLExecute.init(sqlFile: dataBase?.sqlFile, sqlCommand: sqlStr)
        
        sqlExe.excuteWriteOperation()
        
    }
    
    
    func create(columnInfo:Dictionary<String, String>)  {
        
        
        
    }
    
    
}







