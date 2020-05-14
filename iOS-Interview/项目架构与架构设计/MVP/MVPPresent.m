//
//  MVPPresent.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MVPPresent.h"
#import "MVPView.h"
#import "MVPModel.h"

@interface MVPPresent ()

@property(nonatomic,strong) MVPView *mvpView;

@end

@implementation MVPPresent

- (instancetype)initWithController:(UIViewController *)controller {
    if (self = [super init]) {
        self.mvpView = [[MVPView alloc] initWithFrame:CGRectMake(100, 100, 100, 130)];
        [controller.view addSubview:self.mvpView];
        
        MVPModel *model = [[MVPModel alloc] init];
        model.iconUrl = @"female_icon";
        model.name = @"female";
        
        [self.mvpView setViewWithModel:model];
    }
    return self;
}

@end
