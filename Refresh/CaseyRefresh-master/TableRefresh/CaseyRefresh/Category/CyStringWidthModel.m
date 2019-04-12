//
//  StringWidthModel.m
//  IOS_B01
//
//  Created by Casey on 15/01/2019.
//  Copyright © 2019 Casey. All rights reserved.
//

#import "CyStringWidthModel.h"

@implementation CyStringWidthModel


+ (CGFloat)getWidthWithFont:(UIFont*)font target:(NSString*)targetStr{
    
    if (targetStr.length == 0) {
        return 0;
    }
    
    NSDictionary *attribute = @{
                                NSFontAttributeName:font,
                                };
    
    CGSize maxSize = CGSizeMake(300, 30);
    CGRect contentRect = [targetStr boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    CGSize retSize = CGRectIntegral(contentRect).size;
    
    return retSize.width;
    
}


@end
