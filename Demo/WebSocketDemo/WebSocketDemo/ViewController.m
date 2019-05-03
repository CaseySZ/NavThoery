//
//  ViewController.m
//  WebSocketDemo
//
//  Created by 孙俊 on 17/2/16.
//  Copyright © 2017年 newbike. All rights reserved.
//

#import "ViewController.h"
#import "SocketRocketUtility.h"
#import "RoomInfoModel.h"

@interface ViewController ()

@property (nonatomic, strong)NSArray<RoomInfoModel*> *selectRoomArr; // 当前选择的桌台信息 （默认4个桌台）
@property (nonatomic, strong)NSDictionary *roomAllListArr; // 桌台列表


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // "{"sid":"c_tNW5uty7yhjNBfl5vf","upgrades":22,"pingInterval":25000,"pingTimeout":60000}"
    
    
    //return;
    // ws://121.43.38.179:7397
    // ws://roadmap.9mbv.com:8080/socket.io/?EIO=3&transport=websocket
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidOpen) name:kWebSocketDidOpenNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SRWebSocketDidReceiveMsg:) name:kWebSocketDidCloseNote object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kWebSocketdidReceiveMessageNote:) name:kWebSocketdidReceiveMessageNote object:nil];
    
    [[SocketRocketUtility instance] SRWebSocketOpenWithURLString:@"ws://roadmap.9mbv.com:8080/socket.io/?EIO=3&transport=websocket"];
    
//    [[SocketRocketUtility instance] SRWebSocketClose]; 在需要得地方 关闭socket
}

- (void)SRWebSocketDidOpen {
    NSLog(@"开启成功");
    //在成功后需要做的操作。。。
        
}

- (void)SRWebSocketDidReceiveMsg:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    NSLog(@"消息::%@",message);
}


- (void)kWebSocketdidReceiveMessageNote:(NSNotification *)note {
    //收到服务端发送过来的消息
    NSString * message = note.object;
    NSString *newMessage = [self cleanJsonTrashData:message];
    NSError *error = nil;
    NSDictionary *infoDict =  [NSJSONSerialization JSONObjectWithData:[newMessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        
        NSString *newNewMessage = [NSString stringWithFormat:@"\"%@\"", newMessage];
        error = nil;
        infoDict =  [NSJSONSerialization JSONObjectWithData:[newNewMessage dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
        if ([infoDict isKindOfClass:[NSString class]]) {
            NSString *jsonReuse = (NSString*)infoDict;
            infoDict = [NSJSONSerialization JSONObjectWithData:[jsonReuse dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
            if (error) {
                NSLog(@"解析失败%@", error);
            }
        }else {
            NSLog(@"解析失败2:%@", error);
        }
    }
    
    if ([infoDict isKindOfClass:[NSDictionary class]]) {
        
        if ([infoDict allValues].count > 0 && [[infoDict allValues].firstObject isKindOfClass:[NSDictionary class]] && [[infoDict allValues].firstObject objectForKey:@"roundCount"]) {
            
            // 桌台列表所有详细信息
            NSArray *keyArr = [infoDict.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            NSMutableArray *valueArr = [NSMutableArray new];
            for (int i = 0; i < keyArr.count; i++) {
                NSDictionary *roomInfo =  [infoDict valueForKey:keyArr[i]];
                if ([[roomInfo valueForKey:@"roundCount"] intValue] > 0) {
                    NSString *gameType = [roomInfo valueForKey:@"gameType"];
                    if ([gameType isEqual:@"BAC"] || [gameType isEqual:@"TBAC"] || [gameType isEqual:@"LBAC"] || [gameType isEqual:@"SBAC"]|| [gameType isEqual:@"BBAC"]) {
                        [valueArr addObject:roomInfo];
                    }
                }
            }
            
            NSMutableArray *selectRoomInfoArr = [NSMutableArray arrayWithCapacity:4];
            if (valueArr.count > 4) {
                
                [selectRoomInfoArr addObject:valueArr.firstObject];
                [selectRoomInfoArr addObject:[valueArr objectAtIndex:valueArr.count/3]];
                [selectRoomInfoArr addObject:[valueArr objectAtIndex:valueArr.count/2]];
                [selectRoomInfoArr addObject:valueArr.lastObject];
            }
            
            self.selectRoomArr = selectRoomInfoArr;
            
        }else if ([infoDict valueForKey:@"vid"]) {
            
            // 桌台结束一局信息
            NSString *currentVid = [infoDict valueForKey:@"vid"];
            BOOL isSelectRoom = NO; //
            for (int i = 0; i < self.selectRoomArr.count; i++) {
                
                NSDictionary *roomInfo = self.selectRoomArr[i];
                if ([[roomInfo valueForKey:@"vid"] isEqualToString:currentVid]) {
                    isSelectRoom = YES;
                    break;
                }
            }
            
            if (isSelectRoom) {
                
            }
            
        }else if ([infoDict allKeys].count > 50 && [[infoDict allValues].firstObject isKindOfClass:[NSString class]]) {
            
            // 桌台列表
            
        }
        
//        if ([infoDict objectForKey:@"B002"] && [[infoDict allValues].firstObject objectForKey:@"roundRes"]){
//
//            NSLog(@"%@", [[infoDict[@"B002"][@"roundRes"] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]);
//
//            for (int i = 0; i < infoDict.allValues.count; i++) {
//                NSDictionary *testInfo = infoDict.allValues[i];
//                if ([testInfo isKindOfClass:[NSDictionary class]]) {
//                    NSLog(@"%@", [testInfo[@"roundRes"] allKeys]);
//                }
//
//
//            }
//        }
    }else {
        
    }
    
}

- (NSString*)cleanJsonTrashData:(NSString*)jsonData {
    
    NSInteger safePosStartIndex = 0;
    NSInteger safePosEndIndex = jsonData.length-1;
    for (NSInteger i = 0; i < jsonData.length; i++) {
        
        unichar subChar  = [jsonData characterAtIndex:i];
        if (subChar == '{') {
            safePosStartIndex = i;
            break;
        }
    }
    
    for (NSInteger i = jsonData.length - 1; i > 0 ; i--) {
        
        unichar subChar  = [jsonData characterAtIndex:i];
        if (subChar == '}') {
            safePosEndIndex = i;
            break;
        }
    }
    
    NSInteger lenght = safePosEndIndex-safePosStartIndex+1;
    if (safePosStartIndex >= 0 && safePosStartIndex + lenght <= jsonData.length) {
        
        NSString *safeJsonStr = [jsonData substringWithRange:NSMakeRange(safePosStartIndex, lenght)];
        safeJsonStr = [NSString stringWithFormat:@"%@", safeJsonStr];
        
        return safeJsonStr;
    }else {
        
        NSLog(@"越界");
    }
    jsonData = [jsonData stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    jsonData = [jsonData stringByTrimmingCharactersInSet:[NSCharacterSet controlCharacterSet]];
    jsonData = [jsonData stringByReplacingOccurrencesOfString:@"'" withString:@""];
    return jsonData;
}




@end
