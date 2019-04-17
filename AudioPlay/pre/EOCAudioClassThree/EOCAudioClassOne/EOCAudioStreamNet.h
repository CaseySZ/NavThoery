//
//  EOCAudioStreamNet.h
//  EOCAudioClassOne
//
//  Created by EOC on 2017/7/3.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pthread.h>

/*
 http://www.comdesignlab.com/travel/wp-content/uploads/1024/Children_of_Youyang.mp3
 */

#define EOCMusicURL @"http://www.comdesignlab.com/travel/wp-content/uploads/1024/Children_of_Youyang.mp3"


@protocol EOCAudioStreamNetDelegate  <NSObject>

- (void)netHandleDataWithResponse:(NSDictionary*)headerFiledDict;
- (void)newHandleDataWithRecevieData:(NSData*)data;
- (void)netHandleFinish:(NSError*)error;

@end

@interface EOCAudioStreamNet : NSObject<NSURLSessionTaskDelegate, NSURLSessionDataDelegate>{
    
    // 网络数据
    NSMutableData *audioNetData;
    // 数据缓冲
    NSMutableData *audioReadedData;
    
    
    pthread_mutex_t _mutex;
    pthread_cond_t _cond;
    
    BOOL _isFinish;
    
    NSURLSessionDataTask *_task;
}

@property (nonatomic, weak)id<EOCAudioStreamNetDelegate>delegate;

- (void)startLoadMusic:(NSString*)urlStr offset:(long)offset;


- (NSData*)readDataOfLength:(int)length isPlay:(BOOL)isPlay;

@end
