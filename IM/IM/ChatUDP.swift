//
//  ChatUDP.swift
//  IM
//
//  Created by sy on 2019/4/19.
//  Copyright © 2019年 nb. All rights reserved.
//

import UIKit


fileprivate var fd:Int32 = 0

fileprivate var __addr:UnsafePointer<sockaddr>?
fileprivate var __sizeAddr:socklen_t = 0

class ChatUDP: NSObject {

    
    // nc -l 9000
    func sendDataToServer() throws {
        
        /* 1 创建套接字
         */
        fd =  socket(AF_INET, SOCK_DGRAM, 0)
        
        if fd == -1 {
            print("socket fail")
            throw SocketError.fdBuildFail
        }
        
        // 2 nc -lu 127.0.0.1 8888
        
        var addr = sockaddr_in.init()
        addr.sin_family =  sa_family_t(AF_INET)
        addr.sin_port = in_port_t(CFSwapInt16HostToBig(8888))
        addr.sin_addr.s_addr = inet_addr("127.0.0.1")
        
        let sizeAddr = MemoryLayout.size(ofValue: addr)
        
        // withUnsafePointer把对象转化成指针，withMemoryRebound修改类型
        let _ = withUnsafePointer(to: &addr) { ptr in
            
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1, { ptrSockaddr  in
                
                /* 2 发送数据，指定ip和端口,只管发送，不管状态
                 */
                __addr = ptrSockaddr
                __sizeAddr = socklen_t(sizeAddr);
                
                let length = sendto(fd, "12345678", 8, 0, __addr, __sizeAddr)
                print("upd send length: \(length)")
                
            })
        }
        
        // 3 接收数据
        Thread.detachNewThreadSelector(#selector(threadRecvData), toTarget: self, with: nil)
        
    }
    
    
    @objc func threadRecvData() {
        
        
        var buffer = Array<CChar>.init(repeating: 0, count: 16)
        
        while true {
            
            /*3 接收数据
             
             */
            
            let addrPoint = UnsafeMutablePointer<sockaddr>.init(mutating: __addr!)
            var lenght = 0
            withUnsafePointer(to: &__sizeAddr) { ptr in
            
                let sizePoint = UnsafeMutablePointer<socklen_t>.init(mutating: ptr)
                lenght = recvfrom(fd, &buffer, 16, 0, addrPoint, sizePoint)
                
            }
            
            if lenght <= 0 {
                
                print("recv fail:\(lenght)")
            
            }else {
                
                let data = Data(bytes: &buffer, count: lenght)
                if let str =  String.init(data: data, encoding: String.Encoding.utf8){
                    print("来自服务端的数据:\(str)")
                }
                
            }
            
            
        }
        
    }
    
}
