//
//  UIAlertInputController.m
//  IOS_B01
//
//  Created by Casey on 04/01/2019.
//  Copyright © 2019 Casey. All rights reserved.
//

#import "UIAlertSafeLogController.h"

@interface UIAlertSafeLogController (){
    
    CGFloat _startX;
    CGFloat _startY;
    
}


@property (nonatomic, strong)UIImageView *logImageView;

@end

@implementation UIAlertSafeLogController


+ (instancetype)alertWithTitle:(NSString*)title message:(NSString*)message{
    
    if (![title containsString:@"手势"]) {
        title = [NSString stringWithFormat:@"\n\n%@", title];
    }
    
    UIAlertSafeLogController *alertView = [UIAlertSafeLogController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    return alertView;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}


- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    if (self.logImageView.image) {
         self.logImageView.frame = CGRectMake(self.view.frame.size.width/2 - 40/2, 15, 40, 40);
    }
   
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    
    
}

- (void)setLogImage:(UIImage *)logImage {
    
    self.logImageView.image = logImage;
}

- (UIImageView*)logImageView {
    
    if (!_logImageView) {
        _logImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        [self.view addSubview:self.logImageView];
    }
    
    return _logImageView;
}


@end
