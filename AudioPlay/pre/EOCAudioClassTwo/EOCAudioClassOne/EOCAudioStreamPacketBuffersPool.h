//
//  EOCAudioStreamPacketBuffers.h
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EOCAudioStreamPacketModel.h"


@interface EOCAudioStreamPacketBuffersPool : NSObject{
    
    NSMutableArray *_packetBufferAry;
    
    NSLock *_opLock;
    
    
}

@property (nonatomic, assign)UInt32 bufferSize;

- (void)enqueuePoolStreamPacketsAry:(NSArray*)packets;

- (NSData*)dequeuePoolStreamPacketDataSize:(UInt32)dataSize packetCount:(UInt32*)packetCount audioStreamPacketDescription:(AudioStreamPacketDescription**)packetDescription;

@end
