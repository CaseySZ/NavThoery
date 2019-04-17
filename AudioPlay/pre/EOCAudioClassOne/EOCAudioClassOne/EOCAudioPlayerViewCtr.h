//
//  EOCAudioPlayerViewCtr.h
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "EOCAudioSession.h"
#import "EOCAudioStreamParse.h"
#import "EOCAudioStreamPacketBuffers.h"
#import "EOCAudioQueueRead.h"

@interface EOCAudioPlayerViewCtr : ViewController{
    
    NSInteger _fileSize;
    NSInteger _fileOffset;
    
    NSFileHandle *fileHandle;
    EOCAudioSession *eocAudioSession;
    EOCAudioStreamParse *eocAudioStreamParse;
    EOCAudioStreamPacketBuffers *eocAudioStreamPacketBuffers;
    EOCAudioQueueRead *eocAudioQueueRead;
    
    
}

@end
