//
//  StudentTable.swift
//  SQLSwift
//
//  Created by Casey on 25/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class StudentTable: FDBaseTable<StudentRecord>, FDBaseTableProtocol {
    
    

    
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



class StudentRecord: Codable {
    
    
   
    var id:String?
    var name:String?
    var age:String?
    
    func test()  {
        
        
        let dic = [["id":"char", "name":"char", "age":"char"], ["id":"char", "name":"char", "age":"char"]]
        do {
            
            let data = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            let result =  try JSONDecoder().decode([StudentRecord].self, from: data)
            
            print(result)
           
            let testS = StudentRecord();
            testS.id = "11"
            testS.name = "11"
            testS.age = "11"
             //[]
            let dd =  try JSONSerialization.data(withJSONObject: testS, options: .prettyPrinted)
            print(dd);
            
            
            
            
        }catch {
            print(error)
        }
        
        
    }
    
    
}


