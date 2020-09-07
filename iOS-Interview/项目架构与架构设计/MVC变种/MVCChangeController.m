//
//  MVCChangeController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MVCChangeController.h"
#import "MVCChangeView.h"
#import "MVCChangeModel.h"

@interface MVCChangeController ()

@end

@implementation MVCChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"MVC变种";
    
    MVCChangeView *mvcView = [[MVCChangeView alloc] initWithFrame:CGRectMake(100, 100, 100, 130)];
    [self.view addSubview:mvcView];
    
    MVCChangeModel *model = [[MVCChangeModel alloc] init];
    model.iconUrl = @"female_icon";
    model.name = @"female";
    
    [mvcView setViewWithModel:model];
}

@end
