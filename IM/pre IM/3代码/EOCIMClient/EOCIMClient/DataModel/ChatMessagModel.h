//
//  ChatMessagModel.h
//  EOCIMClient
//
//  Created by class on 16/02/2017.
//  Copyright © 2017 @八点钟学院. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    MessageTextType = 0,
    MessageImageType,
    MessageAudioType
    
}MessageType;

@interface ChatMessagModel : NSObject{
    

}

@property(nonatomic, assign)BOOL isRecv; //是否是接收的消息
@property(nonatomic, assign)BOOL senderSuccess; // 发送成功

@property(nonatomic, assign)NSString *name;
@property(nonatomic, assign)MessageType messageType; // 消息内容类型（文本，图片等）
@property(nonatomic, strong)NSString *textContent;// 文本内容
@property(nonatomic, strong)NSString *imageURL;// 图片地址
@property(nonatomic, strong)NSString *filePath;// 文件地址

@property(nonatomic, assign)CGFloat contentWidth;// 内容宽度
@property(nonatomic, assign)CGFloat contentHeight;// 内容高度
@property(nonatomic, assign)NSTimeInterval timeStamp;// 时间戳


+ (NSArray*)backFromData:(int)count;

@end
