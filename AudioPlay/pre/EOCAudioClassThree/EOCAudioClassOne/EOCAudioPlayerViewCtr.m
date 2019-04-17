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
    
    _eocAudioStreamNet = [[EOCAudioStreamNet alloc] init];
    _eocAudioStreamNet.delegate = self;
    
    //  seek
    
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
    while (_fileSize > 0 ) {
        
        // 2 读音频文件 1000字节 fileHandle
        NSData *data = nil;
        if (!isEOF) {
            
            /*
             从网络读取数据
             网络速度很慢，数据如果没有达到 500，要阻塞，等网络下好数据，在启动
             网络很快，就没问题
             */
            //data = [fileHandle readDataOfLength:500];
            data = [_eocAudioStreamNet readDataOfLength:500 isPlay:_playing];// 0-1000, 1000 -2000
            
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
                    if (packetDescription != NULL) {
                        free(packetDescription);
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


- (void)seekFileOffset:(long)offset{
    
    [_eocAudioStreamNet startLoadMusic:EOCMusicURL offset:0];
   
    // 处理audioQueue
    eocAudioStreamParse.isContinue = NO;
    
}



- (IBAction)audioPlay:(UIButton*)sender{

    if (sender.tag == 0) {
        
        // 点击播放，启动网络
        /*
          1一些基本数据在响应头  配置如文件大小，或者文件类型
          2 数据准备好了，开启播放音乐线程
         */
        
        //[_audioThread start];
        sender.tag = 1;
        _playing = YES;
        [_eocAudioStreamNet startLoadMusic:EOCMusicURL offset:0];
    }
    
}

- (IBAction)audioStop:(id)sender{
    
   // [self seekFileOffset:100000];
    _playing = NO;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)netHandleDataWithResponse:(NSDictionary*)headerFiledDict{
    
    _fileSize = [[headerFiledDict objectForKey:@"Content-Length"] longLongValue];
    if (_playing) {
        if (!_audioThread.executing) {
            [_audioThread start];
        }
        
    }
   
    
    
}

- (void)newHandleDataWithRecevieData:(NSData*)data{
    
    
}
- (void)netHandleFinish:(NSError*)error{
    
}


- (void)dealloc {
    
    NSLog(@"dealloc");
}


@end
