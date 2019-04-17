//
//  EOCAudioStreamParse.h
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface EOCAudioStreamParse : NSObject{
    
    
    AudioFileTypeID _audioFileTypeID; // 文件类型
    
    AudioFileStreamID _audioFileStreamID;//
    
    UInt32 _fileSize;
    
    BOOL _isContinue; //是否连续
    
    UInt32 _audioDataOffset;
    UInt32 _biteRate;
    UInt32 _audioDataByteCount;
    
    BOOL isReadyProductPacket;
    
    AudioStreamBasicDescription *_audioStreamBasicDescription;
    
    float _duration;// 时间长度
}

- (instancetype)initWithFile:(AudioFileTypeID)fileType filezize:(UInt32)filesize;


- (BOOL)parserAudioStream:(NSData*)data;


- (BOOL)isReadyProductPacket;



- (void)handleAudioFileStream_PacketsProc:(UInt32)inNumberBytes Packets:(UInt32)inNumberPackets PacketData:(NSData*)packetData PacketDescription:(AudioStreamPacketDescription*)inPacketDescriptions;

- (void)handleAudioFileStream_PropertyListenerProc:(AudioFileStreamPropertyID)inPropertyID;
@end
