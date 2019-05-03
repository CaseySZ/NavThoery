//
//  UIAlertInputController.h
//  IOS_B01
//
//  Created by Casey on 04/01/2019.
//  Copyright © 2019 Casey. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIAlertSafeLogController : UIAlertController


+ (instancetype)alertWithTitle:(NSString*)title message:(NSString*)message;


@property (nonatomic, strong)UIImage *logImage;

@end


