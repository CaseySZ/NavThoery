//
//  ViewController.h
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <AudioToolbox/AudioToolbox.h>

/*
 
 实时播放（3）语音播放
 播放（AudioQueue）／缓冲buffer
 
 概念：
 一 音频文件的生成过程是将声音信息采样、量化和编码产生的数字信号的过程
 人耳所能听到的声音，最低的频率是从20Hz起一直到最高频率20KHZ，因此音频文件格式的最大带宽是20KHZ。
 根据奈奎斯特的理论，只有采样频率高于声音信号最高频率的两倍时，才能把数字信号表示的声音还原成为原来的声音，
 所以音频文件的采样率一般在40~50KHZ，比如最常见的CD音质采样率44.1KHZ。
 
 
 二 对声音进行采样、量化过程被称为脉冲编码调制（Pulse Code Modulation）简称PCM，
 PCM是最原始的音频数据完全无损，所以PCM数据虽然音质优秀但体积庞大
 然后就诞生了一系列的音频格式，如MP3（有损压缩）目前最为常用的音频格式之一   aac
 
 AudioQueue
 
 
 三 MP3格式中的码率（BitRate）代表了MP3数据的压缩质量，现在常用的码率有128kbit/s、160kbit/s、320kbit/s等等，这个值越高声音质量也就越高
  计算播放总时间 （音频数据）
 
 四 MP3格式中的数据通常由两部分组成:
 一部分为ID3用来存储歌名、演唱者、专辑、音轨数等信息
 另一部分为音频数据 （DataOffset = 7  company1234567）（1 ， 2）
 DataOffset +（我选择的时间点／总时间）*（音频数据总长度） seek（）
 
 五 音频数据部分以帧(frame)为单位存储，每个音频都有自己的帧头
 帧头其中存储了采样率等解码必须的信息,所以每一个帧都可以独立于文件存在和播放
 帧头之后存储着音频数据，这些音频数据是若干个PCM数据帧经过压缩算法压缩得到的
 
 
 之上我们就可以了解到的音频播放流程（MP3为例）
 1 读取MP3文件（data 每次读一千bytes）
 2 解析采样率、码率、时长等信息，分离MP3中的音频帧（看上四） （audioParse，一个文件头，音频文件数据（帧头，音频帧数据））
 
 3 对分离出来的音频帧解码得到PCM数据（看上五）
 4 对PCM数据进行音效处理（均衡器、混响器等，非必须）
 5 把PCM数据解码成音频信号
 6 把音频信号交给硬件播放 （播放 AudioQueue）
 7 重复1-6步直到播放完成
 
 业务：
 1 可以边播放边下载
 2 从4步骤可以来做音效处理,需要把音频数据转换成PCM数据，
 再由AudioUnit+AUGraph来进行音效处理和播放
 */

@interface ViewController : UIViewController


@end

