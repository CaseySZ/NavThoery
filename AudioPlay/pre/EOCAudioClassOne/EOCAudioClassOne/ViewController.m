//
//  ViewController.m
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ViewController.h"
#import "EOCAudioPlayerViewCtr.h"
#import "AudioPlayerViewCtr.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self testAudioStream];
}

- (void)eocAudioStream{
    
    EOCAudioPlayerViewCtr *eocAudioPlayerViewCtr = [EOCAudioPlayerViewCtr new];
    
    [self.view addSubview:eocAudioPlayerViewCtr.view];
    [self addChildViewController:eocAudioPlayerViewCtr];

}

- (void)testAudioStream{
    
    AudioPlayerViewCtr *audioPlayVCtr = [[AudioPlayerViewCtr alloc] init];
    [self.view addSubview:audioPlayVCtr.view];
    audioPlayVCtr.view.frame = ({
        CGRect rect = audioPlayVCtr.view.frame;
        rect.origin.y = 100;
        rect;
    });
    
    [self addChildViewController:audioPlayVCtr];
    
}







@end
