//
//  UnlockSafeLoginView.h
//  SafeGesture
//
//  Created by Casey on 25/02/2019.
//  Copyright © 2019 n. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SysSafeIDModel.h"

@interface SystemAuthView : UIView


@property (nonatomic, assign)BOOL isFaceID; // YES 是faceID功能， NO，是touchID功能
@property (nonatomic, weak)id<SysSafeHandleProtocol>delegate;

@end


