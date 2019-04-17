//
//  chatC.m
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import "ChatCNetSocketModel.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

@implementation ChatCNetSocketModel

fd_set fdSet;
int fd;


+ (void)initialize{
    [self shareChatCModel];
}


+ (instancetype)shareChatCModel{
    static ChatCNetSocketModel *chatCM;
    @synchronized (self) {
        if (!chatCM) {
            chatCM = [[ChatCNetSocketModel alloc] init];
            NSLog(@"===%d", getpid());
        }
    }
    return chatCM;
}

- (BOOL)connectServerChat
{
    //一、创建Socket
    /**
     参数
     domain:    协议域，AF_INET --> IPV4
     type:      Socket 类型，SOCK_STREAM(TCP)/SOCK_DGRAM(UDP)
     protocol: IPPROTO_TCP, 如果传入0,会自动更具第二个参数,选择合适的协议
     返回值
     socket
     */
    fd = socket(AF_INET,SOCK_STREAM,0);
	if(fd==-1){
        printf("sockett err:%m\n");
        return NO;
    }
	printf("socket ok!\n");
	/*二、连接到服务器
     参数
     1> 客户端socket
     2> 指向数据结构体sockaddr的指针，其中包括目的端口和IP地址
     3> 结构体数据长度
     返回值
     0 成功/其他 错误代号
    */
    
    //结构体  sockaddr
	struct sockaddr_in addr;
    //协议域
	addr.sin_family=AF_INET;
    //端口号
	addr.sin_port=htons(8989);
    //IP地址
	addr.sin_addr.s_addr=inet_addr("192.168.0.114");
    
	int r=connect(fd,(struct sockaddr*)&addr,sizeof addr);
    
	if(r==-1){
        printf("connect err:%m\n");
        return NO;
    }
	printf("connect ok!\n");
	
    /*
     三（1）、发送数据
     三（2）、接收数据
     */
    
    [NSThread detachNewThreadSelector:@selector(recvData) toTarget:self withObject:nil];
    return YES;
}

- (void)sendDataToSerVer:(ChatMessagModel*)messageModel
{
    [NSThread detachNewThreadSelector:@selector(threadSendData:) toTarget:self withObject:messageModel];
}

- (void)threadSendData:(ChatMessagModel*)contentModel
{
    const char *contC = [contentModel.textContent cStringUsingEncoding:NSUTF8StringEncoding];
    //三（1）、发送数据给服务器
    /**  C语言里面  Void *  代表指向任意类型
     参数
     1> 客户端socket
     2> 发送内容地址(指针)
     3> 发送内容长度
     4> 发送方式标志，一般为0
     返回值
     如果成功，则返回发送的字节数，失败则返回SOCKET_ERROR
     */
    ssize_t r = send(fd, contC, strlen(contC), 0);
    if (r < 0) {
        contentModel.senderSuccess = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatMessageSendStatusNotification object:contentModel];
        NSLog(@"send error");
    }else{
        contentModel.senderSuccess = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatMessageSendStatusNotification object:contentModel];
        NSLog(@"send success!");
    }
}

- (void)recvData
{
    char buf[1024];
    ssize_t lenght;
    while (1)
    {
        //三（2）.从服务器接收数据
        /**
         参数
         1> 客户端socket
         2> 接收内容缓冲区地址(指针)
         3> 接收内容缓存区长度
         4> 接收方式，0表示阻塞，必须等待服务器返回数据
         返回值
         如果成功，则返回读入的字节数，失败则返回SOCKET_ERROR
         */
        lenght = recv(fd, buf, 1024, 0);
        if (lenght <= 0){
            break;
        }
        else{
            buf[lenght] = 0;
            NSString *recvC = [NSString stringWithUTF8String:buf];
            [self performSelectorOnMainThread:@selector(recvDataToView:) withObject:recvC waitUntilDone:YES];
        }
    }
    close(fd);
    
    printf("recv Over!");
    
}

- (void)recvDataToView:(NSString*)content
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatMessageReciveNotification object:content userInfo:nil];
}

@end
