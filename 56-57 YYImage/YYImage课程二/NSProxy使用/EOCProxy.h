//
//  EOCProxy.h
//  NSProxy使用
//
//  Created by 八点钟学院 on 2017/7/28.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EOCProxy : NSProxy

+ (instancetype)proxyWithTarget:(id)target;

@end
