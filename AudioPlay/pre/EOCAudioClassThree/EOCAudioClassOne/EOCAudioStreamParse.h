//
//  EOCAudioStreamParse.h
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "EOCAudioStreamPacketModel.h"


@protocol EOCAudioStreamParseDelegate <NSObject>

- (void)eocAudioStreamParseForPackets:(NSArray*)packetAry;

@end

@interface EOCAudioStreamParse : NSObject{
    
    
    AudioFileTypeID _audioFileTypeID; // 文件类型
    
    AudioFileStreamID _audioFileStreamID;//
    
    UInt32 _fileSize;
    
    BOOL _isContinue; //是否连续
    
    UInt32 _audioDataOffset;
    UInt32 _biteRate;
    UInt32 _audioDataByteCount;
    
    BOOL isReadyProductPacket;
    
   
    
    float _duration;// 时间长度
}

@property (nonatomic, assign)BOOL isContinue;
@property (nonatomic, weak)id<EOCAudioStreamParseDelegate>delege;
@property (nonatomic, assign) AudioStreamBasicDescription audioStreamBasicDescription;


- (instancetype)initWithFile:(AudioFileTypeID)fileType filezize:(UInt32)filesize;


- (BOOL)parserAudioStream:(NSData*)data;


- (BOOL)isReadyProductPacket;



- (void)handleAudioFileStream_PacketsProc:(UInt32)inNumberBytes Packets:(UInt32)inNumberPackets PacketData:(NSData*)packetData PacketDescription:(AudioStreamPacketDescription*)inPacketDescriptions;

- (void)handleAudioFileStream_PropertyListenerProc:(AudioFileStreamPropertyID)inPropertyID;
@end
