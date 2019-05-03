//
//  SysSafeIDModel.h
//  SafeGesture
//
//  Created by Casey on 25/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef enum : NSUInteger {
    
    SysSafeAuthSuccess = 0, // 成功
    SysSafeCacelOpertion = 1, // 用户取消
    SysSafeErrorCountMax = 2, // 超出TouchID尝试次数或FaceID尝试次数过多
    SysSafeErrorNoAllowTouchID = 3, // 未开启TouchID权限(没有可用的指纹)
    SysSafeErrorNoAllowFaceID = 4, //  iPhoneX 设置里面没有开启FaceID权限
    SysSafeErrorNoSupport = 5, // 非iPhoneX手机且该手机不支持TouchID(如iPhone5、iPhone4s)
    SysSafeErrorCountMaxAndLock = 7, // 超出TouchID尝试次数或FaceID尝试过多，且已被锁
    SysSafeErrorOther = 8 // 其他
    
} SysSafeHandleStatus;


typedef enum : NSUInteger {
    
    SafeTypeNone = 0,
    SafeTypeGesture = 1,   // 手势
    SafeTypeTouchID = 2,  // 指纹
    SafeTypeFaceID = 3  //  faceID
    
}SysSafeType;


@protocol SysSafeHandleProtocol <NSObject>

- (void)handleSuccess:(NSString*)result;
- (void)handleError:(SysSafeHandleStatus)errorStatus;

@end



@interface SysSafeIDModel : NSObject


+ (void)useSysSafeVerify:(void(^)(SysSafeHandleStatus status))completion;

// 判断是否支持FaceID和TouchID
+ (SysSafeType)isSupportSysAuthentication;

// 设置安全锁类型
+ (void)setSafeLockType:(SysSafeType)safeType;

// 获取用户设置的安全锁类型
+ (SysSafeType)getSafeType;

@end


