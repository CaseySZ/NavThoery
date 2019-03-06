//
//  Notes.h
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/14.
//  Copyright © 2017年 EOC. All rights reserved.
//

#ifndef Notes_h
#define Notes_h


资源移除必须在当前资源线程移除（timer） 会导致僵死线程



1 NSBlockOperation
    1.1可以使用NSBlockOperation来兵法执行一个或者多个block
    1.2只有NSBlockOperation关联的所有的block都执行完毕，NSBlockOperation才算执行完成

2 NSInvocationOperation
    

=============================
并行与并发区别

当有多个线程在操作时,如果系统只有一个CPU,则它根本不可能真正同时进行一个以上的线程,它只能把CPU运行时间划分成若干个时间段,再将时间段分配给各个线程执行,在一个时间段的线程代码运行时,其它线程处于挂起状态.这种方式我们称之为并发(Concurrent).

当系统有一个以上 CPU 时,则线程的操作有可能非并发.当一个 CPU 执行一个线程时,另一个CPU 可以执行另一个线程,两个线程互不抢占 CPU 资源,可以同时进行,这种方式我们称之为并行(Parallel)

==============================
一般都是把一个任务放到一个串行的queue中，如果这个任务被拆分了，被放置到多个串行的 queue 中，但实际还是需要这个任务同步执行，那么就会有问题，因为多个串行 queue 之间是并行的。

那该如何是好呢？

这是就可以使用 dispatch_set_target_queue 了。
如果将多个串行的 queue 使用 dispatch_set_target_queue 指定到了同一目标，那么着多个串行 queue 在目标 queue 上就是同步执行的，不再是并行执行

============================

首先，系统提供给你一个叫做 主队列（main queue） 的特殊队列。和其它串行队列一样，这个队列中的任务一次只能执行一个。然而，它能保证所有的任务都在主线程执行，而主线程是唯一可用于更新 UI 的线程。这个队列就是用于发生消息给 UIView 或发送通知的。

系统同时提供给你好几个并发队列。它们叫做 全局调度队列（Global Dispatch Queues） 。目前的四个全局队列有着不同的优先级：background、low、default 以及 high。要知道，Apple 的 API 也会使用这些队列，所以你添加的任何任务都不会是这些队列中唯一的任务。

最后，你也可以创建自己的串行队列或并发队列。这就是说，至少有五个队列任你处置：主队列、四个全局调度队列，再加上任何你自己创建的队列。
=============================

void dispatch_resume(dispatch_object_t object); //激活（启动）在dispatch对象上的block调用，可以运行多个block
void dispatch_suspend(dispatch_object_t object); //挂起（暂停）在dispatch对象上的block调用，已经运行的block不会停止

一般这两个函数的调用必须成对，否则运行会出现异常。

========================

// 同步，阻塞主线成， 主线成等待dispatch_sync任务执行完再执行，但队列是先进先出，则dispatch_sync任务等待主线其他先进的任务执行，就这样相互等待，造成了死锁

dispatch_sync(dispatch_get_main_queue(), ^(void){
    
    NSLog(@"dispatch_sync 主线程");
    
    
});

=====================
GCD 的优点：

GCD 提供的 dispatch_after 支持调度下一个操作的开始时间而不是直接进入睡眠。
NSOperation 中没有类似 dispatch_source_t,dispatch_io,dispatch_data_t,dispatch_semaphore_t 等操作。
NSOperation 的优点：

GCD 没有操作依赖。我们可以让一个 Operation 依赖于另一个 Operation，这样的话尽管两个 Operation 处于同一个并行队列中，但前者会直到后者执行完毕后再执行；
GCD 没有操作优先级（GCD 有队列优先级），能够使同一个并行队列中的任务区分先后地执行，而在 GCD 中，我们只能区分不同任务队列的优先级，如果要区分block任务的优先级，也需要大量的复杂代码；
GCD 没有 KVO。NSOperation 可以监听一个 Operation 是否完成或取消，这样能比GCD 更加有效地掌控我们执行的后台任务


在NSOperationQueue 中，我们可以随时取消已经设定要准备执行的任务(当然，已经开始的任务就无法阻止了)，而 GCD 没法停止已经加入 queue 的 Block(其实是有的，但需要许多复杂的代码)
我们能够对 NSOperation 进行继承，在这之上添加成员变量与成员方法，提高整个代码的复用度，这比简单地将 block 任务排入执行队列更有自由度，能够在其之上添加更多自定制的功能。


#endif /* Notes_h */



1 队列

1.1 系统的队列main，global（4种）同步，异步
1.1 实际编程经验告诉我们，尽可能避免使用dispatch_sync，嵌套使用时还容易引起程序死锁
1.2 dispatch队列是线程安全的，可以利用串行队列实现锁的功能
1.3 group
1.4 barrier
1.5 apply(重复执行)


2 源 sourece

2.1 定时器


