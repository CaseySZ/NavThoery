//
//  chatC.h
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 nc lk 端口号 （TCP）
 nc luk 端口号（UDP） 
 */
@interface chatC : NSObject

/*
 短连接
 
 长连接
 竞拍 A ：60数量
 发送一个消息给服务 询问当前数量是多少 如果服务器去检查，数量没有变化，那么服务器就不send数据，客户端一直阻塞，等到数据变化了（59）就返回去
 
 */

- (BOOL)buildClientChat;
- (void)sendData:(NSString*)contentS;


@end
