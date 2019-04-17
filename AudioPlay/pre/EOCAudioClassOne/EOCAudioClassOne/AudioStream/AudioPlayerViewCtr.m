//
//  AudioPlayerViewCtr.m
//  TongDao
//
//  Created by HNY on 13-9-17.
//  Copyright (c) 2013年 HNY. All rights reserved.
//

#import "AudioPlayerViewCtr.h"
#import "AudioStreamer.h"
#import <QuartzCore/CoreAnimation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <CFNetwork/CFNetwork.h>

@interface AudioPlayerViewCtr ()

@end

@implementation AudioPlayerViewCtr

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    musicQueAry = [[NSMutableArray alloc] init];
    [musicQueAry addObject:@"http://www.comdesignlab.com/travel/wp-content/uploads/1027/YouGeXing.mp3"];
    [musicQueAry addObject:@"http://www.comdesignlab.com/travel/wp-content/uploads/1026/YouGeXing_edit.mp3"];
    [musicQueAry addObject:@"http://www.comdesignlab.com/travel/wp-content/uploads/1025/Happy_Bamboo_n_Leaf.mp3"];
    
    currentPosition = 0;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged:) name:ASStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorMessage:) name:ASPresentAlertWithTitleNotification object:nil];
    
    // update the UI in case we were in the background
	NSNotification *notification = [NSNotification notificationWithName:ASStatusChangedNotification object:self];
	[[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (IBAction)play:(UIButton *)sender
{
    if (!playing)
	{
        playing = YES;
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_purpose_defult.png"] forState:UIControlStateNormal];
        if (streamer.state == AS_INITIALIZED)
        {
            if (currentPosition < musicQueAry.count && currentPosition >= 0)
            {
                [self createStreamer:[musicQueAry objectAtIndex:currentPosition]];
            }
        }
		[streamer start];
	}
	else
	{
        playing = NO;
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_play_defult.png"] forState:UIControlStateNormal];
		[streamer pause];
	}
}

static BOOL presOpOver = YES;
- (IBAction)before:(UIButton*)sender
{
    if (!presOpOver)
        return;
    if (musicQueAry.count == 0)
    {
        [activeView startAnimating];
        return;
    }
    presOpOver = NO;
    [streamer stop];
    currentPosition--;
    if (currentPosition < 0)
        currentPosition = musicQueAry.count - 1;
    if (currentPosition < musicQueAry.count && currentPosition >= 0)
    {
        [self createStreamer:[musicQueAry objectAtIndex:currentPosition]];
    }
    [streamer start];
    
    playing = YES;
    [playerBt setBackgroundImage:[UIImage imageNamed:@"music_purpose_defult.png"] forState:UIControlStateNormal];
    [self performSelector:@selector(delaysPreOpration) withObject:nil afterDelay:1.5];
    
}

- (void)delaysPreOpration
{
    presOpOver = YES;
}

static BOOL nextOpOver = YES;
- (IBAction)next:(UIButton*)sender
{
    if (musicQueAry.count == 0)
    {
        [activeView startAnimating];
        return;
    }
    if (!nextOpOver)
        return;
    nextOpOver = NO;
    [streamer stop];
    currentPosition++;
    if (currentPosition >= musicQueAry.count)
        currentPosition = 0;
    if (currentPosition < musicQueAry.count && currentPosition >= 0)
    {
        [self createStreamer:[musicQueAry objectAtIndex:currentPosition]];
    }
    [streamer start];
    
     playing = YES;
    [playerBt setBackgroundImage:[UIImage imageNamed:@"music_purpose_defult.png"] forState:UIControlStateNormal];
    [self performSelector:@selector(delaysNextOpration) withObject:nil afterDelay:1.5];
}

- (void)delaysNextOpration
{
     nextOpOver = YES;
}
#pragma mark - streame
// Creates or recreates the AudioStreamer object.
- (void)createStreamer:(NSString*)audioUrlStr
{
    if (!streamer){
        streamer = [[AudioStreamer alloc] init];
    }
	[self destroyStreamer];
    audioUrlStr = [audioUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *escapedValue = audioUrlStr;
    
	NSURL *url = [NSURL URLWithString:escapedValue];
    [streamer reloadURL:url];
	[self createTimers:YES];
    
}

// Removes the streamer, the UI update timer and the change notification
//
- (void)destroyStreamer
{
	if (streamer){
		[self createTimers:NO];
	}
}

- (void)updateProgress:(id)time
{
    if (streamer.bitRate != 0.0)
    {
		double duration = streamer.duration;
		if (duration > 0){
		}
		else{
		}
	}
	else{
		
	}
}

// Creates or destoys the timers
//
-(void)createTimers:(BOOL)create
{
	if (create)
    {
		if (streamer)
        {
            [self createTimers:NO];
            progressUpdateTimer =
            [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress:) userInfo:nil repeats:YES];
		}
	}
	else
    {
		if (progressUpdateTimer)
		{
			[progressUpdateTimer invalidate];
			progressUpdateTimer = nil;
		}
	}
}

- (void)playbackStateChanged:(NSNotification *)aNotification
{
	if ([streamer isWaiting])
	{
        [activeView startAnimating];
	}
	else if ([streamer isPlaying])
	{
        playing = YES;
        [activeView stopAnimating];
	}
	else if ([streamer isPaused])
    {
        [activeView stopAnimating];
        playing = NO;
	}
	else if ([streamer isIdle])
	{
        playing = NO;
        [activeView stopAnimating];
        [playerBt setBackgroundImage:[UIImage imageNamed:@"music_play_defult.png"] forState:UIControlStateNormal];
		[self destroyStreamer];
	}
}

- (void)errorMessage:(NSNotification*)notification
{
    NSDictionary *infoDict = [notification userInfo];
    [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_play_normal.png"] forState:UIControlStateNormal];
    [playerBt setBackgroundImage:[UIImage imageNamed:@"music_btn_play_pressed.png"] forState:UIControlStateHighlighted];
    [streamer pause];
    if ([[infoDict objectForKey:@"title"] isEqualToString:@"File Error"])
    {
        [self performSelector:@selector(imply:) onThread:[NSThread mainThread] withObject:@"获取不到音乐数据" waitUntilDone:NO];
    }
}

- (void)imply:(NSString*)infoStr
{
    @autoreleasepool {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:infoStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

#pragma mark Remote Control Events
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
	switch (event.subtype) {
		case UIEventSubtypeRemoteControlTogglePlayPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlPlay:
			[streamer start];
			break;
		case UIEventSubtypeRemoteControlPause:
			[streamer pause];
			break;
		case UIEventSubtypeRemoteControlStop:
			[streamer stop];
			break;
		default:
			break;
	}
}

- (void)dealloc
{
    [self destroyStreamer];
	[self createTimers:NO];
}

@end
