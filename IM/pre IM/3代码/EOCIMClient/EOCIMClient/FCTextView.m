//
//  FCTextView.m
//  WeiXinFriendCircle
//
//  Created by sunyong on 17/1/4.
//  Copyright © 2017年 @八点钟学院. All rights reserved.
//

#import "FCTextView.h"

@implementation FCTextView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        placeholderLb = [[UILabel alloc] init];
        placeholderLb.backgroundColor = [UIColor clearColor];
        placeholderLb.textColor = [UIColor lightTextColor];
        placeholderLb.font = [UIFont systemFontOfSize:12];
        [self addSubview:placeholderLb];
        
    }
    return self;
}



- (void)layoutSubviews{
    
    
    
}


@end
