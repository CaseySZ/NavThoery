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
    
    
    eocAudioSession = [EOCAudioSession new];
    eocAudioStreamParse = [[EOCAudioStreamParse alloc] initWithFile:kAudioFileMP3Type filezize:(UInt32)_fileSize];
    
    eocAudioStreamPacketBuffers = [EOCAudioStreamPacketBuffers new];
    eocAudioQueueRead = [EOCAudioQueueRead new];
    
}



- (void)audioThread{
    
    
    // 1 建立audioSession 会话
    
    BOOL isSuccess = [eocAudioSession configAVAudioSessionCategory:AVAudioSessionCategoryPlayback];
    if (!isSuccess) {
        return;
    }
    isSuccess = [eocAudioSession eocAVAudioSessionActive:YES];
    if (!isSuccess) {
        return;
    }
    
    BOOL isEOF = NO;
    // 需要文件size，和一个偏移量，知道文件的eof
    while (_fileSize > 0) {
        
        // 2 读音频文件 1000字节 fileHandle
        NSData *data = nil;
        if (!isEOF) {
            
            data = [fileHandle readDataOfLength:1000];// 0-1000, 1000 -2000
            _fileOffset += data.length;
            if (_fileOffset >= _fileSize) {
                isEOF = YES;
                NSLog(@"finish EOF");
            }
        }
        
        // 3 解析 eocAudioStreamParse
        isSuccess = [eocAudioStreamParse parserAudioStream:data];
        if (!isSuccess) {
            NSLog(@"解析数据出问题了");
            break;
        }
        
        // 数据缓存区
        
        // 5 读数据（从缓冲区里读）
        // 5.1 需要判断是否已经解析完文件头
        
        if ([eocAudioStreamParse isReadyProductPacket]) {
            // 4.2 读音频数据
            
            
        }
        
        
    }
    
}


- (IBAction)audioPlay:(id)sender{
    
}

- (IBAction)audioStop:(id)sender{
    
}



@end
