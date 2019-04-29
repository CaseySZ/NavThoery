//
//  RecursiveLock.h
//  EOCOperationClassPer
//
//  Created by sy on 2017/10/30.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecursiveLock : NSObject{
    
    pthread_mutex_t _reclock;
    NSRecursiveLock *recursiveLock;
}

- (void)recursiveLock;
- (void)recursiveLockTheory;

@end
