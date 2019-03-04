//
//  UpdateFileViewCtr.swift
//  BreakLoadAndUpdate
//
//  Created by Casey on 04/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit

class UpdateFileViewCtr: UIViewController, URLSessionTaskDelegate, URLSessionDataDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.title = "update"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "update", style: .plain, target: self, action: #selector(updateFile))
    
    }
    
    
    @objc func updateFile()  {
        
        
        let url = URL.init(string: http_UpdateFile)!
        
        var request = URLRequest.init(url: url)
        
        request.httpMethod = "POST"
        
        // 1 请求头设置
        // 1.1 Content-Type 设置分界线
        let  boundarySign = "*********"
        
        
        request.setValue(String.init(format: "multipart/form-data;charset=utf-8;boundary=%@", boundarySign), forHTTPHeaderField: "Content-Type")
        
        
        let image = UIImage.init(named: "1.png")
        let fileData =  image!.pngData()!
        
        let bodyData = updateBodyData(fileData: fileData, boundary: boundarySign)
        
        
        request.httpBody = bodyData

        let session = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request)
        task.resume()
        
        
    }
    
    
    
    func updateBodyData(fileData:Data,  boundary:String) -> Data {
        
        
        var bodyData = Data()
        
        let startBoundary = String.init(format: "--%@\r\n", boundary)
        let endBoundary = String.init(format: "\r\n--%@", boundary)
        
        
        /*
         fileKey服务器取得字段
         fileName 服务器存的文件名
         */
        var bodyProStr = String()
        let contentType = "image/png"
        let fileKey = "image"
        let fileName = "testAd1.png"
        bodyProStr.append(String.init(format:"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\" \r\n", fileKey, fileName))
        bodyProStr.append(String.init(format: "Content-Type: %@\r\n", contentType))
        bodyProStr.append("\r\n")
        
        
        // 表 开始标志
        bodyData.append(startBoundary.data(using: String.Encoding.utf8)!)
        
        // 表属性 参数
        bodyData.append(bodyProStr.data(using: String.Encoding.utf8)!)
        
        // 表数据（图片数据）
        bodyData.append(fileData)
        
        
        // 表结束标志
        
        bodyData.append(endBoundary.data(using: String.Encoding.utf8)!)
        
        return bodyData
        
    }
    
    
    
    // 1 响应
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        
        completionHandler(.allow)
        
    }
    
    // 2 进度
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData : Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        
        print("didSendBodyData:%d, totalBytesSent: %d, totalBytesExpectedToSend:%d", didSendBodyData, totalBytesSent, totalBytesExpectedToSend)
    }
    
    // 3 服务器数据
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
       
        do {
            
            // let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
           // print(result)
            print("success")
        }catch {
            
            print(error)
            
        }
    }
    
    // 4 完成
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
       
        
    }

}
