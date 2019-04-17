//
//  ChatMessageCell.h
//  EOCIMClient
//
//  Created by class on 15/02/2017.
//  Copyright © 2017 @八点钟学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessagModel.h"

@interface ChatMessageCell : UITableViewCell{
    
    IBOutlet UIView *_portraitView;
    IBOutlet UIImageView *_protraitImageV;// 图像
    
    IBOutlet UIView *_messageContentV;// 内容View
    IBOutlet UIImageView *_bubbleImageV;// 消息汽泡图片
    IBOutlet UILabel *_messageContentLb; // 文本内容
    IBOutlet UIImageView *_messageContentImageV;// 图片内容
}

//为了提高效率，应该在model中记录下计算的高度和宽度，不需要重复计算
+ (CGFloat)cellHeight:(ChatMessagModel*)messageModel;

@property (nonatomic, strong)ChatMessagModel *messageModel;


@end
