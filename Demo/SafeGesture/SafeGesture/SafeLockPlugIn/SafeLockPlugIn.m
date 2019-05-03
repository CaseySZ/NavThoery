//
//  SafeLockPlugIn.m
//  SafeGesture
//
//  Created by Casey on 26/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import "SafeLockPlugIn.h"
#import "SysSafeIDModel.h"
#import "UIAlertSafeLogController.h"
#import "GestureSettingViewCtr.h"
#import "UnlockSafeLoginView.h"
#import "GestureLockView.h"



@implementation SafeLockPlugIn


+ (void)alertOpenSettingLockView:(void(^)(SysSafeType type, SysSafeHandleStatus resultStatus))completion {
    
    
    NSString *titleDesc = @"";
    NSString *implyDesc = @"";
    UIImage *logImage = nil;
    NSString *actionTitle = @"";
    SysSafeType safeType = [SysSafeIDModel isSupportSysAuthentication];
    safeType = SafeTypeGesture;
    if (safeType == SafeTypeTouchID) {
        
        titleDesc = @"指纹密码";
        implyDesc = @"是否开启指纹解锁验证？";
        logImage = [UIImage imageNamed:@"icon_finger-print.png"];
        actionTitle = @"开启";
        
    }else if (safeType == SafeTypeFaceID){
        
        titleDesc = @"Face ID";
        implyDesc = @"是否开启面部ID解锁？";
        logImage = [UIImage imageNamed:@"icon_face-ID.png"];
        actionTitle = @"开启";
        
    }else  {
        
        titleDesc = @"设置手势登录";
        implyDesc = @"是否设置手势快速登录";
        logImage = nil;
        actionTitle = @"设置";
    }
    
    UIAlertSafeLogController *alertView = [UIAlertSafeLogController alertWithTitle:titleDesc message:implyDesc];
    alertView.logImage = logImage;
    
    UIAlertAction *actionOperation = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (safeType == SafeTypeTouchID || safeType == SafeTypeFaceID){
            
            [SysSafeIDModel setSafeLockType:safeType];
            
            if (completion) {
                completion((SysSafeType)safeType, SysSafeAuthSuccess);
            }
            
        }else {
            
            
            GestureSettingViewCtr *viewCtr = [GestureSettingViewCtr new];
            viewCtr.completion = completion;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewCtr];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
            
        }
        
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"以后再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        if (completion) {
            completion((SysSafeType)safeType, SysSafeCacelOpertion);
        }
        
    }];
    
    [alertView addAction:actionCancel];
    [alertView addAction:actionOperation];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertView animated:YES completion:nil];
    
    
}



+ (void)setLock:(SysSafeType)lockStyle isOpen:(BOOL)isOpen {
    
    if (lockStyle == SafeTypeGesture) {
        
        if (isOpen) {
            
            GestureSettingViewCtr *viewCtr = [GestureSettingViewCtr new];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewCtr];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
        }
        
    }
}



// 显示解锁view
+ (BOOL)openUnlockView:(void(^)(SysSafeHandleStatus finsishStatus))completion changeLoginMethod:(void(^)(void))changeMethod{
    
    SysSafeType safeType = [SysSafeIDModel getSafeType];
   
    if (safeType != SafeTypeNone) {
        
        UnlockSafeLoginView *unlockView = [[UnlockSafeLoginView alloc] init];
        unlockView.completion = completion;
        unlockView.changeMethod = changeMethod;
        unlockView.frame = UIScreen.mainScreen.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:unlockView];
        
        
    }else {
        
        NSLog(@"error：您没有设置安全锁");
        return NO;
    }
    return YES;
}


// 关闭解锁View
+ (void)closeUnlockView {
    
    NSArray *viewArr = [UIApplication sharedApplication].keyWindow.subviews;
    for (UnlockSafeLoginView *view in viewArr) {
        
        if ([view isKindOfClass:[UnlockSafeLoginView class]]) {
            view.completion = nil;
            view.changeMethod = nil;
            [view removeFromSuperview];
        }
        
    }
    
}




@end
