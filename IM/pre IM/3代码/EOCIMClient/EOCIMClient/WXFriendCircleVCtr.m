//
//  WXFriendCircleVCtr.m
//  WeiXinFriendCircle
//
//  Created by sunyong on 16/12/27.
//  Copyright © 2016年 @八点钟学院. All rights reserved.
//

#import "WXFriendCircleVCtr.h"
#import "FriendCircleModel.h"
#import "FriendCircleCell.h"
#import "FriendCircleData.h"
#import "FCLinkViewCtr.h"
#import "CellMessageCell.h"


@interface WXFriendCircleVCtr ()<FriendCircleCellDelegate,UITextViewDelegate>{
    UITextField *theTextField;
}
@end


@implementation WXFriendCircleVCtr


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"朋友圈";
    self.automaticallyAdjustsScrollViewInsets = NO;
    currentPage = 0;
    isNext = YES;
    fcDataAry = [NSMutableArray array];
    theTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.view addSubview:theTextField];
    
    [inputAccessView removeFromSuperview];
    theTextField.returnKeyType = UIReturnKeySend;
    theTextField.inputAccessoryView = inputAccessView;
    fcTextView.returnKeyType = UIReturnKeySend;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInputView:)];
    [inputAccessView addGestureRecognizer:tapGes];
    
    approveAndcommentView.hidden = NO;
    CGRect rect = approveAndcommentView.frame;
    rect.origin.y = 0;
    approveAndcommentView.frame = rect;
    approveAndcommentView.layer.cornerRadius = 5;
    [approveAndcommentView removeFromSuperview];
    
    fcImageVCtr = [[FCImageViewCtr alloc] init];
    
    theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    theTableView.delegate   = self;
    theTableView.dataSource = self;
    theTableView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:theTableView];
    
    [theHeadView removeFromSuperview];
    [theFootView removeFromSuperview];
    
    [theTableView setTableHeaderView:theHeadView];
    [theTableView setTableFooterView:theFootView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyDidAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillHide:) name:UIKeyboardWillHideNotification object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    [self netLoadData:currentPage];
}



- (void)pressMessageBt:(UIButton*)sender{

    if ([approveAndcommentView superview] == [sender superview]) {
        [self hiddernSubMenu];
        return;
    }
    [approveAndcommentView removeFromSuperview];
    UIView *tmpSuperV = [sender superview];
    [tmpSuperV addSubview:approveAndcommentView];
    [tmpSuperV bringSubviewToFront:sender];
    
    CGRect tmpRect = approveAndcommentView.frame;
    tmpRect.origin.x = sender.frame.origin.x;
    approveAndcommentView.frame = tmpRect;
    approveAndcommentView.hidden = NO;
    
    FriendCircleCell *cell = (FriendCircleCell*)[[[sender superview] superview] superview];
    if ([cell isKindOfClass:[FriendCircleCell class]]) {
        if ([cell.cellModel.approveAry containsObject:@"楼主"]) {
            [approveBt setTitle:@" 取消" forState:UIControlStateNormal];
        }else {
            [approveBt setTitle:@"   赞" forState:UIControlStateNormal];
        }
    }
    
    [UIView animateWithDuration:0.4 animations:^(void){
        
        CGRect tmpRect = approveAndcommentView.frame;
        tmpRect.origin.x  = sender.frame.origin.x - approveAndcommentView.frame.size.width - 10;
        approveAndcommentView.frame = tmpRect;
    }];
    
}

- (void)hiddernSubMenu{
    if ([approveAndcommentView superview]) {
        [UIView animateWithDuration:0.4 animations:^(void){
            CGRect tmpRect = approveAndcommentView.frame;
            tmpRect.origin.x  = CGRectGetMaxX(approveAndcommentView.frame) + 10;
            approveAndcommentView.frame = tmpRect;
        }completion:^(BOOL finish){
            
            [approveAndcommentView removeFromSuperview];
            approveAndcommentView.hidden = YES;
        }];
    }
}

// 点赞
- (IBAction)approveBt:(UIButton*)sender{

    FriendCircleCell *cell = (FriendCircleCell*)[[[[sender superview] superview] superview] superview];
    if ([cell isKindOfClass:[FriendCircleCell class]]) {
        if ([cell.cellModel.approveAry containsObject:@"楼主"]) {
            [cell.cellModel.approveAry removeObject:@"楼主"];
        }else {
            [cell.cellModel.approveAry addObject:@"楼主"];
        }
    }
    NSMutableArray *indexAry = [NSMutableArray array];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
    [indexAry addObject:indexPath];
    [theTableView reloadRowsAtIndexPaths:indexAry withRowAnimation:UITableViewRowAnimationNone];
    
    [self hiddernSubMenu];
}

// 回复
- (IBAction)messageBt:(UIButton*)sender{
    
    [self hiddernSubMenu];
    fcTextView.text = @" ";
    float height = [UIView backLinesInView:fcTextView.frame.size.width string:fcTextView.text font:fcTextView.font];
    keyBoardHeadV.frame = ({
        CGRect rect = keyBoardHeadV.frame;
        if (height > 0 && height < 160) {
            rect.size.height = 10 + height;
        }
        rect.origin.y = inputAccessView.frame.size.height - rect.size.height;
        rect;
    });
    [theTextField becomeFirstResponder];
    FriendCircleCell *cell = (FriendCircleCell*)[[[[sender superview] superview] superview] superview];
    fcTextView.fcCell = cell;
    fcTextView.messageCell = nil;
    positionY = CGRectGetMaxY(cell.frame);
    
}
// 表情
- (IBAction)keyBoardBQ:(UIButton*)sender{
    
}

#pragma mark - 处理键盘留言和键盘的位置
- (void)handleOffsetX{

    float contentOffY = positionY + keyHight - ScreenHeight;
    contentOffY = contentOffY - inputAccessView.frame.size.height + keyBoardHeadV.frame.size.height;
    if (contentOffY < 0)
        contentOffY = 0;
    
    [theTableView setContentOffset:CGPointMake(0, contentOffY) animated:YES];
    
}

#pragma mark - notification 通知
- (void)keyDidAppear:(NSNotification*)notifi{
    float height = [UIView backLinesInView:fcTextView.frame.size.width string:fcTextView.text font:fcTextView.font];
    keyBoardHeadV.frame = ({
        CGRect rect = keyBoardHeadV.frame;
        if (height > 0 && height < 160) {
            rect.size.height = 10 + height;
        }
        rect.origin.y = inputAccessView.frame.size.height - rect.size.height;
        rect;
    });
    [fcTextView becomeFirstResponder];
    
    CGRect rect = [[notifi.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    keyHight = rect.size.height;
    
    NSNumber *duration = [notifi.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [self performSelector:@selector(handleOffsetX) withObject:nil afterDelay:[duration floatValue]];
}

- (void)keyWillChangeFrame:(NSNotification*)notifi{
}

- (void)keyWillHide:(NSNotification*)notifi{
    //keyHight = 0;
}

#pragma mark - 手势
- (void)tapInputView:(UITapGestureRecognizer*)gesture{
    [fcTextView resignFirstResponder];
    [theTextField resignFirstResponder];
}
#pragma mark - textView delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [fcTextView resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    float height = [UIView backLinesInView:textView.frame.size.width string:textView.text font:textView.font];
    keyBoardHeadV.frame = ({
        CGRect rect = keyBoardHeadV.frame;
        if (height > 0 && height < 160) {
            rect.size.height = 15 + height;
        }
        rect.origin.y = inputAccessView.frame.size.height - rect.size.height;
        rect;
    });
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqual:@"\n"]) {
        [fcTextView  resignFirstResponder];
        [theTextField resignFirstResponder];
        [self senderMessageFrom:nil];
    }
    return YES;
}

#pragma mark -发送留言/回复

- (void)senderMessageFrom:(NSDictionary*)infoDict{
    if (fcTextView.text.length > 0) {
        
        if (fcTextView.messageCell) {
            NSMutableArray *messageAry = fcTextView.fcCell.cellModel.messageAry;
            NSInteger index = fcTextView.messageCell.tag;
            
            NSMutableDictionary *messDict = [NSMutableDictionary dictionary];
            [messDict setObject:fcTextView.text forKey:@"msg"];
            [messDict setObject:@"0" forKey:@"status"];
            if (messageAry.count > index) {
                NSDictionary *tmpDict = [messageAry objectAtIndex:index];
                [messDict setObject:[tmpDict objectForKey:@"name"] forKey:@"name"];
                [messageAry insertObject:messDict atIndex:index+1];
            }
        }else{
            NSMutableArray *messageAry = fcTextView.fcCell.cellModel.messageAry;
            NSMutableDictionary *messDict = [NSMutableDictionary dictionary];
            [messDict setObject:@"楼主" forKey:@"name"];
            [messDict setObject:fcTextView.text forKey:@"msg"];
            [messDict setObject:@"2" forKey:@"status"];
            [messageAry addObject:messDict];
        }
        NSMutableArray *indexAry = [NSMutableArray array];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:fcTextView.fcCell.tag inSection:0];
        [indexAry addObject:indexPath];
        [theTableView reloadRowsAtIndexPaths:indexAry withRowAnimation:UITableViewRowAnimationNone];
    }
    fcTextView.text = @"";
}

#pragma mark -scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self hiddernSubMenu];
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height + 20) {
        // 拉倒底部，作判断加载新的数据
        [self netLoadData:currentPage];
    }
    else if(scrollView.contentOffset.y < - 40){
        // 重新刷新数据
        
    }
}

#pragma mark -tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fcDataAry.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return [FriendCircleCell fcCellHeight:[fcDataAry objectAtIndex:indexPath.row]];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FriendCircleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"FriendCircleCell" owner:nil options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.fcMessageBt addTarget:self action:@selector(pressMessageBt:) forControlEvents:UIControlEventTouchUpInside];
        cell.delegate = self;
    }
    cell.tag = indexPath.row;
    cell.fcMessageBt.tag = indexPath.row;
    cell.cellModel = [fcDataAry objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark -FriendCircleCell delegate

- (void)cellImagePress:(NSInteger)index images:(NSArray *)imageAry{
    fcImageVCtr.startIndex = index;
    fcImageVCtr.imagAry = imageAry;
    [fcImageVCtr.view setFrame:[UIScreen mainScreen].bounds];
    [self.view.window addSubview:fcImageVCtr.view];
}

- (void)cellLinkPress:(NSDictionary *)linkInfo{
    FCLinkViewCtr *linkLiewCtr = [[FCLinkViewCtr alloc] init];
    linkLiewCtr.urlStr = [linkInfo objectForKey:@"url"];
    linkLiewCtr.title = [linkInfo objectForKey:@"text"];
    [self.navigationController pushViewController:linkLiewCtr animated:YES];
}

- (void)cellSelectSendMessage:(FriendCircleCell*)cell subCell:(CellMessageCell *)subCell{
    
    fcTextView.fcCell = cell;
    fcTextView.messageCell = subCell;
    UITableView *tableV = (UITableView*)[[subCell superview] superview];
    positionY = cell.frame.origin.y + tableV.frame.origin.y + CGRectGetMaxY(subCell.frame);
    [theTextField becomeFirstResponder];
}

#pragma mark - net loadData

- (void)netLoadData:(NSInteger)pageNum{
    
    if (!isNext)
        return;
    
    NSDictionary *backInfoDict = [FriendCircleData backFriendCircleData:pageNum];
    [fcDataAry addObjectsFromArray:[backInfoDict objectForKey:@"data"]];
    currentPage = [[backInfoDict objectForKey:@"page"] integerValue];
    isNext = [[backInfoDict objectForKey:@"isNext"] boolValue];
    if (isNext) {
        footDesLb.text = @"        正在加载...";
        [activityView startAnimating];
    }else{
        footDesLb.text = @"数据已加载完";
        [activityView stopAnimating];
    }
    [theTableView reloadData];
}



@end
