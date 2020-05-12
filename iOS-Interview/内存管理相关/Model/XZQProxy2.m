//
//  XZQProxy2.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/12.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQProxy2.h"

@implementation XZQProxy2

+ (id)initWithtarget:(id)target {
    XZQProxy2 *proxy = [[XZQProxy2 alloc] init];
    proxy.target = target;
    return proxy;
}

/*
 NSProxy的子类在方法找不到时不会去父类中寻找，也不会经过动态方法解析，而是直接走消息转发阶段的方法签名
 NSProxy不提供forwardingTargetForSelector方法
*/

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [self.target methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation invokeWithTarget:self.target];
}

@end
