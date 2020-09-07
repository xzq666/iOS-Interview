//
//  CodeController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/19.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "CodeController.h"

@interface CodeController ()

@end

@implementation CodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"源码理解";
}

@end
