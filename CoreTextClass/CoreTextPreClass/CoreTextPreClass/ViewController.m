//
//  ViewController.m
//  CoreTextPreClass
//
//  Created by EOC on 2017/4/18.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "ViewController.h"
#import "EOCTextLabel.h"


@interface ViewController (){
    
    EOCTextLabel *eocTextLb;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    eocTextLb = [[EOCTextLabel alloc] initWithFrame:CGRectMake(0, 100, 375, 300)];
    eocTextLb.backgroundColor = [UIColor redColor];
    eocTextLb.clipsToBounds = YES;
    
    [self.view addSubview:eocTextLb];
    

}







@end
