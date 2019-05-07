//
//  VisualViewCtr.m
//  Animation
//
//  Created by Casey on 07/05/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "VisualViewCtr.h"

@interface VisualViewCtr (){
    
    
    IBOutlet UIView *_contentView;
    
}

@end

@implementation VisualViewCtr

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _contentView.layer.cornerRadius = 10;
    
}




@end
