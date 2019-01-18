//
//  TwoViewCtr.m
//  StudyImageProfile
//
//  Created by Casey on 17/01/2019.
//  Copyright © 2019 newplatform. All rights reserved.
//

#import "TwoViewCtr.h"

@interface TwoViewCtr (){
    
    IBOutlet UIImageView *_imageView;
    
    
}

@end

@implementation TwoViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor = UIColor.whiteColor;
    
    self.title = @"Test";
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    
    _imageView.image = [UIImage imageNamed:@"11.jpg"];
    
    
}


@end
