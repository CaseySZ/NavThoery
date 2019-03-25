//
//  DataBaseFilePool.swift
//  SQLSwift
//
//  Created by Casey on 25/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//
import UIKit
import SQLite3

typealias SQLFileHandle = OpaquePointer


class DataBasePool {
    
    static let shareInstance = DataBasePool()
    
    private var filePoolInfo = Dictionary<String, DataBaseFile>()
    
    func file(_ fileName:String) -> DataBaseFile {
        
        if let dateBaseFile = filePoolInfo[fileName] {
            
            return dateBaseFile
            
        }else {
            
            let dataBaseFile = DataBaseFile.init(fileName)
            filePoolInfo[fileName] = dataBaseFile;
            return dataBaseFile
            
        }
    }
    
    func closeDataBaseFile(_ fileName:String)  {
        
        if let dateBaseFile = filePoolInfo[fileName] {
            
            dateBaseFile.closeDBFile()
            filePoolInfo[fileName] = nil
        }
        
    }
    
    
    func closeAllDataBaseFile()  {
        
        for  dataBaseFile in filePoolInfo.values {
            dataBaseFile.closeDBFile()
        }
        filePoolInfo.removeAll()
        
    }
    
}


class DataBase  {
    
    
    private var _fileName: String
    var sqlFile: SQLFileHandle? = nil
    init(_ fileName: String) {
        _fileName = fileName
        sqlFile = createDBFileAndOpen()
    }
    
    private func createDBFileAndOpen() -> SQLFileHandle? {
        
        
        
        if let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let dbFilePath = documentPath.appendingFormat("/\(_fileName)")
            print(dbFilePath)
            
            var handle: OpaquePointer? = nil
            let status =  sqlite3_open_v2(dbFilePath, &handle, SQLITE_OPEN_CREATE | SQLITE_OPEN_READWRITE | SQLITE_OPEN_FULLMUTEX, nil)
            
            if status != SQLITE_OK {
                
                print("sqlError: sqlite_open Fail")
                return nil
            }
            
            return handle
        }
        
        return nil
    }
    
    
    
    func closeDBFile()  {
        
        sqlite3_close_v2(sqlFile)
    }
    
}
