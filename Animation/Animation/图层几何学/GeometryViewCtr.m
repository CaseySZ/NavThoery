//
//  GeometryViewCtr.m
//  Animation
//
//  Created by Casey on 06/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "GeometryViewCtr.h"

@interface GeometryViewCtr (){
    
    UIView *_contentView;
    
    
    IBOutlet UIView *_hourView;
    IBOutlet UIView *_minuteView;
    IBOutlet UIView *_secondView;
    
}

@end



@implementation GeometryViewCtr

- (void)viewDidLoad {

    [super viewDidLoad];
    self.title = @"Geometry";
    
    UIBarButtonItem *transformBt = [[UIBarButtonItem alloc] initWithTitle:@"transform" style:UIBarButtonItemStylePlain target:self action:@selector(transform)];
    UIBarButtonItem *zPositionBt = [[UIBarButtonItem alloc] initWithTitle:@"zPosition" style:UIBarButtonItemStylePlain target:self action:@selector(zPosition)];
    UIBarButtonItem *tickBt = [[UIBarButtonItem alloc] initWithTitle:@"tick" style:UIBarButtonItemStylePlain target:self action:@selector(tick)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:transformBt, zPositionBt, tickBt, nil];
    
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    _contentView.backgroundColor = UIColor.blueColor;
    [self.view addSubview:_contentView];
    
    
  
    
}

/*
 旋转后的frame变化
 */
- (void)transform {
    
    _contentView.transform = CGAffineTransformMakeRotation(M_PI/4);
    
 
}

// 钟表demo
- (void)tick{
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart) userInfo:nil repeats:YES];
    
    _hourView.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    _minuteView.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    _secondView.layer.anchorPoint = CGPointMake(0.5f, 0.9f);
    
    [self timerStart];
    
}

- (void)timerStart {
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger units = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date]];
    CGFloat hoursAngle = (components.hour / 12.0) * M_PI * 2.0;
    CGFloat minsAngle = (components.minute / 60.0) * M_PI * 2.0;
    CGFloat secsAngle = (components.second / 60.0) * M_PI * 2.0;
    
    _hourView.transform = CGAffineTransformMakeRotation(hoursAngle);
    _minuteView.transform = CGAffineTransformMakeRotation(minsAngle);
    _secondView.transform = CGAffineTransformMakeRotation(secsAngle);
    
}




// Z坐标轴

- (void)zPosition {
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    redView.backgroundColor = UIColor.redColor;
    [self.view addSubview:redView];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 200, 200)];
    blueView.backgroundColor = UIColor.blueColor;
    [self.view addSubview:blueView];
    
    redView.layer.zPosition = 1.0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
    
}




@end
