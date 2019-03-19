//
//  main.m
//  debug-objc
//
//  Created by 陈爱彬 on 2017/12/6. Maintain by 陈爱彬
//  Description 
//

#import <Foundation/Foundation.h>
@interface TestObject : NSObject

@property (nonatomic, strong)NSObject *object;

@end


@implementation TestObject


- (NSObject*)testMethod {
    
    return [[NSObject alloc] init];
}


- (void)testMethodIn:(TestObject*)objc {
    
    
}

@end

int main(int argc, const char * argv[]) {
    
    
    
    @autoreleasepool {
        // insert code here...
        
            //TestObject *testObj = [[TestObject alloc] init];
             __weak NSObject *obj = [[NSObject alloc] init];
            //NSObject *obj = [[NSObject alloc] init];
            //NSMutableArray *arr = [[NSMutableArray alloc] init];
          //  testObj.object = obj;
           // NSObject *tmp = obj;
         //   [testObj testMethodIn:testObj];
           // [testObj testMethod];
        
           // [testObj testMethod:obj];
            [NSArray arrayWithObjects:@"1", @"2", nil];
        
        NSLog(@"Hello, World!");
    }
    return 0;
}


/*
 Autoreleasepool 与 Runloop 的关系
 ARC 下什么样的对象由 Autoreleasepool 管理
 子线程默认不会开启 Runloop，那出现 Autorelease 对象如何处理？不手动处理会内存泄漏吗？
 
 */

/* 一、 基本情况
 
 NSObject *obj = [[NSObject alloc] init];
 [NSArray arrayWithObjects:@"1",@"2",nil];
 
 
 1 看 autorelease 即执行了 _objc_rootAutorelease 才添加到pool中自动处理。
  看便利构造器， 就是auto的
 
 2 alloc/new/copy/mutableCopy， 不需要pool管理，系统会自动的帮他在合适位置release
 */


/* 二 赋值默认情况  Strong 修饰
 
 
 */


/*  二.1
 TestObject *testObj = [[TestObject alloc] init];
 NSObject *obj = [[NSObject alloc] init];
 testObj.object = obj; // 断点看，执行了   objc_storeStrong// 属性Strong 源码实现
 
 
 代码执行完，看到 testObj 执行了一次 objc_object::release()
 obj 执行了两次 objc_object::release()
 
 两个对象都没执行 _objc_rootAutorelease ，也就是说，不需要pool管理，系统会自动的帮他在合适位置release
 
 */

/* 二.2
 
 NSObject *obj = [[NSObject alloc] init];
 NSObject *tmp = obj;
 
 
 底层逻辑， 默认是strong
 id obj = objc_msgSend(NSObject, "new");
 objc_storeStrong(&tmp, obj)
 
 objc_release(obj);
 objc_release(tmp);
 
 
 */


/* 三 方法返回参数  默认情况 __autorealeasing 修饰
 
 TestObject *testObj = [[TestObject alloc] init];
 [testObj testMethod]; // 断点
 
 对象的指针在没有显式指定时会被附加上__autorealeasing修饰
 如 testMethod 方法返回的对象。 //  [testObj testMethod]
 
 入参不会 自动 __autorealeasing修饰
 如果在方法里直接赋值 并不会默认 __autorealeasing修饰，如 id A = obj; 默认是Strong ，会执行 objc_storeStrong
 
 */



/* 四 方法入参  Strong 修饰
 
 TestObject *testObj = [[TestObject alloc] init];
 [testObj testMethodIn:testObj]; // 断点
 
 */


/* 五 总结 三个属性的默认状态
 
  __strong   // objc_storeStrong
  __autoreleasing    //   objc_autorelease   --> (objc_object::autorelease() runtime) --> rootAutorelease2 --> AutoreleasePoolPage::autorelease((id)this)
  __weak。// objc_initWeak
 
 
 */




/*
 weak_is_registered_no_lock  weak表注册
 weak_entry_for_referent
 weak_entry_insert
 
 weak_clear_no_lock
 
 storeWeak
 
 */
