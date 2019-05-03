//
//  RoomInfoModel.h
//  WebSocketDemo
//
//  Created by Casey on 24/01/2019.
//  Copyright © 2019 newbike. All rights reserved.
//

#import <Foundation/Foundation.h>




/*
 gameType 类型。   BAC 经典百家乐。 CBAC 包桌百家乐， TBAC 竞咪百家乐 LBAC 现场百家乐， SBAC 保险百家乐   BBAC 龙宝百家乐  NN 牛牛。；TEB 二八杠， ROU轮盘；DT 龙虎 SHB  骰宝
 vid 视频Id
 shoeCode 鞋号
 roundCount 该该靴结局总和
 roundRes:该靴历史结局列表
 dealer：何官名字
 gmCode：当前局局号
 banker_val 该局庄家点
 player_val 该局闲家点数
 pair： 0 无对子。1庄对， 2 庄闲  3 庄闲对
 seconds 该靴下注时间
 */


@interface RoomInfoModel : NSObject


// 类型  BAC 经典百家乐。 CBAC 包桌百家乐， TBAC 竞咪百家乐 LBAC 现场百家乐， SBAC 保险百家乐   BBAC 龙宝百家乐  NN 牛牛。；TEB 二八杠， ROU轮盘；DT 龙虎 SHB  骰宝
@property (nonatomic, strong)NSString *gameType;
@property (nonatomic, strong)NSString *vid; //视频Id
@property (nonatomic, strong)NSString *shoeCode; // 鞋号
@property (nonatomic, strong)NSString *roundCount; // 该该靴结局总和
@property (nonatomic, strong)NSString *dealer; // 何官名字
@property (nonatomic, strong)NSString *gmcode; // 当前局局号
@property (nonatomic, strong)NSString *seconds; // 该靴下注时间
@property (nonatomic, strong, readonly)NSArray<NSString*> *roundResultArr; // 该靴历史结局列表 0 闲赢， 1 庄赢  2 和


@end


