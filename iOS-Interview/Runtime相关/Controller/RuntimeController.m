//
//  RuntimeController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/30.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RuntimeController.h"
#import "RuntimeModel.h"

@interface RuntimeController ()

@end

@implementation RuntimeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Runtime相关";
    
    RuntimeModel *model = [[RuntimeModel alloc] init];
    [model instanceTest];
    [RuntimeModel classTest];
}

@end
