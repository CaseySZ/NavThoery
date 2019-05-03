//
//  LockLogButton.m
//  SafeGesture
//
//  Created by Casey on 26/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import "LockLogButton.h"

@implementation LockLogButton


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
    self.imageView.frame = CGRectMake(self.frame.size.width/2 - 60/2, 0, 60, 60);
    self.titleLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 20, self.frame.size.width, 16);
    
}


@end
