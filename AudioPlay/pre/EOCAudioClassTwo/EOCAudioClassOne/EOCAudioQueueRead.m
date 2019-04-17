//
//  EOCAudioQueueRead.m
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCAudioQueueRead.h"


static void EOCAudioQueueOutputCallback(void * __nullable inUserData,
                                        AudioQueueRef inAQ,
                                        AudioQueueBufferRef inBuffer){
    
    EOCAudioQueueRead *queueRead = (__bridge EOCAudioQueueRead*)inUserData;
    
    [queueRead eocAudioQueueOutputCallback:inBuffer];
    
}

static void EOCAudioQueuePropertyListenerProc(void * __nullable       inUserData,
                                              AudioQueueRef           inAQ,
                                              AudioQueuePropertyID    inID){
    
    EOCAudioQueueRead *queueRead = (__bridge EOCAudioQueueRead*)inUserData;
    [queueRead handleAudioPropertyStatus:inID];
}


@interface EOCAudioQueueReadModel : NSObject
@property (nonatomic, assign)AudioQueueBufferRef buffer;
@end

@implementation EOCAudioQueueReadModel
@end

@implementation EOCAudioQueueRead


- (instancetype)init{
    
    self = [super init];
    if (self) {
        _condition = [[NSCondition alloc] init];
        _bufferQueue = [NSMutableArray array];
        _reuserBufferQueue = [NSMutableArray array];
        [self _mutexInit];
    }
    return self;
}


- (BOOL)createQueue:(AudioStreamBasicDescription)basicDescription bufferSize:(UInt32)bufferSize{
    
    _baiseDescription = basicDescription;
    /// 可以配置回调runloop
    OSStatus status = AudioQueueNewOutput(&basicDescription, EOCAudioQueueOutputCallback, (__bridge void*)self, NULL, NULL, 0, &_audioQueue);
    if (status != noErr) {
        NSLog(@"AudioQueueNewOutput error");
        _audioQueue = nil;
        return NO;
    }
    status = AudioQueueStart(_audioQueue, NULL);
    if (status != noErr) {
        AudioQueueDispose(_audioQueue, YES);
        _audioQueue = nil;
        return NO;
    }
    _bufferSize = bufferSize;
    if (_bufferQueue.count == 0) {
        
        for (int i = 0; i < EOCNumAQBufs; i++) {
            AudioQueueBufferRef buffer;
            status = AudioQueueAllocateBuffer(_audioQueue, bufferSize, &buffer);
            EOCAudioQueueReadModel *queueReadModel = [[EOCAudioQueueReadModel alloc] init];
            queueReadModel.buffer = buffer;
            
            [_bufferQueue addObject:queueReadModel];
            [_reuserBufferQueue addObject:queueReadModel];
        }
    }
    
    return YES;
}


- (BOOL)playerAudioQueue:(NSData*)audioData numPackets:(UInt32)numPackets packetDescription:(AudioStreamPacketDescription*)packetDescs{
    
    if (_reuserBufferQueue.count == 0) {
        [self _mutexWait];
    }
    
    EOCAudioQueueReadModel *queueReadModel = [_reuserBufferQueue firstObject];
    // 课堂Class bug代码,视频里removeObject的是_reuserBufferQueue，导致声音混乱了
    //  [_reuserBufferQueue removeObject:_reuserBufferQueue];
    [_reuserBufferQueue removeObject:queueReadModel];
    
    
    memcpy(queueReadModel.buffer->mAudioData, [audioData bytes], audioData.length);
    queueReadModel.buffer->mAudioDataByteSize = (UInt32)audioData.length;
    
    OSStatus status = AudioQueueEnqueueBuffer(_audioQueue, queueReadModel.buffer, numPackets, packetDescs);
    if (status != noErr) {
        NSLog(@"AudioQueueEnqueueBuffer error");
        return NO;
    }else{
        if (_reuserBufferQueue.count == 0)
        {
            if (!_started && ![self _start])
            {
                return NO;
            }
        }
    }
    return YES;
}


- (void)eocAudioQueueOutputCallback:(AudioQueueBufferRef)inBuffer{
    
    for (int i = 0; i < _bufferQueue.count; i++) {
        
        EOCAudioQueueReadModel *readModel = _bufferQueue[i];
        if (readModel.buffer == inBuffer) {
            // 重新利用
            [_reuserBufferQueue addObject:readModel];
            break;
        }
    }
    // 有新的可以利用了
    
    [self _mutexSignal];
    // [_condition signal];
    // NSLog(@"signal~");
}


- (void)handleAudioPropertyStatus:(AudioQueuePropertyID)inID{
    
    
    if(inID == kAudioQueueProperty_IsRunning){
        
        UInt32 running = 0;
        UInt32 size = sizeof(running);
        AudioQueueGetProperty(_audioQueue, inID, &running, &size);
        NSLog(@"kAudioQueueProperty_IsRunning:%d", running);
        
    }
    
}


- (BOOL)_start{
    
    OSStatus status =  AudioQueueStart(_audioQueue, NULL);
    _started = status == noErr;
    return _started;
}

- (void)_mutexInit{
    
    pthread_mutex_init(&_mutex, NULL);
    pthread_cond_init(&_cond, NULL);
    
}

- (void)_mutexDestory
{
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_cond);
}

- (void)_mutexWait{
    
    pthread_mutex_lock(&_mutex);
    NSLog(@"我在等待");
    pthread_cond_wait(&_cond, &_mutex);
    pthread_mutex_unlock(&_mutex);

}


- (void)_mutexSignal{
    
    pthread_mutex_lock(&_mutex);
    NSLog(@"不用等待了");
    pthread_cond_signal(&_cond);
    pthread_mutex_unlock(&_mutex);
    
}

@end
