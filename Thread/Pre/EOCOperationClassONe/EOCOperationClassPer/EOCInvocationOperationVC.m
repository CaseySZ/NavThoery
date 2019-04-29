//
//  EOCNSInvotionOperation.m
//  EOCOperationClassPer
//
//  Created by EOC on 2017/4/19.
//  Copyright © 2017年 EOC. All rights reserved.
//

#import "EOCInvocationOperationVC.h"

@interface EOCInvocationOperationVC (){
    
    NSInvocationOperation *_invocationOperation;
    NSInvocation *invation ;
    NSString *backStr;
}

@end

@implementation EOCInvocationOperationVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 3 selector  方法签名（方法的对象结构，相关的结构信息：返回值，调用者，方法名，参数）
    NSMethodSignature *signture = [self methodSignatureForSelector:@selector(name:age:sex:)];
    
    // 2 signture
    invation = [NSInvocation invocationWithMethodSignature:signture] ;
    invation.target = self;
    invation.selector = @selector(name:age:sex:); //和签名的seletor要对应起来
    
    // 配置参数
    NSString *name = @"eoc";
    NSString *age = @"2";
    NSString *sex = @"男";
    
    [invation setArgument:&name atIndex:2];
    [invation setArgument:&age atIndex:3];
    [invation setArgument:&sex atIndex:4];
    
    //[invation getReturnValue:];
    // 1 需要 invation
    _invocationOperation = [[NSInvocationOperation alloc] initWithInvocation:invation];
    
    // 手动掉用
    //[invation invoke];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    [queue addOperation:_invocationOperation];
    
}



//把这个方法 看作一个比较耗时业务
- (NSString*)name:(NSString*)name age:(NSString*)age sex:(NSString*)sex{
   
    NSLog(@"name: age: sex:%@", [NSThread currentThread]);
    return [NSString stringWithFormat:@"%@%@%@", name, age, sex];
    
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    __unsafe_unretained NSString *returnValue;
    [invation getReturnValue:&returnValue];
    NSLog(@"returnValue:%@", returnValue);
}





@end
