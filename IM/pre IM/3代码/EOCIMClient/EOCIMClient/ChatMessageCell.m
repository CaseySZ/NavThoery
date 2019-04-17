//
//  ChatMessageCell.m
//  EOCIMClient
//
//  Created by class on 15/02/2017.
//  Copyright © 2017 @八点钟学院. All rights reserved.
//

#import "ChatMessageCell.h"
#import "UIView+FC.h"

#define BubbleImageInsetRecv   UIEdgeInsetsMake(35, 35, 5, 5)
#define BubbleImageInsetSender UIEdgeInsetsMake(35, 5, 5, 35)


@implementation ChatMessageCell


//+ (void)initialize{
//    
//    ChatMessageCell *cell = [self appearance];
//}

- (void)awakeFromNib {
    [super awakeFromNib];
}

#define CellMinHeight 40 // cell最小高度
#define CellPortraitWidth 80// MessageView离左右两边的距离50+30
#define CellBulletToTextGap 40// 气泡到message内容的距离,左右各20，所以总距离40

// 计算高度  为了性能考虑，宽度计算放到model赋值的时候做
+ (CGFloat)cellHeight:(ChatMessagModel*)messageModel{
    
    if (messageModel.contentHeight > 0) {
        return messageModel.contentHeight;
    }
    float heigth = CellMinHeight;
    if (messageModel.messageType == MessageTextType) {
        
        float messageContentMaxWidth = [UIScreen mainScreen].bounds.size.width - CellPortraitWidth - CellBulletToTextGap; //
        heigth = [UIView backLinesHighInView:messageContentMaxWidth string:messageModel.textContent font:[UIFont systemFontOfSize:16]];
        heigth += 10;
        if (heigth < CellMinHeight)
            heigth = CellMinHeight;
        messageModel.contentHeight = heigth;
        
    }else if(messageModel.messageType == MessageImageType){
        
        
    }
    
    
    return heigth;
    
}

// Model 数据逻辑处理
- (void)setMessageModel:(ChatMessagModel *)messageModel{
    
    _messageModel = messageModel;
    if (messageModel.messageType == MessageTextType) {
        
        _messageContentLb.hidden = NO;
        _messageContentLb.text = messageModel.textContent;
        if (messageModel.contentWidth == 0) {
            /* 
             整个contentWidth消息宽度即_messageContentV的宽度
             就是内容宽度 + 离左边气泡距离20 + 离右边气泡距离20
             */
           
            float messageContentMaxWidth = [UIScreen mainScreen].bounds.size.width - 2*_portraitView.frame.size.width - CellBulletToTextGap;
            float contentWidth = [UIView backWidthInViewString:_messageContentLb.text font:_messageContentLb.font];
            if (contentWidth < messageContentMaxWidth - 10) {
                _messageModel.contentWidth = contentWidth + CellBulletToTextGap;
            }else{
                _messageModel.contentWidth = messageContentMaxWidth + CellBulletToTextGap;
            }
        }
    }else if(messageModel.messageType == MessageTextType){
        
        _messageContentLb.hidden = YES;
        _messageContentLb.text = @"";
        if (_messageModel.contentWidth == 0) {
            _messageModel.contentWidth = 100; // 默认图片宽度100
        }
        
    }else{
        
        
    }
    [self setNeedsLayout];
}

// Model 界面处理
- (void)layoutSubviews{
    
    if (_messageModel.isRecv) {
        [self setRecvLayoutView];
    }else{
        [self setSenderLayoutView];
    }
    
}

- (void)setSenderLayoutView{
   
    [_portraitView setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - _portraitView.frame.size.width, 0, _portraitView.frame.size.width, _portraitView.frame.size.height)];
    
    if (_messageModel.messageType == MessageTextType) {
        
        float contentWidth = _messageModel.contentWidth;
        [_messageContentV setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - _portraitView.frame.size.width - contentWidth, 0, contentWidth, self.frame.size.height)];
    }
    
    UIImage *image = [UIImage imageNamed:@"chat_sender_bg.png"];
    image = [image resizableImageWithCapInsets:BubbleImageInsetSender];
    _bubbleImageV.image = image;
}

- (void)setRecvLayoutView{
    
    [_portraitView setFrame:CGRectMake(0, 0, _portraitView.frame.size.width, _portraitView.frame.size.height)];
    if (_messageModel.messageType == MessageTextType) {
        
        float contentWidth = _messageModel.contentWidth;
        [_messageContentV setFrame:CGRectMake(CGRectGetMaxX(_protraitImageV.frame), 0, contentWidth, self.frame.size.height)];
    }
    UIImage *image = [UIImage imageNamed:@"chat_receiver_bg.png"];
    image = [image stretchableImageWithLeftCapWidth:35 topCapHeight:35];
    _bubbleImageV.image     = image;
    _messageContentLb.frame = CGRectMake(15, 0, _bubbleImageV.frame.size.width-20, _bubbleImageV.frame.size.height);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
