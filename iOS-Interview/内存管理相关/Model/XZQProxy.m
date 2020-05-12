//
//  XZQProxy.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/12.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQProxy.h"

@implementation XZQProxy

+ (id)initWithTarget:(id)target {
    XZQProxy *proxy = [[XZQProxy alloc] init];
    proxy.target = target;
    return proxy;
}

// 消息转发，将消息转交给原本应该执行方法的对象
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

@end
