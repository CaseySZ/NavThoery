//
//  RoomInfoModel.m
//  WebSocketDemo
//
//  Created by Casey on 24/01/2019.
//  Copyright © 2019 newbike. All rights reserved.
//

#import "RoomInfoModel.h"


@interface RoomInfoModel ()

@property (nonatomic, strong)NSDictionary *roundRes; // 该靴历史结局列表






@end


@implementation RoomInfoModel

// pair  0 无对子。1庄对， 2 庄闲  3 庄闲对
// timestamp
// card_num


// 该靴历史结局列表 0 闲赢， 1 庄赢  2 和
- (void)setRoundRes:(NSDictionary *)roundRes {
    
    _roundRes = roundRes;
    
    NSArray *keyArr = [roundRes.allKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSMutableArray *resultArr = [NSMutableArray arrayWithCapacity:keyArr.count];
    for (int i = 0; i < keyArr.count; i++) {
        
        NSDictionary *infoDict = keyArr[i];
        NSInteger banker_val = [[infoDict objectForKey:@"banker_val"] integerValue]; // 该局庄家点
        NSInteger player_val = [[infoDict objectForKey:@"player_val"] integerValue]; // 该局闲家点数
        
        NSInteger result = 0;
        if (player_val > banker_val) {
            result = 0;
        }else if (player_val < banker_val) {
            result = 1;
        }else {
            result = 2;
        }
        [resultArr addObject:[@(result) description]];
    }
    
    _roundResultArr = resultArr;
    
    
}


@end
