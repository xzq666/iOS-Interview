//
//  DebugController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/18.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "DebugController.h"

@interface DebugController ()

@end

@implementation DebugController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"iOS调试技巧";
}

@end
