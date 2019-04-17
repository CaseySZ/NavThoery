//
//  EOCAudioQueueRead.h
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <pthread.h>

/*
 
 https://developer.apple.com/library/content/documentation/MusicAudio/Conceptual/AudioQueueProgrammingGuide/AboutAudioQueues/AboutAudioQueues.html#//apple_ref/doc/uid/TP40005343-CH5-SW9
 
 读音频数据
 
 AudioQueue的工作模式
 在使用AudioQueue之前首先必须理解其工作模式，它之所以这么命名是因为在其内部有一套缓冲队列BufferQueue的机制。
 在AudioQueue启动之后需要通过AudioQueueAllocateBuffer生成若干个AudioQueueBufferRef结构，
 这些Buffer将用来存储即将要播放的音频数据，
 并且这些Buffer是受生成他们的AudioQueue实例管理的，
 内存空间也已经被分配（按照Allocate方法的参数），
 当AudioQueue被Dispose时这些Buffer也会随之被销毁。
 当有音频数据需要被播放时首先需要被memcpy到AudioQueueBufferRef的mAudioData中
 （mAudioData所指向的内存已经被分配，之前AudioQueueAllocateBuffer所做的工作），
 并给mAudioDataByteSize字段赋值传入的数据大小。
 完成之后需要调用AudioQueueEnqueueBuffer把存有音频数据的Buffer插入到AudioQueue内置的Buffer队列中。
 在Buffer队列中有buffer存在的情况下调用AudioQueueStart，
 此时AudioQueue就回按照Enqueue顺序逐个使用Buffer队列中的buffer进行播放，
 每当一个Buffer使用完毕之后就会从Buffer队列中被移除并且在使用者指定的RunLoop上触发一个回调来告诉使用者，
 某个AudioQueueBufferRef对象已经使用完成，你可以继续重用这个对象来存储后面的音频数据。
 如此循环往复音频数据就会被逐个播放直到结束。
 
 根据Apple提供的AudioQueue工作原理结合自己理解，可以得到其工作流程大致如下：
 1 创建AudioQueue，创建一个自己的buffer数组BufferArray;
 2 使用AudioQueueAllocateBuffer创建若干个AudioQueueBufferRef，放入BufferArray；
 3 有数据时从BufferArray取出一个buffer，memcpy数据后用AudioQueueEnqueueBuffer方法把buffer插入AudioQueue中；
 4 AudioQueue中存在Buffer后，调用AudioQueueStart播放。（具体等到填入多少buffer后再播放可以自己控制，只要能保证播放不间断即可）；
 5 AudioQueue播放音乐后消耗了某个buffer，在另一个线程回调并送出该buffer，把buffer放回BufferArray供下一次使用；
 6 返回步骤3继续循环直到播放结束
 从以上步骤其实不难看出，AudioQueue播放的过程其实就是一个典型的生产者消费者问题。生产者是AudioFileStream，它们生产处音频数据帧，放入到AudioQueue的buffer队列中，直到buffer填满后需要等待消费者消费；AudioQueue作为消费者，消费了buffer队列中的数据，并且在另一个线程回调通知数据已经被消费,生产者可以继续生产。所以在实现AudioQueue播放音频的过程中必然会接触到一些多线程同步、信号量的使用、死锁的避免等等问题。
 
 */

/*
*/

#define EOCNumAQBufs 2

@interface EOCAudioQueueRead : NSObject{
    
    NSMutableArray *_bufferQueue;
    NSMutableArray *_reuserBufferQueue;
    
    NSCondition *_condition;
    
    BOOL _started;
    
    pthread_mutex_t _mutex;
    pthread_cond_t _cond;
    
    AudioStreamBasicDescription _baiseDescription;
     UInt32 _bufferSize; // 设置QueueBufferRef大小
    
    UInt32 _running;
}

@property (nonatomic, assign)AudioQueueRef audioQueue;

- (BOOL)createQueue:(AudioStreamBasicDescription)basicDescription bufferSize:(UInt32)buffeSize ;


- (BOOL)playerAudioQueue:(NSData*)audioData numPackets:(UInt32)numPackets packetDescription:(AudioStreamPacketDescription*)packetDescs;

- (void)eocAudioQueueOutputCallback:(AudioQueueBufferRef)inBuffer;
- (void)handleAudioPropertyStatus:(AudioQueuePropertyID)inID;



@end
