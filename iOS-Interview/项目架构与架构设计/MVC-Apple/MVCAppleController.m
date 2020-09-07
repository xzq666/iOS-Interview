//
//  MVCAppleController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MVCAppleController.h"
#import "MVCAppleView.h"
#import "MVCAppleModel.h"

@interface MVCAppleController ()

@end

@implementation MVCAppleController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"MVC-Apple";
    
    MVCAppleView *mvcView = [[MVCAppleView alloc] initWithFrame:CGRectMake(100, 100, 100, 130)];
    [self.view addSubview:mvcView];
    
    MVCAppleModel *model = [[MVCAppleModel alloc] init];
    model.iconUrl = @"female_icon";
    model.name = @"female";
    
    mvcView.imageView.image = [UIImage imageNamed:model.iconUrl];
    mvcView.label.text = model.name;
}

@end
