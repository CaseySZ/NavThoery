//
//  ViewController.m
//  EOCAudioClassOne
//
//  Created by EOC on 2017/6/28.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ViewController.h"
#import "EOCAudioPlayerViewCtr.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

 
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    EOCAudioPlayerViewCtr *eocAudioPlayerViewCtr = [EOCAudioPlayerViewCtr new];
    
    [self presentViewController:eocAudioPlayerViewCtr animated:YES completion:nil];
    
}






@end
