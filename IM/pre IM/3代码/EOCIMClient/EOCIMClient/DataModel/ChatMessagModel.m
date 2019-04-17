//
//  ChatMessagModel.m
//  EOCIMClient
//
//  Created by class on 16/02/2017.
//  Copyright © 2017 @八点钟学院. All rights reserved.
//

#import "ChatMessagModel.h"

@implementation ChatMessagModel


+ (NSArray*)backFromData:(int)count{

    static int __testData = 30;
    if (__testData < 0) {
        return nil;
    }
    NSMutableArray *dataAry = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        
        ChatMessagModel *model = [[ChatMessagModel alloc] init];
        model.name = @"1212";
        model.isRecv = random()%2;
        model.senderSuccess = YES;
        model.messageType = MessageTextType;
        model.textContent = [NSString stringWithFormat:@"message:%d", __testData];
        model.imageURL = nil;
        model.filePath = nil;
        model.timeStamp = __testData;
        [dataAry addObject:model];
        
        __testData--;
    }
    
    
    return dataAry;
}


@end
