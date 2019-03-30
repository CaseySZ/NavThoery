//
//  FDBaseTable.swift
//  SQLSwift
//
//  Created by Casey on 25/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import SQLite3

protocol FDBaseTableProtocol {
    
    func dataBaseName() -> String
    
    func tableName() -> String
    
    func columnValue() -> Dictionary<String, String>
    
    
    
}


class FDBaseTable<T:Codable> {
    
    
    var dataBase: DataBase?
    private var _tableName:String = ""
    init?() throws{
        
     
        if let tableProcol = self as? FDBaseTableProtocol {
            
            let dataBaseName = tableProcol.dataBaseName()
            let columnValue = tableProcol.columnValue()
            _tableName = tableProcol.tableName()
            
            dataBase = DataBasePool.shareInstance.file(dataBaseName)
            
            try createTable(_tableName, columnValue)
            

        }else {
            
            throw TableError.noConformsFDBaseTableProtocolFail
            
        }
        
    }
    
    
    private func createTable(_ tableName:String, _ columnValue:Dictionary<String, String>)  throws{
        
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
        
        return try sqlExe.excuteWriteOperation()
  
    }
    
    
    func insert(columnInfo:Dictionary<String, String>) throws{
        
        var columnPro = String.init()
        var keyPro = String.init()
        for (key, value) in columnInfo {
            
            if keyPro.count > 0 {
                keyPro.append(",")
                columnPro.append(",")
            }
            
            keyPro.append(key)
          //  columnPro.append(String.init(format: "'%@'", value))
            columnPro.append(String.init(format: "%@", value))
        }
        
        let sqlStr = String.init(format: "insert into %@ (%@) values (%@)", _tableName, keyPro, columnPro)
        
        let sqlExe =  SQLExecute.init(sqlFile: dataBase?.sqlFile, sqlCommand: sqlStr)
        
        
            
        try sqlExe.excuteWriteOperation()
        
    }
    
    func insert(_ recode:T) throws {
        
        
        
        
    }
    
    
    func queryAll() throws -> Array<Dictionary<String, Any>>? {
        
        let sqlStr = String.init(format: "select *from %@", _tableName)
        
        let sqlExe =  SQLExecute.init(sqlFile: dataBase?.sqlFile, sqlCommand: sqlStr)
        
        return try sqlExe.excuteReadOperation()
        
    }
    
    func query() throws -> [T]? {
        
        let sqlStr = String.init(format: "select *from %@", _tableName)
        
        let sqlExe =  SQLExecute.init(sqlFile: dataBase?.sqlFile, sqlCommand: sqlStr)
        
        if let result =  try sqlExe.excuteReadOperation(){
            
    
            let data = try JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
            let model =  try JSONDecoder().decode([T].self, from: data)
            
            return model
        
            
        }
        
        return nil
    }
    
    
    func update(_ newValue:Dictionary<String, Any>, _ condition:String, _ conditionKey:String) throws {
        
        let sqlStr = String.init(format: "update %@ set name = '' where %@ = '%@' ", _tableName, condition, conditionKey)
        
        let sqlExe =  SQLExecute.init(sqlFile: dataBase?.sqlFile, sqlCommand: sqlStr)
        
        return try sqlExe.excuteWriteOperation()
        
    }
    
}







