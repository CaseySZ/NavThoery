//
//  SafeLoginView.h
//  SafeGesture
//
//  Created by Casey on 26/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysSafeIDModel.h"

@interface UnlockSafeLoginView : UIView


@property (nonatomic, strong)void(^completion)(SysSafeHandleStatus status);
@property (nonatomic, strong)void(^changeMethod)(void);

@property (nonatomic, assign)BOOL isSettingLock; // 设置锁

@end


