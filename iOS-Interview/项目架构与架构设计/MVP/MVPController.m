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
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"MVP";
    
    [[MVPPresent alloc] initWithController:self];
}

@end
