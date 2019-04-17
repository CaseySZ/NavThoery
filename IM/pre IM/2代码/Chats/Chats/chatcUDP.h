//
//  chatcUDP.h
//  Chats
//
//  Created by EOC on 2017/6/5.
//  Copyright © 2017年 sunyong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chatcUDP : NSObject

- (BOOL)udpClientChat;
- (void)sendData:(NSString*)contentS;

@end
