//
//  EOCAudioSession.m
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCAudioSession.h"
#import <AVFoundation/AVFoundation.h>

@implementation EOCAudioSession{
    
    //AVAudioSession
}


- (instancetype)init{
    
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avAudioSessionRouteChangeNotification:) name:AVAudioSessionRouteChangeNotification object:nil];
        
    }
    
    return self;
}


- (void)avAudioSessionInterruptionNotification:(NSNotification*)notifi{
    
    NSLog(@"打断了");
}

- (void)avAudioSessionRouteChangeNotification:(NSNotification*)notifi{
    
    NSLog(@"耳机／蓝牙");
}

- (BOOL)eocAVAudioSessionActive:(BOOL)active{
    
    AVAudioSession *avAudioSeesion = [AVAudioSession sharedInstance];
    
    NSError *error = nil;
    
    [avAudioSeesion setActive:active error:&error];
    if (error) {
        NSLog(@"AVAudioSession setActive fail:%@", error);
        return NO;
    }
    return YES;
}

- (BOOL)configAVAudioSessionCategory:(NSString*)category{
    
    AVAudioSession *avAudioSeesion = [AVAudioSession sharedInstance];
    NSError *error = nil;
    [avAudioSeesion setCategory:category error:&error];
    if (error) {
        NSLog(@"AVAudioSession setCategory fail:%@", error);
        return NO;
    }
    return YES;
}

@end
