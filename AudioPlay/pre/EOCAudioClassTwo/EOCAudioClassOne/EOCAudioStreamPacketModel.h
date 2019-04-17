//
//  EOCAudioStreamPacketModel.h
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface EOCAudioStreamPacketModel : NSObject



- (instancetype)initWithPacketData:(NSData*)data packetDescription:(AudioStreamPacketDescription)packetDes;

@property (nonatomic, strong)NSData *data;
@property (nonatomic, assign)AudioStreamPacketDescription packetDes;

@end
