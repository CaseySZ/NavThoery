//
//  StudentTable.swift
//  SQLSwift
//
//  Created by Casey on 25/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class StudentTable: FDBaseTable, FDBaseTableProtocol {
    
    func dataBaseName() -> String {
        return "student.db"
    }
    
    func tableName() -> String {
        return "student"
    }
    
    func columnValue() -> Dictionary<String, String> {
        
        return ["id":"char", "name":"char", "age":"char"]
        
    }
    
    
}


