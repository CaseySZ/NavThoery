//
//  EOCAudioPlayerViewCtr.m
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCAudioPlayerViewCtr.h"



@interface EOCAudioPlayerViewCtr (){
    
    
    
}

@end

@implementation EOCAudioPlayerViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    NSString *filePath  = [[NSBundle mainBundle] pathForResource:@"MP3Sample" ofType:@"mp3"];
    
    fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    _fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil] fileSize];
    _fileOffset = 0;
    _bufferSize = _fileSize/500;
    
    _audioThread = [[NSThread alloc] initWithTarget:self selector:@selector(audioThread) object:nil];
    
    eocAudioSession = [[EOCAudioSession alloc] init];
    eocAudioStreamParse = [[EOCAudioStreamParse alloc] initWithFile:kAudioFileMP3Type filezize:(UInt32)_fileSize];
    eocAudioStreamParse.delege = self;
    
    eocBuffersPool = [EOCAudioStreamPacketBuffersPool new];
    eocAudioQueueRead = [EOCAudioQueueRead new];
    
    
    
}



- (void)audioThread{
    
    
    // 1 建立audioSession 会话
    BOOL isSuccess = [eocAudioSession eocAVAudioSessionActive:YES];
    if (!isSuccess) {
        return;
    }
    
    isSuccess = [eocAudioSession configAVAudioSessionCategory:AVAudioSessionCategoryPlayback];
    if (!isSuccess) {
        return;
    }
    
    
    BOOL isEOF = NO;
    // 需要文件size，和一个偏移量，知道文件的eof
    while (_fileSize > 0) {
        
        // 2 读音频文件 1000字节 fileHandle
        NSData *data = nil;
        if (!isEOF) {
            
            data = [fileHandle readDataOfLength:500];// 0-1000, 1000 -2000
            _fileOffset += data.length;
            if (_fileOffset >= _fileSize) {
                isEOF = YES;
                NSLog(@"finish EOF");
            }
        }
        
        if (_playing && data) {
            
            // 3 解析 eocAudioStreamParse
            isSuccess = [eocAudioStreamParse parserAudioStream:data];
            if (!isSuccess) {
                NSLog(@"解析数据出问题了");
                break;
            }

            // 5 读数据（从缓冲区里读）
            // 5.1 需要判断是否已经解析完文件头
            if ([eocAudioStreamParse isReadyProductPacket]) {
                // 5.2 读音频数据
                if (!eocAudioQueueRead.audioQueue) {
                    // 创建队列
                    isSuccess = [eocAudioQueueRead createQueue:eocAudioStreamParse.audioStreamBasicDescription bufferSize:(UInt32)_bufferSize]; // _bufferSize*3
                    if (!isSuccess) {
                        NSLog(@"createQueue出问题了");
                        break;
                    }
                }
                
                // 从缓冲区里读
                if (eocBuffersPool.bufferSize < _bufferSize) {
                    // pool数据不够，那么继续解析文件数据
                    continue;
                }
                
                UInt32 packetCount = 0;
                AudioStreamPacketDescription *packetDescription;
                
                NSData *streamData = [eocBuffersPool dequeuePoolStreamPacketDataSize:(UInt32)_bufferSize packetCount:&packetCount audioStreamPacketDescription:&packetDescription];
                
                if (streamData) {
                    isSuccess = [eocAudioQueueRead playerAudioQueue:streamData numPackets:packetCount packetDescription:packetDescription];
                    if (!isSuccess) {
                        NSLog(@"playerAudioQueue fail");
                        break;
                    }
                    
                }else {
                    
                    NSLog(@"dequeuePoolStream fail");
                    break;
                    
                }
                
            }
        }
        
        
    }
    
    NSLog(@"finish");
}


// 4 数据缓存区
- (void)eocAudioStreamParseForPackets:(NSArray *)packetAry{
    
    [eocBuffersPool enqueuePoolStreamPacketsAry:packetAry];
    
}


- (IBAction)audioPlay:(UIButton*)sender{

    if (sender.tag == 0) {
        _playing = YES;
        [_audioThread start];
        sender.tag = 1;
    }
    
}

- (IBAction)audioStop:(id)sender{
    
}



@end
