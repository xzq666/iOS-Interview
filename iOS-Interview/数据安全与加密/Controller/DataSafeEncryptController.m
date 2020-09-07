//
//  DataSafeEncryptController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/18.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "DataSafeEncryptController.h"

@interface DataSafeEncryptController ()

@end

@implementation DataSafeEncryptController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"数据安全与加密";
}

@end
