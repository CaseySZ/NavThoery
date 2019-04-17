//
//  EOCChatIMViewCtr.m
//  EOCIMClient
//
//  Created by sunyong on 17/2/12.
//  Copyright © 2017年 @八点钟学院. All rights reserved.
//

#import "EOCChatIMViewCtr.h"

#import "ChatMessageCell.h"
#import "ChatMessageTimeCell.h"

#import "ChatCNetSocketModel.h"
#import "ChatMessagModel.h"

#import "ChatCNetSocketModel.h"
#import "UIView+EOCLayout.h"


#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
@interface EOCChatIMViewCtr ()

@end

@implementation EOCChatIMViewCtr
/*
 a:b  c:b  d:c e:d
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if(![[ChatCNetSocketModel shareChatCModel] connectServerChat]){
        NSLog(@"连接服务器失败");
    }
    fcTextView.returnKeyType = UIReturnKeySend;
    fcTextView.tintColor = [UIColor blackColor];
    
    // IM Notifi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendMessageStatus:) name:ChatMessageSendStatusNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveMessage:) name:ChatMessageReciveNotification object:nil];
    // Keyboard Notifi
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    _messageDataAry = [NSMutableArray array];
    for (int i = 0; i < 6; i ++) {
        ChatMessagModel *model = [[ChatMessagModel alloc] init];
        model.isRecv = i%2;
        model.name = @"eoc";
        model.senderSuccess = YES;
        model.messageType = MessageTextType;
        model.textContent = @"ABCD eididka__DCididka__DCDCidid";
        model.timeStamp = [[NSDate date] timeIntervalSince1970];
        [_messageDataAry addObject:model];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-_inputAccessView.frame.size.height)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self.view bringSubviewToFront:_inputAccessView];
    [self.view bringSubviewToFront:_keyBoardAudio_V];
    
    _keyBoardAudio_V.frame = ({
        CGRect rect = _keyBoardAudio_V.frame;
        rect.origin.y = [UIScreen mainScreen].bounds.size.height - 64;
        rect;
    });
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([_loadHeadView superview] != _tableView) {
        [_loadHeadView removeFromSuperview];
        [_loadHeadView setY:0-_loadHeadView.frame.size.height];
        [_tableView addSubview:_loadHeadView];
    }
}

- (IBAction)eocKeyboardEvent:(UIButton*)sender{
    
    if (_isChangeEocKeyBoard) {
        [UIView animateWithDuration:0.25 animations:^{
            [self keyBoardBothHiddenStatus];
        }];
        
    }else{
        _isChangeEocKeyBoard = YES;
        if (!_isKeyBoardShow) {
            
            [UIView animateWithDuration:0.25 animations:^{
                [self ShowEOCkeyBoard];
            }];
            
        }else {
            [self resignFisrtResp];
        }
    }
}

- (void)resignFisrtResp{
    [fcTextView resignFirstResponder];
}

- (void)senderTextMessage:(NSString*)messageText{
    
    if (messageText.length == 0)
        return;
    
    ChatMessagModel *model = [[ChatMessagModel alloc] init];
    model.isRecv = NO;
    model.senderSuccess = NO;
    model.name = @"eoc";
    model.messageType = MessageTextType;
    model.textContent = messageText;
    model.timeStamp = [[NSDate date] timeIntervalSince1970];
    [_messageDataAry addObject:model];
    
    
    fcTextView.text = @"";
    [self configUIWhenTextInput:0];
    
    /*
     
     bug
     reloadData 并不是真正的contentSize大小，总会小一点
     setNeedLayout（layoutsubviews）
     
     调用reloadData的时候，表的高度是异步在计算的
     所以在获取reloadData操作后获取tableview的contentSize高度有时不太准确
     通过在reloadData方法前后日志输出，和heightForRowAtIndexPath方法日志输出，就能看出是异步的,也不能说是异步，因为layoutsubview，任务添加到runloop时，不在当前runloop的当前循环处理，而是在下一个循环
    */
    
    // 自己计算table的content高度
    float addHeight = [ChatMessageCell cellHeight:model] + [ChatMessageTimeCell cellHeight];
    float tableSizeHeight = _tableView.contentSize.height + addHeight;
    [_tableView reloadData];
 //   tableSizeHeight = _tableView.contentSize.height;
    
    /*
     添加消息数， UI重新配置
     一、键盘显示的情况下（最后一条消息不能在键盘下）
     1当消息数不多的情况下，如1条，当增加新的消息，先移动tableview本身，随着消息数增多tableview不能再移动了，就移contentOffset（即步骤2）
     2当消息数多了的时候，就移动tableview的contentoffset
     
     二、键盘没显示的情况下
     1 当tableview已经滑动到最底下了，那么新消息来了，tableview依旧要保持滑动在最底下的情况。
     2 当tableview没有滑动到最底下，则不需要处理
     */
    [UIView animateWithDuration:0.25 animations:^(void){
       
        [self configUIWhenMessageInput:tableSizeHeight scrollBottom:YES];
    } completion:^(BOOL finish){
       
    }];
    
    [[ChatCNetSocketModel shareChatCModel] sendDataToSerVer:model];
    
}

#pragma mark - IM 通知
// 更新消息状态
- (void)sendMessageStatus:(NSNotification*)notifi{

}

- (void)reciveMessage:(NSNotification*)notifi{
    
    NSString *messageS = notifi.object;
    
    ChatMessagModel *model = [[ChatMessagModel alloc] init];
    model.isRecv = YES;
    model.senderSuccess = YES;
    model.name = @"eoc";
    model.messageType = MessageTextType;
    model.textContent = [messageS stringByAppendingString:@"_FromServer"];
    model.timeStamp = [[NSDate date] timeIntervalSince1970];
    [_messageDataAry addObject:model];
    
    [_tableView reloadData];// 执行完reloadData，并不是所有的_tableView相关数据全都更新好了
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_messageDataAry count]*2-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - notification 通知
- (void)keyboardWillShow:(NSNotification *)notification{
    _isChangeEocKeyBoard = NO;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification{
    
    NSDictionary *userInfo = notification.userInfo;
    CGRect endFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect beginFrame = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    void (^animation)() = ^(void){
        [self keyboardChangeFrameBegin:beginFrame endRect:endFrame];
    };

    /*
     键盘动画执行完，再执行其他动画
     viewCtr 有键盘没收起来，然后pop
     */

    // 保持同步 duration
    [UIView animateWithDuration:duration
                          delay:0
                        options:(curve << 16 | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^(void){
                         animation();
                     }
                     completion:^(BOOL finish){
            
                     }];
    
}
- (void)keyboardChangeFrameBegin:(CGRect)beginRect endRect:(CGRect)endRect
{
    // 收键盘
    if (endRect.origin.y == [UIScreen mainScreen].bounds.size.height){
        
        if (_isChangeEocKeyBoard) {
            [self ShowEOCkeyBoard];
        }else{
            [self keyBoardBothHiddenStatus];
        }
        
    }else {// 显示键盘或者显示的键盘大小变动
        [self showSyskeyBoard:endRect];
    }
}

// 显示系统键盘
- (void)showSyskeyBoard:(CGRect)endRect{
    
    _isKeyBoardShow = YES;
    [_inputAccessView setBottomToSuperBotttomGap:endRect.size.height];
    [self configUIWhenMessageInput:_tableView.contentSize.height scrollBottom:NO];
    
}
// 显示自定义键盘
- (void)ShowEOCkeyBoard
{

    [_keyBoardAudio_V bottomEqualSuperViewBottom];
    [_inputAccessView bottomEqualToTopOfView:_keyBoardAudio_V];
    [self configUIWhenMessageInput:_tableView.contentSize.height scrollBottom:NO];
}

// 系统键盘+my键盘 隐藏状态
- (void)keyBoardBothHiddenStatus{
    _isChangeEocKeyBoard = NO;
    _isKeyBoardShow = NO;
    [self resignFisrtResp];
   
    [_inputAccessView setY:[_inputAccessView superview].height - _inputAccessView.height];
    [_tableView setY:0];
    [_keyBoardAudio_V setY:[UIScreen mainScreen].bounds.size.height - 64];
}

#pragma mark - 添加新信息UI配置
//配置最后一条消息靠近_inputAccessView； isBottom：YES为滑动到最底下
- (void)configUIWhenMessageInput:(float)contentHeight scrollBottom:(BOOL)isBottom{
    if (contentHeight < _tableView.frame.size.height) {
        float moveY = _inputAccessView.frame.origin.y - _tableView.frame.size.height;
        moveY += (_tableView.frame.size.height - contentHeight);
        moveY = (moveY > 0)?0:moveY;
        [_tableView setY:moveY];
    }else{
        
        [_tableView setY:_inputAccessView.frame.origin.y - _tableView.frame.size.height];
        if (isBottom) {
            [_tableView setContentOffset:CGPointMake(0, contentHeight - _tableView.frame.size.height)];
        }
    }

}
/*
 8583数据协议 （银行安全通信数据协议）  （位域）   私有
 */
#pragma mark - 文本输入UI配置（tableview，inputview，keyboardHeadV的位置）
- (void)configUIWhenTextInput:(float)textHeight
{
    textHeight = (textHeight<40)?40:textHeight;
    textHeight = (textHeight>160)?160:textHeight;

    [keyBoardHeadV setHeight:textHeight];
    
    _inputAccessView.frame = ({
        CGRect rect = _inputAccessView.frame;
        float bottomY = CGRectGetMaxY(rect);
        rect.size.height = textHeight + 40;
        rect.origin.y = bottomY - rect.size.height;
        rect;
    });
    [self configUIWhenMessageInput:_tableView.contentSize.height scrollBottom:NO];
}

#pragma mark - textView delegate
- (void)textViewDidChange:(UITextView *)textView
{
    float height = [UIView backLinesHighInView:textView.frame.size.width-6 string:textView.text font:textView.font];
    [self configUIWhenTextInput:height];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqual:@"\n"]) {
        [self senderTextMessage:textView.text];
        return NO;
    }
    return YES;
}

#pragma mark - 加载更多数据

- (void)loadMoreMessageRecord{
    
    if (_messageDataAry.count == 0 && _loadActivityView.isAnimating) {
        return;
    }
   
    NSArray *backAry = [ChatMessagModel backFromData:10];
 
    if (backAry.count < 10) {
        [_loadActivityView stopAnimating];
        _loadStatusLb.text = @"数据加载完毕";
    }else{
        [_loadActivityView startAnimating];
        _loadStatusLb.text = @"正在加载数据";
    }
    
    for (int i = 0; i < backAry.count; i++) {
        ChatMessagModel *modelTmp = [backAry objectAtIndex:i];
        [_messageDataAry insertObject:modelTmp atIndex:0];
    }
    
    // 方式一
    float offsetY = _tableView.contentSize.height;
    [_tableView reloadData];
    float offsetYT = _tableView.contentSize.height;
    
    [_tableView setContentOffset:CGPointMake(0, offsetYT - offsetY)];
    
   
    // 方式二
    /*

     公司团队的技能堆栈
     
     改frame
     contentoffset
     */
    [_tableView reloadData];
    NSInteger index = backAry.count;

    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index*2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];

    
}

#pragma mark - Scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 系统键盘
    if (scrollView == _tableView) {
        if (_tableView.contentOffset.y < -40) {
            _isLoadingMoreMessage = YES;
        }
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView == _tableView) {
        if (_isLoadingMoreMessage && !decelerate) {
            _isLoadingMoreMessage = NO;
            [self loadMoreMessageRecord];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {
        
        if (_isLoadingMoreMessage) {
            _isLoadingMoreMessage = NO;
            [self loadMoreMessageRecord];
        }
    }
}

#pragma mark - Tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isKeyBoardShow) {

        [self keyBoardBothHiddenStatus];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _messageDataAry.count*2;
}

static float TestTTT;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TestTTT = 0;
    }
    float height = 0;
    if (!(indexPath.row%2)){
        height = [ChatMessageTimeCell cellHeight];
    }else{
        height = [ChatMessageCell cellHeight:_messageDataAry[indexPath.row/2]];
    }
    TestTTT += height;
    return height;
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!(indexPath.row%2)) {
        // 时间cell
        ChatMessageTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatMessageTimeCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatMessageTimeCell" owner:nil options:nil] firstObject];
        }
        ChatMessagModel *model = _messageDataAry[indexPath.row/2];
        cell.timeStamp = model.timeStamp;
        return cell;
        
    }else{
        ChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatMessageCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ChatMessageCell" owner:nil options:nil] firstObject];
        }
        cell.messageModel = _messageDataAry[indexPath.row/2];
        return cell;
    }
    
}
@end
