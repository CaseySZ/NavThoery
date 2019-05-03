//
//  SafeLoginView.m
//  SafeGesture
//
//  Created by Casey on 26/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import "UnlockSafeLoginView.h"
#import "GestureLockView.h"
#import "SystemAuthView.h"
#import "UIAlertSafeLogController.h"

@interface UnlockSafeLoginView () <SysSafeHandleProtocol>{
    
    UIButton *_changeLoginStyleButton;
}

@property (nonatomic, strong)SystemAuthView *sysAuthView;
@property (nonatomic, strong)GestureLockView *gestureLockView;
@property (nonatomic, assign)SysSafeType safeType;
@end


@implementation UnlockSafeLoginView




- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        _changeLoginStyleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _changeLoginStyleButton.frame = CGRectMake(0, 0, 130, 40);
        [_changeLoginStyleButton setTitleColor:[UIColor colorWithRed:1/255.0 green:137/255.0  blue:255/255.0  alpha:1 ] forState:UIControlStateNormal];
        _changeLoginStyleButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_changeLoginStyleButton setTitle:@"切换登录方式" forState:UIControlStateNormal];
        _changeLoginStyleButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_changeLoginStyleButton addTarget:self action:@selector(changeLoginMethod:) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundColor = UIColor.whiteColor;
        
    }
    
    return self;
}


- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    _changeLoginStyleButton.frame = CGRectMake(self.frame.size.width/2 - 130/2, self.frame.size.height - 32 - 50, 130, 50);
    
    if (self.safeType == SafeTypeGesture) {
        
        self.gestureLockView.frame = CGRectMake(0, 50, self.frame.size.width, self.frame.size.height - 50);
        self.gestureLockView.isSettingLockStyle = NO;
        
    }else {
        
        self.sysAuthView.frame = self.bounds;
        self.sysAuthView.isFaceID = (self.safeType == SafeTypeFaceID);
        
    }
    
    _changeLoginStyleButton.hidden = NO;
    if (!_changeLoginStyleButton.superview) {
        [self addSubview:_changeLoginStyleButton];
    }
    
}

- (void)changeLoginMethod:(UIButton*)sender {
    
    
    if (self.changeMethod) {
        self.changeMethod();
    }
}


#pragma mark - SysSafeHandleProtocol

- (void)handleSuccess:(NSString*)result{
    
    if (self.completion) {
        self.completion(SysSafeAuthSuccess);
    }
    
}

- (void)handleError:(SysSafeHandleStatus)errorStatus {
    
    if (self.completion) {
        self.completion(errorStatus);
    }
    
}

#pragma mark - 懒加载


- (SysSafeType)safeType {
    
    if (!_safeType) {
        _safeType = [SysSafeIDModel getSafeType];
    }
    return _safeType;
    
}

- (SystemAuthView*)sysAuthView {
    
    
    if (!_sysAuthView) {
        _sysAuthView = [[SystemAuthView alloc] init];
        _sysAuthView.delegate = self;
        [self addSubview:_sysAuthView];
    }
    return _sysAuthView;
    
}


- (GestureLockView*)gestureLockView {
    
    if (!_gestureLockView) {
        _gestureLockView = [[GestureLockView alloc] init];
        _gestureLockView.delegate = self;
        [self addSubview:_gestureLockView];
    }
    
    return _gestureLockView;
}

@end
