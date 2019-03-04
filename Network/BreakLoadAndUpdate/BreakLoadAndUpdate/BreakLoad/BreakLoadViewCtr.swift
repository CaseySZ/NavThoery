//
//  BreakLoadViewCtr.swift
//  BreakLoadAndUpdate
//
//  Created by Casey on 04/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

/*
 断点下载原理
 断点下载优化
 系统的文件下载缺陷
 */


import UIKit

class BreakLoadViewCtr: UIViewController, URLSessionDataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.title = "breakLoad"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "load", style: .plain, target: self, action: #selector(startLoadImage))
        
    }
    
    @objc func startLoadImage()  {
     
        
        if  let imageUrl = URL.init(string: http_BigImage) {
        
            var request = URLRequest.init(url: imageUrl)
            request.httpMethod = "GET"
            
            //  1 查找该网络任务是否存在 之前有相关未执行完的
            if let fileSize = searchTashByFileName(fileName: "Test.png") {
                
                request.setValue(String.init(format: "bytes=%d-", fileSize), forHTTPHeaderField: "Range")
                
            }
            
            
            let session = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
            let task = session.dataTask(with: request)
            task.resume()
            
        }
        
        
        
    }
    
    var filePath:String = ""
    func searchTashByFileName(fileName:String) -> Int? {
        
        let tempPath =  NSTemporaryDirectory()
        filePath = String.init(format: "%@%@", tempPath, fileName)
        
        if FileManager.default.fileExists(atPath: filePath) {
            
            do {
                
                let preFileData = try Data.init(contentsOf: URL.init(fileURLWithPath: filePath))
                fileData.append(preFileData)
                
                let fileInfo =  try FileManager.default.attributesOfItem(atPath: filePath)
                let fileSize =  fileInfo[FileAttributeKey.size] as? Int
                return fileSize
                
            }catch {
            
    
            }
            
        }
        return nil
    }
    
    
    // 1 响应
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        completionHandler(.allow)
        
    }
    
    // 2 数据
    var fileData:Data = Data.init()
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
        do {
            fileData.append(data)
            try fileData.write(to: URL.init(fileURLWithPath: filePath))
        }catch {
            
        }
    }
    
    // 3 完成
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let targetDocument = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let targetFilePath = String.init(format: "%@/%@", targetDocument, "test.png")
            do {
                try FileManager.default.moveItem(atPath: filePath, toPath: targetFilePath)
            }catch {
                
            }
        }
        
    }
    
    
    

}
