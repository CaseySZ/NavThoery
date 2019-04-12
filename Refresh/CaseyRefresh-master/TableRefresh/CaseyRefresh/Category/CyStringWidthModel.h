//
//  StringWidthModel.h
//  IOS_B01
//
//  Created by Casey on 15/01/2019.
//  Copyright © 2019 Casey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CyStringWidthModel : NSObject


+ (CGFloat)getWidthWithFont:(UIFont*)font target:(NSString*)targetStr;


@end

