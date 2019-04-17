//
//  EOCChatIMViewCtr.h
//  EOCIMClient
//
//  Created by sunyong on 17/2/12.
//  Copyright © 2017年 @八点钟学院. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCTextView.h"
#import "UIView+FC.h"

/*
 一、
 inputAccessView 的两种方案
 1、当UITextField的inputAccessView 属性，但是当键盘收起的时候，要重新利用inputAccessView界面，重新利用时会出现 约束bug， 因为加载到键盘上，系统重新给inputAccessView约束，需要处理相关约束，这样就和UITextField和键盘之前有绑定关系了（仿朋友圈的做法）
 
 2 直接监听键盘的frame变化来处理，耦合度比1小
 
 */

/*
 注意：（先看效果UITextView有问题）
 结果：用UITextView计算文字高都有问题，实际用来的编写文本的宽度要减去6
 看UITextview内部结构
 */

/*
 二、
    聊天cell 布局问题：
    1 时间和内容
    2 xib布局
    3 数据Model和UI逻辑分开处理
 */



/*
 三、
 键盘出现 聊天table滑动问题：
  两种情况： 1 contentoffset滑动+tableview本上滑动（消息记录很少的情况下）
           2 只tableview本身（消息记录很多了）
 
  但在滑动的过程中，会遇到tableview滑不到最低下
 
  收键盘相关处理（点击和滑动都需要收起键盘）
 
 */



/*
 四、
 消息数据加载问题：
 1 新消息加载UI布局（算位置总少几个像素，解决方案看.m文件）
 2 加载更多数据UI滑动
 3 被动接收消息UI是否滑动到底下
 4 根据reload带来的问题，可以优化（把高度在线程中算出，存放到sql中， 可以防止在主线程中做更多的事情）
 */

/*
 五、
 键盘处理：系统和自定义键盘
 1 先把逻辑放在一个地方处理
 2 然后按照业务把逻辑放开处理包括：1显示自己键盘；2显示系统键盘；3隐藏键盘
 
 数据库：
 
 */

/*
 六、
 添加网络层
 
 */

@interface EOCChatIMViewCtr : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    UITableView *_tableView;
    IBOutlet UIView *_inputAccessView;
    IBOutlet UIView *keyBoardHeadV;
    IBOutlet FCTextView *fcTextView;
    IBOutlet UIView *keyBoardMultiV;
    
    IBOutlet UIView *_keyBoardAudio_V;
    
    IBOutlet UIView *_loadHeadView;
    IBOutlet UILabel *_loadStatusLb;
    IBOutlet UIActivityIndicatorView *_loadActivityView;
    
    // 键盘动画Bug，inputAccessView
    float positionY; // 键盘顶部的位置
    float keyHight; // 键盘顶部的位置
    
    
    NSMutableArray *_messageDataAry;
    BOOL _isLoadingMoreMessage;// YES 正在加载更多数据
    BOOL _isChangeEocKeyBoard; // YES 切换自己键盘
    BOOL _isKeyBoardShow; // YES 键盘已经显示

}


/*
    UIKeyboardWillChangeFrameNotification
 */


- (IBAction)eocKeyboardEvent:(UIButton*)sender;
@end
