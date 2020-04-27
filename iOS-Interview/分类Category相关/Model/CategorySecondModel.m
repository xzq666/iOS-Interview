//
//  CategorySecondModel.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/27.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "CategorySecondModel.h"

@implementation CategorySecondModel

+ (void)load {
    NSLog(@"%s", __func__);
}

+ (void)initialize
{
    NSLog(@"%s", __func__);
    if (self == [CategorySecondModel class]) {
        // 只有自身类调用时才执行
        NSLog(@"只有自身类(%s)调用时才执行", object_getClassName(self));
    }
}

- (void)test {
    NSLog(@"%s", __func__);
}

@end
