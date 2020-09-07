//
//  PerformsController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/15.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "PerformsController.h"

@interface PerformsController ()

@end

@implementation PerformsController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"性能优化相关";
}

@end
