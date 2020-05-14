//
//  MVVMController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MVVMController.h"
#import "MVVMViewModel.h"

@interface MVVMController ()

@property(nonatomic,weak) MVVMViewModel *viewModel;

@end

@implementation MVVMController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"MVVM";
    
    self.viewModel = [[MVVMViewModel alloc] initWithController:self];
}

@end
