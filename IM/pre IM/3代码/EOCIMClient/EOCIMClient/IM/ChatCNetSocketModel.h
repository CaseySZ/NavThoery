//
//  chatC.h
//  Chats
//
//  Created by sunyong on 14-6-24.
//  Copyright (c) 2014年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessagModel.h"


#define ChatMessageReciveNotification @"ChatMessageReciveNotification"
#define ChatMessageSendStatusNotification @"ChatMessageSendStatusNotification"

/*
 find ./ -name "proc" -print
 通过查找进程文件,可以看到进程相关文件下的文件，但是MAC系统没有给用户提供这个权限，看不到
 
 nc可以作为server以TCP或UDP方式侦听指定端口
 nc -lk 9002
 */

@interface ChatCNetSocketModel : NSObject

+ (instancetype)shareChatCModel;

- (BOOL)connectServerChat;

// 发送数据
- (void)sendDataToSerVer:(ChatMessagModel*)messageModel;

@end
