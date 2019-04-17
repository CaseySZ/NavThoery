//
//  chatcUDP.m
//  Chats
//
//  Created by EOC on 2017/6/5.
//  Copyright © 2017年 sunyong. All rights reserved.
//

#import "chatcUDP.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

int fd;

@implementation chatcUDP

static struct sockaddr_in addr;
- (BOOL)udpClientChat{
    
    // 1.1.建立socket
    fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd == -1) {
        printf("socket fail");
        return NO;
    }
   
    addr.sin_family = AF_INET;
    addr.sin_port = htons(9090); // 端口
    addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    
    // 指定地址发送消息

    ssize_t r = sendto(fd, "UDP发送", 9, 0, (struct sockaddr *)&addr, sizeof(addr));
    if (r < 0) {
        NSLog(@"send error");
    }
    NSLog(@"send success");
    
    // 1.2.接收数据
    [NSThread detachNewThreadSelector:@selector(threadRecvData) toTarget:self withObject:nil];
    
    return YES;
    
}

- (void)sendData:(NSString*)contentS{
    
    if (contentS == nil || contentS.length == 0) {
        return;
    }
    const char *connC = [contentS cStringUsingEncoding:NSUTF8StringEncoding];
    
    ssize_t r = sendto(fd, connC, strlen(connC), 0, (struct sockaddr *)&addr, sizeof(addr));

    if (r < 0) {
        NSLog(@"send error");
    }
    NSLog(@"send success");
}

/*
    
 xmpp （socket xml， SSL TLS）
 websocket （socket， SSL ，TLS， ）
 
*/

// 1.4.接收数据
- (void)threadRecvData{
    
    char buf [16];
    ssize_t lenght;
    while (1) {
        /*
         buf 接收内容缓冲区
         1024 接收的最大长度
         0 阻塞
         MSG_WAITALL 配置 缓冲区的数据满了才不阻塞 （到达多少数据量才返回）
         返回值lenght 是数据的长度
         */
        // 4个字符  abcd lenght = 4
        socklen_t socklent = (socklen_t)sizeof(addr);
        /*
         绑定端口地址
         S :socket fd (绑定端口)   其他应用发消息
         listen(fd) 客户端有动向了
         */
//        int status = bind(fd, (struct sockaddr *)&addr, socklent);
//        if(status == -1) {
//            NSLog(@"bind error");
//        }
        lenght = recv(fd, buf, 16, 0);
        
       // lenght = recvfrom(fd, buf, 16, 0, (struct sockaddr *)&addr, &socklent);
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
