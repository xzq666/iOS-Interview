//
//  OCLanguageController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/24.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "OCLanguageController.h"
#import <objc/runtime.h>

@interface OCLanguageController ()

@end

@implementation OCLanguageController

@dynamic height;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"OC语言";
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    
    [self test];
    
//    self.height = 1;  // 编译时不会报错，但运行时由于是@dynamic并且没有手动实现setter方法会crash

    __weak __typeof__(self) weakSelf1 = self;
    __weak __typeof(self) weakSelf2 = self;
    __weak typeof(self) weakSelf3 = self;
    [weakSelf1 test];
    [weakSelf2 test];
    [weakSelf3 test];
}

- (void)test {
    // [self class]和[super class]返回结果是一样的
    NSLog(@"[self class] - %@", [self class]);
    NSLog(@"[super class] - %@", [super class]);
}

@end
