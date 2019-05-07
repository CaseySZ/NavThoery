//
//  BaseInfoViewCtr.m
//  Animation
//
//  Created by Casey on 06/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "BaseInfoViewCtr.h"
#import <CoreGraphics/CoreGraphics.h>

@interface BaseInfoViewCtr (){
    
    
    IBOutlet UIView *_redView;
    IBOutlet UIView *_yellowView;
    
    CALayer *_calayer;
}

@end

@implementation BaseInfoViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
   
    self.title = @"Base";
    //_calayer.backgroundColor
    
    
    CALayer *_blackLayer = [[CALayer alloc] init];
    _blackLayer.backgroundColor = UIColor.blackColor.CGColor;
    _blackLayer.frame = CGRectMake(100, 300, 200, 200);
    [self.view.layer addSublayer:_blackLayer];

    
    CALayer *_blueLayer = [CALayer layer];
    _blueLayer.backgroundColor = UIColor.blueColor.CGColor;
    _blueLayer.frame = CGRectMake(30, 30, 60, 60);
    [_blackLayer addSublayer:_blueLayer];
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    
}



@end
