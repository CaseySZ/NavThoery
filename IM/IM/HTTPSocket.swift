//
//  HTTPSocket.swift
//  IM
//
//  Created by sy on 2019/4/19.
//  Copyright © 2019年 nb. All rights reserved.
//

import UIKit

fileprivate var fd:Int32 = 0

enum HTTMethod {
    case GET
    case POST
    
}

class HTTPSocket: NSObject {
    
    func startHttp(_ method:HTTMethod)  {
        
        fd =  socket(AF_INET, SOCK_STREAM, 0)
        
        if fd == -1 {
            print("socket fail")
            return
        }
        
        var addr = sockaddr_in.init()
        addr.sin_family =  sa_family_t(AF_INET)
        addr.sin_port = in_port_t(CFSwapInt16HostToBig(80))
        addr.sin_addr.s_addr = inet_addr("121.41.96.64")
        
        let sizeAddr = MemoryLayout.size(ofValue: addr)
        
        var r:Int32 = 0
    
        withUnsafePointer(to: &addr) { ptr in
            
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1, { ptrSockaddr  in
                
                r = connect(fd, ptrSockaddr, socklen_t(sizeAddr))
                
            })
        }
        
        if r == -1 {
            print("connect fail")
            return
        }else {
            print("connect success")
        }
        
        // 3 发送数据
        var requestStr = ""
        if method == .GET  {
            requestStr = getData()
        }else {
            requestStr = postData()
        }
     
        
        sendData(requestStr)
        
        // 4 接收数据
        Thread.detachNewThreadSelector(#selector(threadRecvData), toTarget: self, with: nil)
        
    }
    
    func getData() -> String {
        
        var requestStr = String.init()
        requestStr.append("GET /center/front/app/util/updateVersions?versions_id=1&system_type=1 HTTP/1.1\r\n")
        
        requestStr.append("Host: svr.tuliu.com\r\n")
        requestStr.append("Connection: keep-alive\r\n")
        requestStr.append("\r\n")
        
        return requestStr
    }
    
    
    func postData() -> String {
        
        
        var requestStr = String.init()
        requestStr.append("POST /center/front/app/util/updateVersions HTTP/1.1\r\n")
        
        requestStr.append("Host: svr.tuliu.com\r\n")
        requestStr.append("Connection: keep-alive\r\n")
        requestStr.append("Content-Type: application/x-www-form-urlencoded\r\n")
        
        requestStr.append("Content-Length: 27\r\n")
        
        requestStr.append("\r\n")
        
        requestStr.append("versions_id=1&system_type=1")
        
        requestStr.append("\r\n")
        
        return requestStr
        
    }
    
    
    func sendData(_ requestStr:String)  {
        
        if  requestStr.count <= 0 {
            return
        }
        
        var data = requestStr.data(using: .utf8)! as NSData
        let r = send(fd, data.bytes, data.length, 0)
        
        // let r = send(fd, data.cString(using: String.Encoding.utf8), data.count, 0)
        if r < 0 {
            print("send error")
        }else {
            print("send success")
        }

    
        
    }
    
    @objc func threadRecvData() {
        
        
        var buffer = Array<CChar>.init(repeating: 0, count: 1024)
        
        while true {
            
            /*
             接收数据
           
             */
            let lenght = recv(fd, &buffer, 4096, 0)
            if lenght <= 0 {
                print("断开了:\(lenght)")
                break
                
            }else {
                
                let data = Data(bytes: &buffer, count: lenght)
    
                if let str =  String.init(data: data, encoding: String.Encoding.utf8){
                    print("来自服务端的数据:\(str)")
                }
                
            }
            
            
        }
        
    }
    
}

