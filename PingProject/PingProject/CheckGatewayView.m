//
//  CheckGatewayView.m
//  PingProject
//
//  Created by Casey on 30/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "CheckGatewayView.h"
#import "CheckGatewayCell.h"
#import "NetGatewayAnalyze.h"


@interface CheckGatewayView () <UITableViewDelegate, UITableViewDataSource>{
    
    UILabel *_ipLabel;
   
}

@property (nonatomic, strong)NSArray<GatewayDataModel*> *checkDataArr;
@property (nonatomic, strong)NSArray *gatewayArr;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)void(^diagnosisEvent)(void);
@end



@implementation CheckGatewayView



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeCheck)];
        [self addGestureRecognizer:tapGesture];
        
        [self bulidContentView];
     
    }
    
    return self;
}

+ (void)showCheck:(NSArray*)gatewayArr diagnose:(void(^)(void))diagnosisEvent{
    
    
    CheckGatewayView *checkView = [[CheckGatewayView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    checkView.gatewayArr = gatewayArr;
    checkView.diagnosisEvent = diagnosisEvent;
    [checkView checkNetStart];
    [UIApplication.sharedApplication.delegate.window addSubview:checkView];
    
}

- (void)closeCheck {
    
    self.diagnosisEvent = nil;
    [self removeFromSuperview];
    
}

- (void)setGatewayArr:(NSArray *)gatewayArr {
    
    _gatewayArr = gatewayArr;
    NSMutableArray *modelArr = [NSMutableArray new];
    for (int i = 0; i < gatewayArr.count; i++) {
        
        GatewayDataModel *model = [GatewayDataModel new];
        model.title = [NSString stringWithFormat:@"线路%@:", @(i)];
        model.timeDuration = 0;
        
        NSString *urlStr = gatewayArr[i];
        NSURL *url = [NSURL URLWithString:urlStr];
        urlStr = url.host;
        if (urlStr.length == 0) {
            urlStr = gatewayArr[i];
        }
        
        NSString *productId = @"B01";
        if (productId) {
            urlStr = [urlStr stringByReplacingOccurrencesOfString:[productId lowercaseString] withString:@""];
        }
        
        NSInteger index1 = arc4random() % urlStr.length;
        NSInteger index2 = 0;
        for (; urlStr.length > 1;) {
            index2 = arc4random() % urlStr.length;
            if (index1 != index2) {
                break;
            }
        }
        urlStr = [urlStr stringByReplacingCharactersInRange:NSMakeRange(index1, 1) withString:@"*"];
        urlStr = [urlStr stringByReplacingCharactersInRange:NSMakeRange(index2, 1) withString:@"*"];
        model.gatewayUrl = urlStr;
        
        
        [modelArr addObject:model];
        
    }
    self.checkDataArr = modelArr;
}

- (void)setCheckDataArr:(NSArray<GatewayDataModel *> *)checkDataArr {
    
    
    _checkDataArr = checkDataArr;
    [_tableView reloadData];
    
}

- (void)bulidContentView {
    
    
    self.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.7f];
    
   
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - 280/2, self.frame.size.height/2 - 350/2, 280, 350)];
    contentView.layer.cornerRadius = 12.f;
    contentView.layer.masksToBounds = YES;
    [self addSubview:contentView];
    
    CGFloat btnH = 50.f;
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.frame = CGRectMake(0, 0, CGRectGetWidth(contentView.frame), CGRectGetHeight(contentView.frame) - btnH);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.layer.masksToBounds = YES;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = UIColor.whiteColor;
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_tableView.frame), 60)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(_tableView.frame), 25)];
    titleLab.text = @"网络情况";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:16.f];
    [headerView addSubview:titleLab];
    
    
    _ipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLab.frame), CGRectGetWidth(_tableView.frame), 25)];
    _ipLabel.text = @"获取中...";
    _ipLabel.textAlignment = NSTextAlignmentCenter;
    _ipLabel.textColor = [UIColor grayColor];
    _ipLabel.font = [UIFont systemFontOfSize:14.f];
    [headerView addSubview:_ipLabel];
    
    _tableView.tableHeaderView = headerView;
    [contentView addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    CGFloat lineH = 1.0f / [UIScreen mainScreen].scale;
    UIColor * lineColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.5];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_tableView.frame), CGRectGetWidth(contentView.frame), lineH)];
    line1.backgroundColor = lineColor;
    [contentView addSubview:line1];
    
    CGFloat btnW = CGRectGetWidth(contentView.frame) * 0.5f;
    UIButton *detailBtn = [UIButton new];
    UIColor *titleColor = [UIColor colorWithRed:30.f/255 green:144.f/255 blue:255.f/255 alpha:1.f];
    detailBtn.frame = CGRectMake(0, CGRectGetMaxY(_tableView.frame) + lineH, btnW - lineH, btnH - lineH);
    [detailBtn setTitle:@"网络诊断" forState:UIControlStateNormal];
    [detailBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [detailBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    detailBtn.backgroundColor = [UIColor whiteColor];
    detailBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [detailBtn addTarget:self action:@selector(detailBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:detailBtn];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(detailBtn.frame), CGRectGetMinY(detailBtn.frame), lineH, CGRectGetHeight(detailBtn.frame))];
    line2.backgroundColor = lineColor;
    [detailBtn addSubview:line2];
    
    UIButton *captureBtn = [UIButton new];
    captureBtn.frame = CGRectMake(CGRectGetMaxX(line2.frame), CGRectGetMinY(detailBtn.frame), btnW, CGRectGetHeight(detailBtn.frame));
    [captureBtn setTitle:@"保存截图" forState:UIControlStateNormal];
    [captureBtn setTitleColor:titleColor forState:UIControlStateNormal];
    [captureBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    captureBtn.backgroundColor = [UIColor whiteColor];
    captureBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [captureBtn addTarget:self action:@selector(captureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:captureBtn];
    
}



- (void)captureBtnClicked {
    
    UIGraphicsBeginImageContext(UIScreen.mainScreen.bounds.size);   //self为需要截屏的UI控件 即通过改变此参数可以截取特定的UI控件
    [UIApplication.sharedApplication.delegate.window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //把图片保存在本地
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError: (NSError *) error contextInfo: (void*) contextInfo{
    
    NSString *msg = nil;
    
    if(error != NULL){
        
        msg = @"保存图片失败";
        
    }else{
        
        msg = @"保存图片成功";
        
    }
    
}


- (void)detailBtnClicked {
    
    if (self.diagnosisEvent) {
        self.diagnosisEvent();
    }
    [self closeCheck];
    
}


#pragma mark - Tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.checkDataArr.count;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    sectionHeadView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-15, 30)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:14.f];
    titleLabel.text = @"当前业务线路：线路一";
    [sectionHeadView addSubview:titleLabel];
    return sectionHeadView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 45;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CheckGatewayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[CheckGatewayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.dataModel = self.checkDataArr[indexPath.row];
    return cell;
    
}


#pragma mark - Net

- (void)checkNetStart {
    
    
    [[NetGatewayAnalyze new] checkGateway:self.gatewayArr progress:nil  completion:^(NSArray<AnalyzeDataModel *> *analyzeArr) {
      
        for (int i = 0; i < analyzeArr.count && i < self.checkDataArr.count; i++) {
            
            AnalyzeDataModel *model = analyzeArr[i];
            GatewayDataModel *gateModel = self.checkDataArr[i];
            gateModel.timeDuration = model.timeDuration;
            gateModel.networkType = model.networkType;
            
        }
        
        [self.tableView reloadData];
        
    }];
    
    
}

@end
