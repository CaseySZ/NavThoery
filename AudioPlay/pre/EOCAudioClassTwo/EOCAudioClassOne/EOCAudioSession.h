//
//  EOCAudioSession.h
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 AVAudioSessionCategoryAmbient; 遵从静音
混音播放，如雨声 与其他音效一起播放
	
 AVAudioSessionCategorySoloAmbient; 遵从静音
独占音乐播放
 
 AVAudioSessionCategoryPlayback;
// 音乐播放
 AVAudioSessionCategoryRecord;
录制
 AVAudioSessionCategoryPlayAndRecord （微信语音用这种模式）
 // 播放+录制音频
 
 AVAudioSessionCategoryAudioProcessing
 硬件编码处理音频
 
 */

@interface EOCAudioSession : NSObject{
    

}


- (BOOL)eocAVAudioSessionActive:(BOOL)active;
- (BOOL)configAVAudioSessionCategory:(NSString*)category;
@end
