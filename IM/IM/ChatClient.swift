//
//  ChatClient.swift
//  IM
//
//  Created by Casey on 15/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit
import Network

enum SocketError: Error {
    case fdBuildFail
    case connectFail
    
}

fileprivate var fd:Int32 = 0
class ChatClient: NSObject {

    
    
    
    // nc -l 9000
    func connectServer() throws {
        
        // 1
        fd =  socket(AF_INET, SOCK_STREAM, 0)
       
        if fd == -1 {
            print("socket fail")
            throw SocketError.fdBuildFail
        }
        
        // 2 nc -l port
        
        var addr = sockaddr_in.init()
        addr.sin_family =  sa_family_t(AF_INET)
        addr.sin_port = in_port_t(CFSwapInt16HostToBig(9233))
        addr.sin_addr.s_addr = inet_addr("10.71.66.80")
        let sizeAddr = MemoryLayout.size(ofValue: addr)
        
        var r:Int32 = 0
        // withUnsafePointer把对象转化成指针，withMemoryRebound修改类型
        withUnsafePointer(to: &addr) { ptr in
            
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1, { ptrSockaddr  in
                
                r = connect(fd, ptrSockaddr, socklen_t(sizeAddr))
               
            })
        }
        
        if r == -1 {
            print("connect fail")
            throw SocketError.connectFail
        }else {
            print("connect success")
        }

        
        sendData("One")
        
        Thread.detachNewThreadSelector(#selector(threadRecvData), toTarget: self, with: nil)
        
    }
    
    
    func sendData(_ data:String)  {
        
        if  data.count <= 0 {
            return
        }
        
    
        if #available(iOS 10.0, *) {
            
            Thread.detachNewThread {
                
                let r = send(fd, UnsafeRawPointer(data), data.count, 0)
               // let r = send(fd, data.cString(using: String.Encoding.utf8), data.count, 0)
                if r < 0 {
                    print("send error")
                }else {
                   
                }
                
                
            }
            
        } else {
           
        }
        
    }
    
    @objc func threadRecvData() {
    
        
        var buffer = Array<CChar>.init(repeating: 0, count: 16)
        
        while true {
            
            
            let lenght = recv(fd, &buffer, 16, 0)
            if lenght <= 0 {
                print("断开了:\(lenght)")
                break
                
            }else {
                
                let data = Data(bytes: &buffer, count: lenght)
               // let data = Data(bytes: buffer[0...lenght])
              
                if let str =  String.init(data: data, encoding: String.Encoding.utf8){
                    print("来自服务端的数据:\(str)")
                }
                
            }
            
            
        }
        
    }
    
}
