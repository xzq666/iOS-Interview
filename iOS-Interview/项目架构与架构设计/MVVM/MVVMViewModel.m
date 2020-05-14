//
//  MVVMViewModel.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MVVMViewModel.h"
#import "MVVMView.h"
#import "MVVMModel.h"

@interface MVVMViewModel ()

@property(nonatomic,strong) MVVMView *xzqView;

@property(nonatomic,copy) NSString *iconUrl;
@property(nonatomic,copy) NSString *name;

@end

@implementation MVVMViewModel

- (instancetype)initWithController:(UIViewController *)controller {
    if (self = [super init]) {
        self.xzqView = [[MVVMView alloc] initWithFrame:CGRectMake(100, 100, 100, 130)];
        self.xzqView.viewModel = self;
        [controller.view addSubview:self.xzqView];
        
        MVVMModel *model = [[MVVMModel alloc] init];
        model.iconUrl = @"female_icon";
        model.name = @"female";
        
        // 设置数据
        self.name = model.name;
        self.iconUrl = model.iconUrl;
    }
    return self;
}

@end
