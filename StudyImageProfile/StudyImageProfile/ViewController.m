//
//  ViewController.m
//  StudyImageProfile
//
//  Created by Casey on 17/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

#import "ViewController.h"
#import "TwoViewCtr.h"

@interface ViewController (){
    
    IBOutlet UIImageView *_imageView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
    //_imageView.image = [UIImage imageNamed:@"11.jpg"];
    
    [self.navigationController pushViewController:[TwoViewCtr new] animated:YES];
    
    
}

@end
