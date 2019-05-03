//
//  SafeLockPlugIn.h
//  SafeGesture
//
//  Created by Casey on 26/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SysSafeIDModel.h"




@interface SafeLockPlugIn : NSObject



/**
 
 打开设置锁功能View
 
 error == nil 成功
 @param completion  操作完成回调
 */
+ (void)alertOpenSettingLockView:(void(^)(SysSafeType type, SysSafeHandleStatus resultStatus))completion;



/**
 打开/关闭 安全锁类型

 @param lockStyle 安全锁类型
 @param isOpen YES 打开， NO 关闭
 
 */

+ (void)setLock:(SysSafeType)lockStyle isOpen:(BOOL)isOpen;


/**
 
 打开解锁功能view, 这个必须和closeUnlockView一起使用

 @param completion 完成处理的回调 finsishStatus 完成状态
 @param changeMethod 切换登录方式的回调
 @return YES 打开成功， NO 打开失败
 */

+ (BOOL)openUnlockView:(void(^)(SysSafeHandleStatus finsishStatus))completion changeLoginMethod:(void(^)(void))changeMethod;




/**
 关闭解锁view
 */
+ (void)closeUnlockView;


@end


