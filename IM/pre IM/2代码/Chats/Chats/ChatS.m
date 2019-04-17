//
//  ChatS.m
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import "ChatS.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/_select.h>
#include <netinet/in.h>
#include <arpa/inet.h>

/*
 S 1
  
  发一个数据 C   ip     S
 ip  只管数据从一个机器到另一台机器
 UDP不能判断是否发送失败
 // TCP send（）
 ／／ 指定地址和端口发送／接收
 
 sendTo recvFrom
 A: 
 1 建立socket
 2 绑定地址
 3 监听（数据／客户连接） （弄一个结合监听所有的描述性文件 allFd）
 4 客户连接 （accept上（客户2 产生一个fd（2）（描述性文件）^ fd 添加到allFd））（端口用的是S 1）
 5 读写数据
 6 关闭
 gcc
*/

@implementation  ChatS 


/*
 IM
 
 C  <------- S
 C  --未响应---->ack S
                    |
                    |
     APNs（推送） （客服）
 
 */

fd_set allfd; // 存放所有链接的客户对应的描述性文件

fd_set fds; // 有变化的描述性文件

int serverfd;
int maxfd = -1; // 所有的最大
int maxfds = -1; // 监听结合里面最大的


/*
 技术堆栈  自己写  私有协议
 
 XMPP （开发时间少一点，容易使用，接入方便，开源 缺点（xml，表现力弱，冗余的数据，流量比较大，坑））
 
 webSocket （web原生支持， xmpp）
 
 xml json  protobuf （结构体）
 
 私有协议： 时间多，更加高效  自由（）
 
 心跳包 （4s 一次 ）（）
 
 */
+ (BOOL)chatServer{
    
    //1 建立socket
    serverfd = socket(AF_INET, SOCK_STREAM, 0);
    if (serverfd == -1) {
        printf("socket fail\n");
        return NO;
    }
    printf("socket success!\n");
    //2 绑定地址
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(9000); // 端口
    addr.sin_addr.s_addr = inet_addr("192.168.0.114");
    
    int isreused = 0;
    setsockopt(serverfd,SOL_SOCKET,SO_REUSEADDR,&isreused,sizeof(int));
    
    /*
     listen 之前需要bind一下，用来确保socket能在某一固定的端口监听
     
     IP（） 对这个90端口占有了，后面，所有目标是90端口的TCP数据包都会转发给该程序（程序使用了socket编程接口，所有首先由socket层来处理）
     
     accept（）函数 建立连接过程， 这个连接是包括两部分信息： 客户端的ip和端口  + 服务端的（宿主）IP和（宿主）端口
     【程序内部端口可以一起用，  外部不能】
     描述文件fd （）
     */
    int r =  bind(serverfd,  (struct sockaddr *)&addr, sizeof(addr));
    if (r == -1) {
        printf("bind fail\n");
        return NO;
    }
    printf("bind success!\n");
    
    //3 监听（数据／客户连接） （弄一个结合监听所有的描述性文件 allFd）
    
    /*
     listen 之前需要bind一下，用来确保socket能在某一固定的端口监听
     
     一次能坐的任务数： 15客户连接过来， 前面10个才能处理，请求队列里面来，后面5个就被拒绝了。
     10并不是表示客户端最大的连接数为10；
     
     */
    r =  listen(serverfd, 10);
    if (r == -1) {
        printf("listen fail!\n");
        return NO;
    }
    printf("listen success!监听成功，可以聊天\n");
    /*
     join   in
     */
    
    //FD_ZERO(&allfd);
   
    while (1) {
        
        // 初始化 是否有变化的fd
        FD_ZERO(&fds);
        
        maxfds = -1;
        
        // 这个就是
        FD_SET(serverfd, &fds);
        maxfds = maxfds<serverfd?serverfd:maxfds;
        
        // 添加链接客户相应的描述性符号到监视集合
        for (int i = 0; i <= maxfd; i++) {
            
            if(FD_ISSET(i , &allfd)){ // 描述性文件是否在allfd集合中
                
                FD_SET(i, &fds); // 将描述性符号 加到监视集合里  防止后续的操作修改监视集合
                maxfds = maxfds<i?i:maxfds;
            }
            
        }
        // select  1024   poll()  轮询 O（n）   epoll（回掉机制）  500
        // 开始监视描述性文件的是否变化，如果有变化，记忆保留在fds集合里面，没有不在集合里面
        int r = select(maxfds+1, &fds, 0, 0, 0);
        if(r== -1){
            
            printf("select fail!\n");
            break;
        }
        
         //4 客户连接 （accept上（客户2 产生一个fd（2）（描述性文件）^ fd 添加到allFd））（端口用的是S 1）
        if (FD_ISSET(serverfd , &fds)) {
            
            printf("有客户连接了\n");
            
            int fd = accept(serverfd, 0, 0); // 生成了一个描述性文件 ()
            if (fd == -1) {
                printf("接受客户失败\n");
                break;
                
            }
            
            maxfd = maxfd<fd?fd:maxfd;
            FD_SET(fd, &allfd);
            
        }
        //5 读写数据
        char buf[256];
        for (int i = 0; i <= maxfd; i++) {
            
            // 有状态
            if (FD_ISSET(i, &fds) && FD_ISSET(i, &allfd)) {
                
                // 接受数据
                r = (int)recv(i, buf, 255, 0);
                if (r <= 0) {
                    printf("有人退出了\n");
                    FD_CLR(i, &allfd);
                }
                
                buf[r] = '\0';
                
                printf("来自客户数据：%d:%s\n", r, buf);
                
                buf[r] = ':';
                buf[r+1] = 'S';
                buf[r+2] = 0;
                
                // 发送数据 广播数据 （没数据协议）
                for (int j = 0; j <= maxfd; j++) {
                    
                    if(FD_ISSET(j, &allfd)){ //发给所有连接的客户
                        
                        r = (int)send(j, buf, strlen(buf), 0);
                        
                        printf("send::%d\n", r);
                    }
                }
                
            }
            
        }
        
    }
    
    //6 关闭
    close(serverfd);
    
    return YES;
    
}


@end
