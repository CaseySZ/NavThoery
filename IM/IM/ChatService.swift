//
//  ChatService.swift
//  IM
//
//  Created by Casey on 17/04/2019.
//  Copyright © 2019 nb. All rights reserved.
//

import UIKit


var serverFd:Int32 = 0 // 服务端的描述性文件
var selectFds:fd_set = fd_set.init() // select 需要检测的fd集合
var allClientFd:fd_set = fd_set.init() // 当前所有的fd集合

var maxfd:Int32 = -1 // 最大的描述文件fd


class ChatService: NSObject {

    
    
    
    func buildServer()  {
        
        // 1 建立socket
        serverFd = socket(AF_INET, SOCK_STREAM, 0)
        if serverFd == -1 {
            print("socket fail")
            return
        }
        // nc 10.71.66.80 9233 连接
        var addr = sockaddr_in.init()
        addr.sin_family =  sa_family_t(AF_INET)
        addr.sin_port = in_port_t(CFSwapInt16HostToBig(9233))
        addr.sin_addr.s_addr = inet_addr("192.168.1.92")
        let sizeAddr = MemoryLayout.size(ofValue: addr)
        
        
        var on: Int32 = 1
        
        setsockopt(serverFd, SOL_SOCKET, SO_REUSEADDR, &on, socklen_t(MemoryLayout.size(ofValue: Int32()))) // 允许套接口和一个已在使用中的端口绑定
        
        
        var r:Int32 = 0
        // withUnsafePointer把对象转化成指针，withMemoryRebound修改类型
        withUnsafePointer(to: &addr) { ptr in
            
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1, { ptrSockaddr  in
                
                //2 绑定 进程和端口进行绑定
                r = bind(serverFd, ptrSockaddr, socklen_t(sizeAddr))
                
            })
        }
        
        if r == -1 {
            print("bind fail")
            return
        }else {
            print("bind success")
        }
        
        /*
         listen 之前需要bind一下，用来确保socket能在某一固定的端口监听
         最多一次处理10个
        */
        
        r = listen(serverFd, 10)
        if r == -1 {
            print("listen fail!\n");
            return
        }
        print("listen success!监听成功，可以聊天\n");
        
        
        while true {
            
            
            
            fdZero(set: &selectFds) //新的循环，清空selectFds，重新添加数据，重新检测
            
            fdSet(fd: serverFd, set: &selectFds) // 添加服务器的fd到selectFds中
            
            var currentMaxfds = serverFd // 目前最大的文件描述符
            
            if maxfd >= 0 {
                
                for index in 0...maxfd {
                    
                    // 把当前有效的fd添加到selectFds集合中
                    if  fdIsSet(fd: index, set: &allClientFd) {
                        
                        fdSet(fd: index, set: &selectFds)
                        currentMaxfds = (currentMaxfds < index ? index: currentMaxfds)
                        
                    }
                    
                }
            }
            // select  1024
            // 开始检测(监视)描述性文件的是否变化，如果有变化，保留在fds集合里面，没有不在集合里面
            let r = select(currentMaxfds+1, &selectFds, nil, nil, nil)
            
            if r == -1 {
                print("select fail!\n")
                break
            }
            
            if fdIsSet(fd: serverFd, set: &selectFds) { // serverFd情况，有人连接了
                
                
                print("有客服连接了")
                
                let fd = accept(serverFd, nil, nil) // 接受连接，给新来的生成一个对应的描述符文件
                if fd == -1  {
                    print("接受客户失败")
                    break
                }
                
                maxfd = maxfd<fd ? fd :maxfd // 获取最大的fd值
                
                fdSet(fd: fd, set: &allClientFd) // 把新的fd添加到allClientFd集合中
                
            }
            
            var buffer = Array<CChar>.init(repeating: 0, count: 256)
            
            for index in 0...maxfd {
                
                if fdIsSet(fd: index, set: &selectFds) && fdIsSet(fd: index, set: &allClientFd) {
                    
                    // 客户端的fd有情况，有消息过来了
                    let lenght = recv(index, &buffer, 255, 0)
                    if lenght <= 0 {
                        print("有人退出了")
                        fdClr(fd: index, set: &allClientFd) // 从allClientFd集合中移除退出的fd
                        
                    }else {
                        
                        let data = Data(bytes: &buffer, count: lenght)
                        if let str =  String.init(data: data, encoding: String.Encoding.utf8){
                            print("来自客户的数据：\(str)")
                        }
                        
                        
                        // 广播下数据，遍历所有的fd，发给每一个客服端
                        for clientFd in 0...maxfd {
                            
                            if fdIsSet(fd: clientFd, set: &allClientFd) {
                                
                                let res = send(clientFd, "broadcast", strlen("broadcast"), 0)
                                if res < 0 {
                                    print("广播失败")
                                }
                            }
                            
                        }
                        
                    }
                }
                
                
                
                
            }
            
        }
        
        
    }
    
    
    func fdIsSet(fd: Int32,  set: inout fd_set) -> Bool {
        let intOffset = Int(fd / 16)
        let bitOffset = Int(fd % 16)
        let mask: Int32 = 1 << bitOffset
        switch intOffset {
        case 0: return set.fds_bits.0 & mask != 0
        case 1: return set.fds_bits.1 & mask != 0
        case 2: return set.fds_bits.2 & mask != 0
        case 3: return set.fds_bits.3 & mask != 0
        case 4: return set.fds_bits.4 & mask != 0
        case 5: return set.fds_bits.5 & mask != 0
        case 6: return set.fds_bits.6 & mask != 0
        case 7: return set.fds_bits.7 & mask != 0
        case 8: return set.fds_bits.8 & mask != 0
        case 9: return set.fds_bits.9 & mask != 0
        case 10: return set.fds_bits.10 & mask != 0
        case 11: return set.fds_bits.11 & mask != 0
        case 12: return set.fds_bits.12 & mask != 0
        case 13: return set.fds_bits.13 & mask != 0
        case 14: return set.fds_bits.14 & mask != 0
        case 15: return set.fds_bits.15 & mask != 0
        default: return false
        }
        
    }
    
    func fdSet(fd: Int32,  set: inout fd_set) {
        let intOffset = Int(fd / 16)
        let bitOffset: Int = Int(fd % 16)
        let mask: Int32 = 1 << bitOffset
        
        switch intOffset {
        case 0: set.fds_bits.0 = set.fds_bits.0 | mask
        case 1: set.fds_bits.1 = set.fds_bits.1 | mask
        case 2: set.fds_bits.2 = set.fds_bits.2 | mask
        case 3: set.fds_bits.3 = set.fds_bits.3 | mask
        case 4: set.fds_bits.4 = set.fds_bits.4 | mask
        case 5: set.fds_bits.5 = set.fds_bits.5 | mask
        case 6: set.fds_bits.6 = set.fds_bits.6 | mask
        case 7: set.fds_bits.7 = set.fds_bits.7 | mask
        case 8: set.fds_bits.8 = set.fds_bits.8 | mask
        case 9: set.fds_bits.9 = set.fds_bits.9 | mask
        case 10: set.fds_bits.10 = set.fds_bits.10 | mask
        case 11: set.fds_bits.11 = set.fds_bits.11 | mask
        case 12: set.fds_bits.12 = set.fds_bits.12 | mask
        case 13: set.fds_bits.13 = set.fds_bits.13 | mask
        case 14: set.fds_bits.14 = set.fds_bits.14 | mask
        case 15: set.fds_bits.15 = set.fds_bits.15 | mask
        default: break
        }
    }
    
    
    func fdClr(fd: Int32,  set: inout fd_set) {
        let intOffset = Int(fd / 32)
        let bitOffset = fd % 32
        let mask:Int32 = ~(1 << bitOffset)
        switch intOffset {
        case 0: set.fds_bits.0 = set.fds_bits.0 & mask
        case 1: set.fds_bits.1 = set.fds_bits.1 & mask
        case 2: set.fds_bits.2 = set.fds_bits.2 & mask
        case 3: set.fds_bits.3 = set.fds_bits.3 & mask
        case 4: set.fds_bits.4 = set.fds_bits.4 & mask
        case 5: set.fds_bits.5 = set.fds_bits.5 & mask
        case 6: set.fds_bits.6 = set.fds_bits.6 & mask
        case 7: set.fds_bits.7 = set.fds_bits.7 & mask
        case 8: set.fds_bits.8 = set.fds_bits.8 & mask
        case 9: set.fds_bits.9 = set.fds_bits.9 & mask
        case 10: set.fds_bits.10 = set.fds_bits.10 & mask
        case 11: set.fds_bits.11 = set.fds_bits.11 & mask
        case 12: set.fds_bits.12 = set.fds_bits.12 & mask
        case 13: set.fds_bits.13 = set.fds_bits.13 & mask
        case 14: set.fds_bits.14 = set.fds_bits.14 & mask
        case 15: set.fds_bits.15 = set.fds_bits.15 & mask
        case 16: set.fds_bits.16 = set.fds_bits.16 & mask
        case 17: set.fds_bits.17 = set.fds_bits.17 & mask
        case 18: set.fds_bits.18 = set.fds_bits.18 & mask
        case 19: set.fds_bits.19 = set.fds_bits.19 & mask
        case 20: set.fds_bits.20 = set.fds_bits.20 & mask
        case 21: set.fds_bits.21 = set.fds_bits.21 & mask
        case 22: set.fds_bits.22 = set.fds_bits.22 & mask
        case 23: set.fds_bits.23 = set.fds_bits.23 & mask
        case 24: set.fds_bits.24 = set.fds_bits.24 & mask
        case 25: set.fds_bits.25 = set.fds_bits.25 & mask
        case 26: set.fds_bits.26 = set.fds_bits.26 & mask
        case 27: set.fds_bits.27 = set.fds_bits.27 & mask
        case 28: set.fds_bits.28 = set.fds_bits.28 & mask
        case 29: set.fds_bits.29 = set.fds_bits.29 & mask
        case 30: set.fds_bits.30 = set.fds_bits.30 & mask
        case 31: set.fds_bits.31 = set.fds_bits.31 & mask
        default: break
        }
    }
    
    
    func fdZero( set: inout fd_set) {
        
        set.fds_bits = (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
        
    }
    
    
    
    
}
