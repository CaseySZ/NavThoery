//
//  SysSafeIDModel.m
//  SafeGesture
//
//  Created by Casey on 25/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import "SysSafeIDModel.h"
#import <UIKit/UIKit.h>
#import <LocalAuthentication/LocalAuthentication.h>


#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)


@implementation SysSafeIDModel


+ (void)useSysSafeVerify:(void(^)(SysSafeHandleStatus status))completion {
    
    
    NSString *message = IS_IPHONE_X ? @"面容 ID 短时间内失败多次，需要验证手机密码" : @"请把你的手指放到Home键上";// 当deviceType为LAPolicyDeviceOwnerAuthentication的时候，iPhone X会需要前面这段描述
    NSInteger deviceType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;//单纯指纹或FaceID,LAPolicyDeviceOwnerAuthentication会有密码验证
    LAContext *laContext = [[LAContext alloc] init];
    laContext.localizedFallbackTitle = @""; // 隐藏左边的按钮(默认是忘记密码的按钮)
    NSError *error = nil;
    BOOL isSupport = [laContext canEvaluatePolicy:(deviceType) error:&error];

    if (isSupport) {
        
        [laContext evaluatePolicy:(deviceType) localizedReason:message reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                if (completion) {
                    completion(SysSafeAuthSuccess);
                };
            }else {
                
                [self errerHandle:error result:completion];
            }
            
        }];
    }else {
        
        if (completion) {
            
            if (error.code == -8) {
                // 超出TouchID尝试次数或FaceID尝试次数，已被锁
                completion(SysSafeErrorCountMaxAndLock);
                
            }else {
                
                completion(SysSafeErrorNoSupport);
            }
            
        };
       
    }
    

}


+ (void)errerHandle:(NSError*)error result:(void(^)(SysSafeHandleStatus status))completion {
    
    SysSafeHandleStatus errorStatus = SysSafeErrorOther;
    NSLog(@"%@", error);
    
    if (error.code == -1) {
        // 超出TouchID尝试次数或FaceID尝试次数，已被锁
        errorStatus = SysSafeErrorCountMax;
        
    }else if (error.code == -8) {
        // 未开启TouchID权限(没有可用的指纹)
        errorStatus = SysSafeErrorCountMaxAndLock;
    }
    else if (error.code == -7) {
        // 未开启TouchID权限(没有可用的指纹)
        errorStatus = SysSafeErrorNoAllowTouchID;
    }
    else if (error.code == -6) {
        
        if (IS_IPHONE_X) {
            // iPhoneX 设置里面没有开启FaceID权限
            errorStatus = SysSafeErrorNoAllowFaceID;
        }
        else {
            // 非iPhoneX手机且该手机不支持TouchID(如iPhone5、iPhone4s)
            errorStatus = SysSafeErrorNoSupport;
        }
    }
    else if (error.code == -2) {
        // 用户主动取消等
        errorStatus = SysSafeCacelOpertion;
        
    }else {
        
        // 其他
       
    }
    
    if (completion) {
        completion(errorStatus);
    }
    
}

+ (SysSafeType)isSupportSysAuthentication{
    
    LAContext *laContext = [[LAContext alloc] init];
    NSError *error = nil;
    NSInteger deviceType = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    BOOL isSupport = [laContext canEvaluatePolicy:(deviceType) error:&error];
    if (@available(iOS 11.0, *)) {
        
        if (laContext.biometryType == LABiometryTypeFaceID) {
            return SafeTypeFaceID;
        }else if (laContext.biometryType == LABiometryTypeTouchID){
            return SafeTypeTouchID;
            
        }else {
            return SafeTypeGesture;
        }
        
    } else {
        
        if (isSupport) {
            return SafeTypeTouchID;
        }else {
            return SafeTypeGesture;
        }
    }
    
    
}


#define SafeLockTypeKey  @"xe123zfa10xr3rxg1#q"
+ (void)setSafeLockType:(SysSafeType)safeType {
    
    [[NSUserDefaults standardUserDefaults] setValue:[@(safeType) description] forKey:SafeLockTypeKey];
    
}


+ (SysSafeType)getSafeType {
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:SafeLockTypeKey]) {
       
        NSInteger type = [[[NSUserDefaults standardUserDefaults] objectForKey:SafeLockTypeKey] integerValue];
        return type;
        
    }else {
        
        return SafeTypeNone;
    }
}

@end
