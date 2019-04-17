//
//  ChatS.m
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/select.h>
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


fd_set allfd; // 存放所有链接的客户对应的描述性文件

fd_set fds; // 有变化的描述性文件

int serverfd;
int maxfd = -1; // 所有的最大
int maxfds = -1; // 监听结合里面最大的

int main(){
    
    //1 建立socket
    serverfd = socket(AF_INET, SOCK_STREAM, 0);
    if (serverfd == -1) {
        printf("socket fail\n");
        return 0;
    }
    printf("socket success!\n");
    //2 绑定地址
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(9001); // 端口
    addr.sin_addr.s_addr = inet_addr("192.168.0.114");
    
    int r =  bind(serverfd,  (struct sockaddr *)&addr, sizeof(addr));
    if (r == -1) {
        printf("bind fail\n");
        return 0;
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
        return 0;
    }
    printf("listen success!监听成功，可以聊天\n");
    
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
    
    return 0;
    
}

