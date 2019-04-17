//
//  ChatMessageTimeCell.m
//  EOCIMClient
//
//  Created by class on 17/02/2017.
//  Copyright © 2017 @八点钟学院. All rights reserved.
//

#import "ChatMessageTimeCell.h"

@implementation ChatMessageTimeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (CGFloat)cellHeight{    
    return 30;
}

- (void)setTimeStamp:(NSTimeInterval)timeStamp{
    
    _timeStamp = timeStamp;
    _timeLb.text = [NSString stringWithFormat:@"%@", [NSNumber numberWithDouble:timeStamp]];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
