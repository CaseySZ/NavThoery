//
//  EOCAudioStreamPacketModel.m
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCAudioStreamPacketModel.h"

@implementation EOCAudioStreamPacketModel

- (instancetype)initWithPacketData:(NSData*)data packetDescription:(AudioStreamPacketDescription)packetDes{
    
    self = [super init];
    if (self) {
        
        _data = data;
        _packetDes = packetDes;
        
    }
    return self;
}
@end
