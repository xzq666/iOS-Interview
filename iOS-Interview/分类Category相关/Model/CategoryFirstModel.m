//
//  CategoryFirstModel.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/27.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "CategoryFirstModel.h"
#import <objc/runtime.h>

@implementation CategoryFirstModel

+ (void)load {
    NSLog(@"%s", __func__);
}

+ (void)initialize
{
    NSLog(@"%s", __func__);
    if (self == [CategoryFirstModel class]) {
        // 只有自身类调用时才执行
        NSLog(@"只有自身类(%s)调用时才执行", object_getClassName(self));
    }
}

- (void)test {
    NSLog(@"%s", __func__);
}

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_COPY);
}

- (NSString *)name {
    return objc_getAssociatedObject(self, _cmd);
}

@end
