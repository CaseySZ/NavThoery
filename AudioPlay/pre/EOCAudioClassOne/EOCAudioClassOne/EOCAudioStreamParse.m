//
//  EOCAudioStreamParse.m
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCAudioStreamParse.h"

// 音频文件属性数据
/*
 kAudioFileStreamProperty_ReadyToProducePackets
 
 kAudioFileStreamProperty_DataOffset
 
 kAudioFileStreamProperty_BitRate
 
 kAudioFileStreamProperty_DataFormat
 
 kAudioFileStreamProperty_AudioDataByteCount 
 音频数据总量
 
 // seek
 */
static void EOCAudioFileStream_PropertyListenerProc(void *inClientData,
                                             AudioFileStreamID inAudioFileStream,
                                             AudioFileStreamPropertyID	inPropertyID,
                                             AudioFileStreamPropertyFlags *	ioFlags){
    
    EOCAudioStreamParse *eocAudioStreamParse = (__bridge EOCAudioStreamParse *)inClientData;
    
    [eocAudioStreamParse handleAudioFileStream_PropertyListenerProc:inPropertyID];
    
    
}

// 音频数据
static void EOCAudioFileStream_PacketsProc(void *inClientData,
                                    UInt32 inNumberBytes,
                                    UInt32 inNumberPackets,
                                    const void *inInputData,
                                    AudioStreamPacketDescription	*inPacketDescriptions){
    
    EOCAudioStreamParse *eocAudioStreamParse = (__bridge EOCAudioStreamParse *)inClientData;
    
    NSData *data = [NSData dataWithBytes:inInputData length:inNumberBytes];
    
    [eocAudioStreamParse handleAudioFileStream_PacketsProc:inNumberBytes Packets:inNumberPackets PacketData:data PacketDescription:inPacketDescriptions];
}


// 解析
@implementation EOCAudioStreamParse


- (instancetype)initWithFile:(AudioFileTypeID)fileType filezize:(UInt32)filesize{
    
    self = [super init];
    if (self) {
        _audioFileTypeID = fileType;
        _fileSize = filesize;
        _isContinue = YES;
        isReadyProductPacket = NO;
        [self createAudioSessionStream];
    }
    return self;
}

- (BOOL)createAudioSessionStream{
    
    AudioFileStreamOpen((__bridge void*)self, EOCAudioFileStream_PropertyListenerProc, EOCAudioFileStream_PacketsProc, _audioFileTypeID, &_audioFileStreamID);
    
    return YES;
}

// seek
- (BOOL)parserAudioStream:(NSData*)data{
    
  // 刚开始解析的时候，是解析的文件头,解析完的数据到了 EOCAudioFileStream_PropertyListenerProc
    // 文件解析完后那么就是音频数据，这个之后解析的数据到了EOCAudioFileStream_PacketsProc
    
    AudioFileStreamParseBytes(_audioFileStreamID, (UInt32)data.length, [data bytes], _isContinue?0:kAudioFileStreamParseFlag_Discontinuity);
    
    return YES;
}

- (BOOL)isReadyProductPacket{
    
    return isReadyProductPacket;
    
}


// 文件属性处理
- (void)handleAudioFileStream_PropertyListenerProc:(AudioFileStreamPropertyID)inPropertyID{
    
    if (inPropertyID == kAudioFileStreamProperty_DataOffset) {
        
        UInt32 size = sizeof(_audioDataOffset);
        AudioFileStreamGetProperty(_audioFileStreamID, inPropertyID, &size, &_audioDataOffset);
    }
    
    if (inPropertyID == kAudioFileStreamProperty_BitRate) {
        
        UInt32 size = sizeof(_biteRate);
        AudioFileStreamGetProperty(_audioFileStreamID, inPropertyID, &size, &_biteRate);
    }

    if (inPropertyID == kAudioFileStreamProperty_AudioDataByteCount) {
        
        UInt32 size = sizeof(_audioDataByteCount);
        AudioFileStreamGetProperty(_audioFileStreamID, inPropertyID, &size, &_audioDataByteCount);
    }

    if (inPropertyID == kAudioFileStreamProperty_DataFormat) {
        
        UInt32 size = sizeof(_audioStreamBasicDescription);
        AudioFileStreamGetProperty(_audioFileStreamID, inPropertyID, &size, &_audioStreamBasicDescription);
    }

    
    if (inPropertyID == kAudioFileStreamProperty_ReadyToProducePackets) {
        // 文件属性解析完了
        isReadyProductPacket = YES;
        _isContinue = NO;
        
        [self calcultateDuration];
    }
    
}


- (void)calcultateDuration{
    
    if (_biteRate > 0 && _fileSize > 0) {
        _duration = (_fileSize-_audioDataOffset)*8.0/_biteRate;
    }
}

// 音频帧的处理 （buffer）
- (void)handleAudioFileStream_PacketsProc:(UInt32)inNumberBytes Packets:(UInt32)inNumberPackets PacketData:(NSData*)packetData PacketDescription:(AudioStreamPacketDescription*)inPacketDescriptions{
    
    if (!_isContinue) {
        _isContinue = YES;
    }
    
}


@end
