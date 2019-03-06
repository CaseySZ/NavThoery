//
//  EOCNSInvotionOperation.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/19.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCInvocationOperationVC.h"

@interface EOCInvocationOperationVC (){
    
    NSString *_nameStr;
    NSString *_ageStr;
    NSString *_sexStr;
    
    NSInvocationOperation *invocationOperation;
    NSOperationQueue *operationQueue;
    NSInvocation *invocation; // 方法对象化
}

@end

@implementation EOCInvocationOperationVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = @"InvocationOperation";
    operationQueue = [NSOperationQueue new];
    [self styelTow];
}


- (void)styelTow{
    
    
    // 方法签名中保存了方法的名称、参数相关信息、返回值相关信息，
    // 和方法调用没太大关系，po可以看出，memory的大小和偏移位置，把方法对象化的一个过程
    //1、初始化NSMethodSignature
    NSMethodSignature *signature = [self methodSignatureForSelector:@selector(name:age:sex:)];
    
    // NSInvocation中保存了方法所属的对象地址、方法名称、参数地址、返回值地址
    //其实NSInvocation就是将一个方法变成一个对象
    //2、创建NSInvocation对象
    invocation = [NSInvocation invocationWithMethodSignature:signature];
    
    
    // 3设置调用者
    invocation.target = self;
    
   //4 注意：这里的方法名一定要与方法签名类中的方法一致
    invocation.selector = @selector(name:age:sex:);
    
    // 5配置参数
    NSString *name = @"EOC";
    NSString *age = @"2";
    NSString *sex = @"男";
    
    [invocation setArgument:&name atIndex:2];
    [invocation setArgument:&age atIndex:3];
    [invocation setArgument:&sex atIndex:4];
    
    invocationOperation = [[NSInvocationOperation alloc] initWithInvocation:invocation];
    
    // 6手动调用
    // [invocation invoke];
    
    
   // [operationQueue addOperation:invocationOperation];
}

////
//- (NSInvocation)target:(id)target sel:(sel) agr:(NSArray*)agr{
//    
//    
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    NSString *backS = nil;
    [invocation getReturnValue:&backS];
    
    NSLog(@"backS :%@", backS);
    
    
}

- (void)styelOne{
    
    invocationOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(methodInvocation) object:nil];
    [operationQueue addOperation:invocationOperation];
    
}

- (NSString*)name:(NSString*)name age:(NSString*)age sex:(NSString*)sex{
    
    NSLog(@"%@, %@, %@", name, age, sex);
    
    return @"name";
}


- (void)methodInvocation{
    
    NSLog(@"%@", [NSThread currentThread]);
    

}



@end
