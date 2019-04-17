//
//  AudioPlayerViewCtr.h
//  TongDao
//
//  Created by HNY on 13-9-17.
//  Copyright (c) 2013年 HNY. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AudioStreamer;

@interface AudioPlayerViewCtr : UIViewController
{
    NSString *CurrentUrlStr;
    AudioStreamer *streamer;
	NSTimer *progressUpdateTimer;
    
	NSString *currentArtist;
	NSString *currentTitle;
    
    IBOutlet UILabel *titleLb;
    
    IBOutlet UIButton *playerBt;
    
    NSMutableArray *musicQueAry;
    
    int currentPosition;
    
    IBOutlet UIActivityIndicatorView *activeView;
    
    IBOutlet UIView *stopAllView;
    BOOL playing; /// music status
}


- (IBAction)play:(UIButton*)sender;
- (IBAction)before:(UIButton*)sender;
- (IBAction)next:(UIButton*)sender;

@end
