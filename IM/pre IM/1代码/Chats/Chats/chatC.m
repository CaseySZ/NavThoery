//
//  chatC.m
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import "chatC.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <unistd.h>
#import <stdio.h>
#import <stdlib.h>

@implementation chatC

int fd;

- (BOOL)buildClientChat{
    //
   // TCP客户端处理
   
    /*
     MAC proc fd（0，1，3）
     fd 描述性文件
     
     SOCK_STREAM TCP
     SOCK_DGRAM  UDP
     
     */
    
     // 1.1.建立socket
    fd = socket(AF_INET, SOCK_STREAM, 0);
    if (fd == -1) {
        printf("socket fail");
        return NO;
    }
    // 1.2.连接服务器
    ;
    struct sockaddr_in addr;
    addr.sin_family = AF_INET;
    addr.sin_port = htons(8888); // 端口
    addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    
    /*
     三次握手
     connect
     */
    int r =  connect(fd,  (struct sockaddr *)&addr, sizeof(addr));
    if (r == -1) {
        printf("connect fail");
        return NO;
    }else{
        printf("connect ok");
        
        NSLog(@"connect ok");
    }
    
    // 1.4.接收数据
    [NSThread detachNewThreadSelector:@selector(threadRecvData) toTarget:self withObject:nil];
   
    return YES;
}

// 1.3.发送数据
- (void)sendData:(NSString*)contentS{
    
    [NSThread detachNewThreadSelector:@selector(threadSendData:) toTarget:self withObject:contentS];
}

- (void)threadSendData:(NSString*)contentS{
    /*
     sizeof, strlen
     */
    if (contentS == nil || contentS.length == 0) {
        return;
    }
    const char *connC = [contentS cStringUsingEncoding:NSUTF8StringEncoding];
    // 发送就是写操作
   // ssize_t r = write(fd, connC, strlen(connC));
    ssize_t r =  send(fd, connC, strlen(connC), 0);
    if (r < 0) {
        NSLog(@"send error");
    }
    NSLog(@"send success");
}

// 1.4.接收数据
- (void)threadRecvData{
    
    char buf [16];
    ssize_t lenght;
    while (1) {
        /*
         buf 接收内容缓冲区
         1024 接收的最大长度
         0 阻塞
         MSG_WAITALL
         返回值lenght 是数据的长度
         */
        // 4个字符  abcd lenght = 4
        //lenght = read(fd, buf, 16);
        lenght = recv(fd, buf, 16, 0);
        if (lenght <= 0) {
            
            NSLog(@"断开了：length:%d", (int)lenght);
            break;
            
        }else{
            
            buf[lenght] = 0;
            NSLog(@"%s", buf);// abcd0dgege
            
            NSString *revcC = [NSString stringWithUTF8String:buf];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"EOCIMChatRecv" object:revcC];
        }
    }
    
    // 1.5.关闭连接
    close(fd);
}


@end
