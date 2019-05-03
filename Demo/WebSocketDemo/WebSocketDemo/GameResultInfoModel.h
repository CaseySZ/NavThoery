//
//  GameResultInfoModel.h
//  WebSocketDemo
//
//  Created by Casey on 25/01/2019.
//  Copyright © 2019 newbike. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameResultInfoModel : NSObject


@property (nonatomic, strong)NSString *vid; //视频Id
@property (nonatomic, strong)NSString *round; //该靴第几局
@property (nonatomic, strong)NSString *gmCode; // 当前局局号
@property (nonatomic, strong)NSString *banker_val; // 该局庄家点
@property (nonatomic, strong)NSString *player_val; // 该局闲家点数
@property (nonatomic, strong)NSString *pair; // 0 无对子。1庄对， 2 庄闲  3 庄闲对
@property (nonatomic, strong)NSString *timestamp; //



@end

NS_ASSUME_NONNULL_END
