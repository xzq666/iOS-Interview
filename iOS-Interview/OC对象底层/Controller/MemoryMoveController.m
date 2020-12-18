//
//  MemoryMoveController.m
//  iOS-Interview 内存平移
//
//  Created by qhzc-iMac-02 on 2020/12/17.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MemoryMoveController.h"
#import <objc/runtime.h>

@interface XZQClass : NSObject
@property(nonatomic,copy) NSString *name;
- (void)sayHello;
+ (void)sayHappy;
@end
@implementation XZQClass
- (void)sayHello { NSLog(@"%s: 你好 - %@", __func__, self.name); }
+ (void)sayHappy { NSLog(@"happy"); }
@end

@interface MemoryMoveController ()

@end

@implementation MemoryMoveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"内存平移";
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    XZQClass *p = [[XZQClass alloc] init];
    // 第一次调用
    [p sayHello];
    // 第二次调用
    [p sayHello];
    
    // 指针读取类地址，强转为对象，调用方法
    Class cls = [XZQClass class];
    // &cls只是和isa一样指向了XZQClass。并不是真正的isa
    void *ht = &cls;
    // 之所以这里name属性会打印出MemoryMoveController是因为发生了越界读取
//    [(__bridge id)ht setName:@"666"];  // 调用set方法运行时是会报错的
    [(__bridge id)ht sayHello];
    
    // 实例化对象，调用方法
    XZQClass *xzq = [[XZQClass alloc] init];
    xzq.name = @"xzq";
    [xzq sayHello];
    
    xzq_objcCopyMethodList([xzq class]);
    xzq_instanceMethodClassToMetaclass([xzq class]);
    xzq_classToMetaClass([xzq class]);
    xzq_IMPClassToMetaClass([xzq class]);
}

void xzq_objcCopyMethodList(Class p)
{
    unsigned int count = 0;
    // Class为类对象，因此获取的是类对象中的方法列表，即对象方法，所以不会获取到类方法
    Method *methods = class_copyMethodList(p, &count);
    for (unsigned int i=0; i < count; i++) {
        Method const method = methods[i];
        // 获取方法名
        NSString *key = NSStringFromSelector(method_getName(method));
        NSLog(@"打印1 - Method, name: %@", key);
    }
    free(methods);
}

void xzq_instanceMethodClassToMetaclass(Class p)
{
    const char *className = class_getName(p);
    Class metaClass = objc_getMetaClass(className);
    // 获取到类的实例方法sayHello的对象是存在的 所以打印sayHello方法的地址
    Method method1 = class_getInstanceMethod(p, @selector(sayHello));
    // 获取到元类的实例方法sayHello的对象是不存在的 所以打印0x0
    Method method2 = class_getInstanceMethod(metaClass, @selector(sayHello));
    // 获取到类的类方法sayHappy的对象是不存在的 所以打印0x0
    Method method3 = class_getInstanceMethod(p, @selector(sayHappy));
    // 获取到元类的类方法sayHello的对象是存在的 所以打印sayHappy方法地址
    Method method4 = class_getInstanceMethod(metaClass, @selector(sayHappy));
    NSLog(@"打印2 - %p - %p - %p - %p", method1, method2, method3, method4);
}

void xzq_classToMetaClass(Class p)
{
    const char *className = class_getName(p);
    Class metaClass = objc_getMetaClass(className);
    // class_getClassMethod真实传入的是元类
    Method method1 = class_getClassMethod(p, @selector(sayHello));
    Method method2 = class_getClassMethod(metaClass, @selector(sayHello));
    Method method3 = class_getClassMethod(p, @selector(sayHappy));
    Method method4 = class_getClassMethod(metaClass, @selector(sayHappy));
    NSLog(@"打印2 - %p - %p - %p - %p", method1, method2, method3, method4);
}

void xzq_IMPClassToMetaClass(Class p)
{
    const char *className = class_getName(p);
    Class metaClass = objc_getMetaClass(className);
    // 函数中有个递归 如果通过传入的obj和name在class_getMethodImplementation方法中找不到imp，就调用obj->getIsa() 根据isa的指向去寻找obj的元类，根元类，根根元类，根根元类自己。
    // _objc_msgForward是存在汇编里的 类的所有信息都存在汇编中 而汇编中不区分类方法和对象方法，所以在汇编中总能找到对应的方法imp，
    // 因此调用这个方法必然能找到对应的imp
    IMP imp1 = class_getMethodImplementation(p, @selector(sayHello));
    IMP imp2 = class_getMethodImplementation(metaClass, @selector(sayHello));
    IMP imp3 = class_getMethodImplementation(p, @selector(sayHappy));
    IMP imp4 = class_getMethodImplementation(metaClass, @selector(sayHappy));
    NSLog(@"打印3 - %p - %p - %p - %p", imp1, imp2, imp3, imp4);
}

@end
