//
//  MVPController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MVPController.h"
#import "MVPPresent.h"

@interface MVPController ()

@end

@implementation MVPController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"MVP";
    
    [[MVPPresent alloc] initWithController:self];
}

@end
