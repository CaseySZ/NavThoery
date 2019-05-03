//
//  GestureLockView.h
//  SafeGesture
//
//  Created by Casey on 01/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysSafeIDModel.h"


@interface GestureLockView : UIView


@property (nonatomic, weak)id<SysSafeHandleProtocol>delegate;

@property (nonatomic, assign)BOOL isSettingLockStyle; //  YES 是设置锁功能， NO 解锁功能


@end


