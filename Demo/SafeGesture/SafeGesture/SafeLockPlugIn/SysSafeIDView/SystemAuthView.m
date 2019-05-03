//
//  UnlockSafeLoginView.m
//  SafeGesture
//
//  Created by Casey on 25/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import "SystemAuthView.h"
#import "LockLogButton.h"


@interface SystemAuthView (){
    
    
    UIImageView *_logImageView;
    
    UILabel *_userNameLabel;
    
    LockLogButton *_unlockButton;
    
    UIButton *_changeLoginStyleButton;
    
}


@end


@implementation SystemAuthView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
     
        
        _logImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 133, 29)];
        _logImageView.image = [UIImage imageNamed:@"TextAndlogo.png"];
        [self addSubview:_logImageView];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 16)];
        _userNameLabel.textColor = UIColor.blackColor;
        _userNameLabel.font = [UIFont systemFontOfSize:14];
        _userNameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_userNameLabel];
        
        _unlockButton = [LockLogButton buttonWithType:UIButtonTypeCustom];
        _unlockButton.frame = CGRectMake(0, 0, 130, 110);
        [_unlockButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        _unlockButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _unlockButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_unlockButton addTarget:self action:@selector(authOperationEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_unlockButton];
        
    }
    
    
    return self;
    
}


- (void)layoutSubviews {
    
    
    [super layoutSubviews];
    
    
    
    _logImageView.frame = CGRectMake(self.frame.size.width/2 - 133/2, 50 + 64, 133, 29);
    _userNameLabel.frame = CGRectMake(0, CGRectGetMaxY(_logImageView.frame) + 38, self.frame.size.width, 29);
    _unlockButton.frame = CGRectMake(self.frame.size.width/2 - 130/2, CGRectGetMaxY(_userNameLabel.frame) + 100, 130, 110);
    _changeLoginStyleButton.frame = CGRectMake(self.frame.size.width/2 - 130/2, self.frame.size.height - 32 - 50, 130, 50);
    
    
    _userNameLabel.text = [NSString stringWithFormat:@"欢迎您，"];
    
    if (self.isFaceID) {
        
        [_unlockButton setImage:[UIImage imageNamed:@"icon_face-ID.png"] forState:UIControlStateNormal];
        [_unlockButton setTitle:@"点击进行面容ID解锁" forState:UIControlStateNormal];
        
    }else {
        
        [_unlockButton setImage:[UIImage imageNamed:@"icon_finger-print.png"] forState:UIControlStateNormal];
        [_unlockButton setTitle:@"点击进行指纹登录" forState:UIControlStateNormal];
    }
    
}


- (void)setIsFaceID:(BOOL)isFaceID {
    
    _isFaceID = isFaceID;
    [self setNeedsLayout];
    
}


- (void)authOperationEvent:(UIButton*)sender {
    

    [SysSafeIDModel useSysSafeVerify:^(SysSafeHandleStatus status) {
        
        
        if (status == SysSafeAuthSuccess) {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(handleSuccess:)]) {
                [self.delegate handleSuccess:[@(status) description]];
            }
            
        }else {
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(handleError:)]) {
                [self.delegate handleError:status];
            }
        }
        
    }];
    
    
}


- (void)dealloc {
    
    
    NSLog(@"%s", __func__);
    
}


@end
