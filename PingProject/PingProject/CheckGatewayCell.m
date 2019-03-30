//
//  CheckGatewayCell.m
//  PingProject
//
//  Created by Casey on 30/03/2019.
//  Copyright © 2019 nb. All rights reserved.
//

#import "CheckGatewayCell.h"


@interface CheckGatewayCell () {
    
    
    
}

@property (nonatomic, strong)UILabel *gatewayTitleLabel;
@property (nonatomic, strong)UILabel *speedStatusLabel;
@property (nonatomic, strong)UIView *progressBackgroundView;
@property (nonatomic, strong)UIView *progressView;

@property (nonatomic, strong)UILabel *urlLabel;


@end

@implementation CheckGatewayCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initCellUI];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


- (void)initCellUI {
    
    CGFloat startX = 20.f;
    CGFloat cellH = 40.f;
    CGFloat lineW = 50.f;
    self.gatewayTitleLabel = [[ UILabel alloc] initWithFrame:CGRectMake(startX, 0, lineW, cellH)];
    self.gatewayTitleLabel.font = [UIFont systemFontOfSize:12];
    self.gatewayTitleLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.gatewayTitleLabel];
    
    CGFloat tableviewWidth = 280;
    CGFloat speedLabelWidth = 50.f;
    
    self.speedStatusLabel = [[UILabel alloc] init];
    self.speedStatusLabel.frame = CGRectMake(tableviewWidth - speedLabelWidth - startX, 0, speedLabelWidth, cellH);
    self.speedStatusLabel.font = [UIFont systemFontOfSize:12.f];
    self.speedStatusLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.speedStatusLabel];
    
    CGFloat progressW = tableviewWidth - startX * 2.f - speedLabelWidth - lineW;
    CGRect progressFrame = CGRectMake(CGRectGetMaxX(self.gatewayTitleLabel.frame), 15, progressW, 10);
    
    self.progressBackgroundView = [[UIView alloc] initWithFrame:progressFrame];
    self.progressBackgroundView.backgroundColor = [UIColor lightGrayColor];
    self.progressBackgroundView.layer.cornerRadius = 3.0;
    self.progressBackgroundView.layer.masksToBounds = YES;
    [self.contentView addSubview:self.progressBackgroundView];
    
    self.progressView = [[UIView alloc] init];
    [self.progressBackgroundView addSubview:self.progressView];
    
    
    self.urlLabel = [[UILabel alloc] init];
    self.urlLabel.frame = CGRectMake(0, CGRectGetMaxY(self.progressBackgroundView.frame), tableviewWidth, 20);
    self.urlLabel.textColor = [UIColor blackColor];
    self.urlLabel.font = [UIFont systemFontOfSize:10.f];
    self.urlLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.urlLabel];
    
    
}


- (void)setDataModel:(GatewayDataModel *)dataModel {
    
    _dataModel = dataModel;
    
    CGFloat speed =  dataModel.timeDuration;
    NSString *speedStr = [NSString stringWithFormat:@"%.lfms",speed];
    int progress = 0;
    UIColor *progressColor = [UIColor greenColor];
    
    if (speed == 0) {
        
        progressColor = [UIColor blackColor];
        speedStr = @"诊断中...";
        
    } else if (speed >= FailSpeedCode) {
        
        speedStr = @"失败";
        progress = 0;
        progressColor = [UIColor redColor];
        
    } else if (speed >= 200) {
        
        progress = [@(((600 - speed) / 10 + 1)) intValue];
        if (progress < 1) {
            progress = 1;
        }
        progressColor = [UIColor redColor];
        
    } else if (speed >= 100) {
        
        progress = [@((200 - speed) / 3 + 40) intValue];
        progressColor = [UIColor orangeColor];
        
    } else if (speed >= 60) {
        
        progress = [@((100 - speed + 70)) intValue];
        progressColor = [UIColor greenColor];
        
    } else {
        
        progress = 100;
        progressColor = [UIColor greenColor];
    }
    
    self.gatewayTitleLabel.text = dataModel.title;
    self.urlLabel.text = dataModel.gatewayUrl;
    
    self.speedStatusLabel.text = speedStr;
    self.speedStatusLabel.textColor = progressColor;

    self.progressView.frame = CGRectMake(0, 0, (progress/100.0)*self.progressBackgroundView.frame.size.width, self.progressBackgroundView.frame.size.height);
    self.progressView.backgroundColor = progressColor;
    
}


@end
