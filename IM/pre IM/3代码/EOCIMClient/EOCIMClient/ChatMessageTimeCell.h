//
//  ChatMessageTimeCell.h
//  EOCIMClient
//
//  Created by class on 17/02/2017.
//  Copyright © 2017 @八点钟学院. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatMessageTimeCell : UITableViewCell{
    IBOutlet UILabel *_timeLb;
}

@property (nonatomic, assign)NSTimeInterval timeStamp;

+ (CGFloat)cellHeight;

@end
