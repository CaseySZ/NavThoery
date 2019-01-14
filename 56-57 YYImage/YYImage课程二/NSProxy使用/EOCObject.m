//
//  EOCObject.m
//  NSProxy使用
//
//  Created by 八点钟学院 on 2017/7/28.
//  Copyright © 2017年 八点钟学院. All rights reserved.
//

#import "EOCObject.h"
#import "EOCProxy.h"

@interface EOCObject () {
    
    __weak id _target;
    
}

@end

@implementation EOCObject

-(instancetype)initWithTarget:(id)target {
    
    if (self = [super init]) {
        
        _target = target;
        
    }
    return self;
    
}

- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (void)dealloc {
    
    NSLog(@"EOCObject dealloc");
    
}

@end
