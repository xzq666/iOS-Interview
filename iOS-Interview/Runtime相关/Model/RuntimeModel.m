//
//  RuntimeModel.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/30.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RuntimeModel.h"
#import <objc/runtime.h>
#import "TargetModel.h"

@implementation RuntimeModel

// 消息发送
//- (void)instanceTest {
//    NSLog(@"%s", __func__);
//}
//
//+ (void)classTest {
//    NSLog(@"%s", __func__);
//}

void c_other(id self, SEL _cmd)
{
    NSLog(@"c_other %@ - %@", self, NSStringFromSelector(_cmd));
}

// 动态方法解析
//+ (BOOL)resolveClassMethod:(SEL)sel {
//    if (sel == @selector(classTest)) {
//        // 类方法需要添加到元类对象中
//        class_addMethod(object_getClass(self), sel, (IMP)c_other, "v16@0:8");
//        return YES;
//    }
//    return [super resolveClassMethod:sel];
//}
//
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(instanceTest)) {
//        // 添加动态方法
//        class_addMethod(self, sel, (IMP)c_other, "v16@0:8");
//        // 返回YES表示有动态方法解析
//        return YES;
//    }
//    return [super resolveInstanceMethod:sel];
//}

// 消息转发（快速转发）
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(instanceTest)) {
//        return [[TargetModel alloc] init];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}
//
//+ (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(classTest)) {
//        return [TargetModel class];
//    }
//    return [super forwardingTargetForSelector:aSelector];
//}

// 消息转发（标准转发）
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(instanceTest)) {
        return nil;
    }
    return [super forwardingTargetForSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(instanceTest)) {
        return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    TargetModel *target = [[TargetModel alloc] init];
    if ([target respondsToSelector:@selector(instanceTest)]) {
        [anInvocation invokeWithTarget:target];
    }
}

+ (id)forwardingTargetForSelector:(SEL)aSelector {
    if (aSelector == @selector(classTest)) {
        return nil;
    }
    return [super forwardingTargetForSelector:aSelector];
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(classTest)) {
        return [NSMethodSignature signatureWithObjCTypes:"v16@0:8"];
    }
    return [super methodSignatureForSelector:aSelector];
}

+ (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([[TargetModel class] respondsToSelector:@selector(classTest)]) {
        [anInvocation invokeWithTarget:[TargetModel class]];
    }
}

@end
