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
#import "EOCAudioStreamPacketBuffersPool.h"
#import "EOCAudioQueueRead.h"
#import "EOCAudioStreamNet.h"

@interface EOCAudioPlayerViewCtr : UIViewController<EOCAudioStreamParseDelegate, EOCAudioStreamNetDelegate>{
    
    NSInteger _fileSize;
    NSInteger _fileOffset;
    NSInteger _bufferSize;
    
    NSFileHandle *fileHandle;
    EOCAudioSession *eocAudioSession;
    EOCAudioStreamParse *eocAudioStreamParse;
    EOCAudioStreamPacketBuffersPool *eocBuffersPool;
    EOCAudioQueueRead *eocAudioQueueRead;
    
    NSThread *_audioThread;
    
    BOOL _playing;
    
    EOCAudioStreamNet *_eocAudioStreamNet;
}

@end
