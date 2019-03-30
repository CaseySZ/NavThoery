//
//  NewPNetPing.h
//  LDNetCheckServiceDemo
//
//  Created by 庞辉 on 14-10-29.
//  Copyright (c) 2014年 庞辉. All rights reserved.
//

#import <Foundation/Foundation.h>




@protocol NewPNetPingDelegate <NSObject>

- (void)appendPingLog:(NSString *)pingLog;

- (void)netPingDidEnd;

// 响应时长回调，单位是: ms 毫秒
- (void)appendPingLog:(NSString *)pingLog responseSecond:(long)second;

@end


/*
 * @class NewPNetPing ping监控
 * 主要是通过模拟shell命令ping的过程，监控目标主机是否连通
 * 连续执行五次，因为每次的速度不一致，可以观察其平均速度来判断网络情况
 */

@interface NewPNetPing : NSObject 

@property (nonatomic, weak) id<NewPNetPingDelegate> delegate;

/**
 * 通过hostname 进行ping诊断
 */
- (void)runWithHostName:(NSString *)hostName normalPing:(BOOL)normalPing;

/**
 * 停止当前ping动作
 */
- (void)stopPing;


@end
