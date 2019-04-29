//
//  GCDViewCtr.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/23.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "GCDViewCtr.h"

@interface GCDViewCtr (){
    
    NSMutableArray *_safeAry;
    dispatch_queue_t rwQueue;
}

@end

@implementation GCDViewCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    _safeAry = [NSMutableArray array];
    [_safeAry addObject:@"0"];
    [_safeAry addObject:@"1"];
    [_safeAry addObject:@"2"];
    [_safeAry addObject:@"3"];
    rwQueue = dispatch_queue_create("serQueue", DISPATCH_QUEUE_CONCURRENT);
    
    //
//    dispatch_sync(rwQueue, ^{
//        NSLog(@"rwQueue:%@", [NSThread currentThread]);
//    });
//    dispatch_async(rwQueue, ^{
//
//    });
   // [self testRWAry];
}
/*
 如果我们cpu是单核，能不能并行操作任务：不能 （）
 如果我们cpu是双核，能不能并行操作任务：能 cpu1 处理A， cpu2 处理B
 */
// 串行队列 只能开启一个任务 （串发dispatch_sync）
- (void)serialQueue{
    
    dispatch_queue_t queue = dispatch_queue_create("serQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"1:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3:%@", [NSThread currentThread]);
    });
    
    dispatch_sync(queue, ^{
        NSLog(@"4:%@", [NSThread currentThread]);
    });
}

// 并行队列 同时可以开启多个任务 （并发dispatch_async）
- (void)conCurrentQueue{
    
    dispatch_queue_t queue = dispatch_queue_create("serQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"1:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2:%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3:%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
         NSLog(@"4当前线程:%@", [NSThread currentThread]);
    });
}

// 组 多个任务执行
- (void)group_gcd{
    
    // 1 创建组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("serQueue", DISPATCH_QUEUE_CONCURRENT);
    // 2向组添加任务  任务数count=3
    dispatch_group_async(group, queue, ^{
        NSLog(@"task one::%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"task two::%@", [NSThread currentThread]);
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"task three::%@", [NSThread currentThread]);
    });
    
    // 3组任务全部完成了，就通知  任务数count为0
    dispatch_group_notify(group, queue, ^{
        NSLog(@"finish all task");
    });
    
    
}
// 一个界面执行加载多个网络请求，可以用到group

- (void)groupStyleTwo{
    
    // 1 创建组
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("serQueue", DISPATCH_QUEUE_CONCURRENT);
    
    // 填加一个空任务
    for (int i = 0; i < 3; i++) {
        dispatch_group_enter(group); // 任务数+1
        
        dispatch_async(queue, ^{
            [self netLoadSync:i]; // 如果在这个任务再开一个线程，那么不能保证你的需求
            dispatch_group_leave(group);// 任务数-1
        });
    }
    
    // 3组任务全部完成了，就通知
    dispatch_group_notify(group, queue, ^{
        NSLog(@"finish all task");
    });
}

// task 同步
- (void)netLoadSync:(int)taskCount
{
    NSString *urlstr = [NSString stringWithFormat:@"%@?versions_id=1&system_type=1", URLPath];
    NSURL *url = [NSURL URLWithString:urlstr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
      //  NSDictionary *infoDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSLog(@"完成了,taskcount:%d", taskCount);
        dispatch_semaphore_signal(sema);
        
    }];
    [task resume];
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"finish 代码跑完了：%d",taskCount);
}


//栅栏
- (void)barrier_fct{
    
    dispatch_queue_t queue = dispatch_queue_create("serQueue", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"分界线前：taskOne");
    });
    dispatch_async(queue, ^{
        NSLog(@"分界线前：taskTwo");
    });
    dispatch_async(queue, ^{
        NSLog(@"分界线前：taskThree");
    });
    dispatch_barrier_async(queue, ^{ // 分界线里面，queue可以看作是串行的，当前只能执行barrier里面的task
        NSLog(@"分界线里面的任务");
    });
    dispatch_async(queue, ^{
        NSLog(@"分界线后：taskFour");
    });
    dispatch_async(queue, ^{
        NSLog(@"分界线后：taskFive");
    });
}

/* 读写数组 mutableAry,如果开几个线程来操作数组
  1 写数组（移除index=0对象）， 2 写数组（移除index=0的对象） ／／ 有问题
  1 读数组 ， 2 读数组 ／／ 没问题
  1 读数组    2写数组
  只要涉及到写操作（要做保护）
 
 */

- (void)testRWAry{
    
    dispatch_queue_t queue = dispatch_queue_create("testRWAry", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 20; i++) {
        // 读
        dispatch_async(queue, ^{
            NSLog(@"%d::%@", i, [self indexTo:i]);
        });
        
        // 写
        dispatch_async(queue, ^{
            [self addObject:[NSString stringWithFormat:@"%d", i+4]];
        });
    }
    
}
// 写 保证只有一个在操 作（避免了同时多个写操作导致的问题）
- (void)addObject:(NSString*)object{
    
    dispatch_barrier_async(rwQueue, ^{
        if (object != nil) {
            [_safeAry addObject:object];
        }
    });
    
}
// 主队列 mainqueue--》 主线程 mainThread
// 注意同步，因为业务关系，必须马上数据
- (NSString*)indexTo:(NSInteger)index{
    __block NSString *result = nil;
    dispatch_sync(rwQueue, ^{
        if (index < _safeAry.count) {
            result = _safeAry[index];
        }
    });
    return result;
}


// 重复 执行任务
- (void)apply_gcd{
    
    dispatch_queue_t queue = dispatch_queue_create("testRWAry", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply(5, queue , ^(size_t count) {
        
        NSLog(@"%d", count);
        
    });
    
}

// 延后
- (void)after_GCD{
    
    dispatch_queue_t queue = dispatch_queue_create("testRWAry", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"start:%@", [NSThread currentThread]);
        dispatch_after(1, queue, ^{
            NSLog(@"dispatch_after:%@", [NSThread currentThread]);
        });
        NSLog(@"end");
        
    });
}

// 激活
- (void)queueInactive{
    
    dispatch_queue_t queue = dispatch_queue_create("testRWAry", DISPATCH_QUEUE_CONCURRENT_INACTIVE);
    dispatch_async(queue, ^{
        
        NSLog(@"start:%@", [NSThread currentThread]);
        
    });
    dispatch_activate(queue);
}

void testFunction(){
    
    NSLog(@"testFunction::-->%@", [NSThread currentThread]);
    
}

// _f IMP
- (void)function_f{
    
    dispatch_queue_t queue = dispatch_queue_create("testRWAry", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async_f(queue, nil, testFunction);
    
   
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self function_f];
}

@end
