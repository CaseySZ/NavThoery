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
    
    // 文件属性在文件尾，不支持流播放，返回kAudioFileStreamError_NotOptimized   seek
    OSStatus status = AudioFileStreamParseBytes(_audioFileStreamID, (UInt32)data.length, [data bytes], _isContinue?0:kAudioFileStreamParseFlag_Discontinuity);
    if (status != noErr) {
        NSLog(@"StreamParseBytes error!");
        return NO;
    }
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
    
   
    if (inNumberBytes == 0 || inNumberPackets == 0) {
        return;
    }
    
    if (!_isContinue) {
        _isContinue = YES;
    }
    
    if (inPacketDescriptions == NULL) {
        NSLog(@"inPacketDescriptions 是空");
        AudioStreamPacketDescription *descriptions = malloc(sizeof(AudioStreamPacketDescription)*inNumberBytes);
        
        UInt32 packSize = inNumberBytes/inNumberPackets;
        for (int i = 0; i < inNumberPackets; i++) {
            UInt32 packeOffset = packSize * i;
            AudioStreamPacketDescription packetDes = inPacketDescriptions[i];
            packetDes.mStartOffset = packeOffset;
            packetDes.mVariableFramesInPacket = 0;//自己算的，varibable设置为O
            if (i == inNumberPackets - 1) {
                packetDes.mDataByteSize = inNumberBytes - packeOffset;
            }else{
                packetDes.mDataByteSize = packSize;
            }
        }
        inPacketDescriptions = descriptions;
    }
    NSMutableArray *packetAry = [NSMutableArray array];
    for (int i = 0; i < inNumberPackets; i++) {
        
        AudioStreamPacketDescription packetDes = inPacketDescriptions[i];
        
        SInt64 startOffset = packetDes.mStartOffset;
        SInt64 dateSize = packetDes.mDataByteSize;
        
        NSData *data = [packetData subdataWithRange:NSMakeRange(startOffset, dateSize)];
        
        EOCAudioStreamPacketModel *eocAudioPacketModel = [[EOCAudioStreamPacketModel alloc] initWithPacketData:data packetDescription:packetDes];
      
        [packetAry addObject:eocAudioPacketModel];
        
    }
    // 数据解析完了
    if (self.delege && [self.delege respondsToSelector:@selector(eocAudioStreamParseForPackets:)]) {
        
        [self.delege eocAudioStreamParseForPackets:packetAry];
        
    }
    
    
}


@end
