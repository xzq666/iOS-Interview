//
//  CategoryController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/27.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "CategoryController.h"
#import "CategoryFirstModel.h"
#import "CategorySecondModel.h"
#import "CategoryFirstSubModel.h"

@interface CategoryController ()

@end

@implementation CategoryController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"分类Category相关";
    
    CategoryFirstModel *model1 = [[CategoryFirstModel alloc] init];
    CategorySecondModel *model2 = [[CategorySecondModel alloc] init];
    [model1 test];
    [model2 test];
    
    CategoryFirstSubModel *model3 = [[CategoryFirstSubModel alloc] init];
    [model3 test];
    
    // 再发送消息时不会再调用initialize方法了
    [model1 test];
    
    model1.name = @"xzq";
    NSLog(@"name is %@", model1.name);
}

@end
