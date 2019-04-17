//
//  EOCAudioStreamPacketBuffers.m
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCAudioStreamPacketBuffersPool.h"

@implementation EOCAudioStreamPacketBuffersPool


- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        _packetBufferAry = [NSMutableArray new];
        _bufferSize = 0;
    }
    
    return self;
}

// 入池子保存解析后的音频数据
- (void)enqueuePoolStreamPacketsAry:(NSArray*)packets{
    for (int i = 0; i < packets.count; i++) {
        [self enqueueStreamPacket:packets[i]];
    }
}
- (void)enqueueStreamPacket:(EOCAudioStreamPacketModel *)steamPacketsModel{
    [_packetBufferAry addObject:steamPacketsModel];
    _bufferSize += steamPacketsModel.data.length;
}


// 出池子，给audioQueue读  3000
- (NSData*)dequeuePoolStreamPacketDataSize:(UInt32)dataSize packetCount:(UInt32*)packetCount audioStreamPacketDescription:(AudioStreamPacketDescription**)packetDescription{
    
    if (dataSize <= 0 || _packetBufferAry.count == 0) {
        return nil;
    }
    
    
    NSMutableData *streamData = [NSMutableData data];
    // 首先计算包的数量
    int32_t packetSize = dataSize;
    int32_t i;
    for (i = 0; i < _packetBufferAry.count; i++) {
        EOCAudioStreamPacketModel *packetModel = _packetBufferAry[i];
        packetSize -= packetModel.data.length;
        if (packetSize < 0) {
            break;
        }
    }
    
    // 异常
    UInt32 pCount = (i >= _packetBufferAry.count)? (UInt32)_packetBufferAry.count:(i+1);
    *packetCount = (UInt32)pCount;
    
    // 提供内存空间
    if (packetDescription != NULL) {
        *packetDescription = (AudioStreamPacketDescription*)malloc(sizeof(AudioStreamPacketDescription)*pCount);
    }
    
    
    
    for (int j = 0; j < pCount; j++) {
        EOCAudioStreamPacketModel *packetModel = _packetBufferAry[j];
        
        if (packetDescription != NULL) {
            AudioStreamPacketDescription desc = packetModel.packetDes;
            desc.mStartOffset = streamData.length;
            (*packetDescription)[j] = desc;
        }
        
        [streamData appendData:packetModel.data];
    }
    
    //从池子中移除
    [_packetBufferAry removeObjectsInRange:NSMakeRange(0, pCount)];
    _bufferSize -= streamData.length;

    
    //NSLog(@"pool总大小：%ld--减少了:%ld", _bufferSize, streamData.length);
    
    return streamData;
}


@end
