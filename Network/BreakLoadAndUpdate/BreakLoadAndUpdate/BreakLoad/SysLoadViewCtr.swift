//
//  SysLoadViewCtr.swift
//  BreakLoadAndUpdate
//
//  Created by Casey on 04/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class SysLoadViewCtr: UIViewController, URLSessionDataDelegate, URLSessionDownloadDelegate {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "SysLoad"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "load", style: .plain, target: self, action: #selector(startLoadImage))
        
    }
    
    
    @objc func startLoadImage()  {
        
        
        if  let imageUrl = URL.init(string: http_BigImage) {
            
            var request = URLRequest.init(url: imageUrl)
            request.httpMethod = "GET"
            let session = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
            let task = session.downloadTask(with: request)
            task.resume()
            
        }
        
        
        
    }

    // 1 响应
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        completionHandler(.allow)
        
    }
    
    
    
    // 2 进度
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        print("didWriteData: \(bytesWritten), totalBytesWritten:\(totalBytesWritten), totalBytesExpectedToWrite:\(totalBytesExpectedToWrite)")
    }
    
    
    // 完成
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        print(location)
        
        if let targetDocument = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            
            let targetFilePath = String.init(format: "%@/%@", targetDocument, "sysTest.png")
            do{
                
                try FileManager.default.moveItem(at: location, to: URL.init(fileURLWithPath: targetFilePath))
                
            }catch{
                
            }
        }
        
    }
}
