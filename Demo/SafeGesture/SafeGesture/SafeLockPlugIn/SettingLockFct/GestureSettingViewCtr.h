//
//  GestureSettingViewCtr.h
//  SafeGesture
//
//  Created by Casey on 26/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysSafeIDModel.h"


@interface GestureSettingViewCtr : UIViewController


@property (nonatomic, strong)void(^completion)(NSUInteger type, SysSafeHandleStatus resultStatus);

@end


