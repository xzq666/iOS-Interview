//
//  MessagePassController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/24.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MessagePassController.h"

@interface MessagePassController ()

@end

@implementation MessagePassController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息传递方式";
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    
    [self messagePass];
}

- (void)messagePass {
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.frame = CGRectMake(10, 100, 100, 30);
    [btn1 setTitle:@"代理返回" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    [btn1 addTarget:self action:@selector(delegateBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.frame = CGRectMake(10, 140, 100, 30);
    [btn2 setTitle:@"block返回" forState:UIControlStateNormal];
    [self.view addSubview:btn2];
    [btn2 addTarget:self action:@selector(blockBack) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn3.frame = CGRectMake(10, 180, 100, 30);
    [btn3 setTitle:@"通知返回" forState:UIControlStateNormal];
    [self.view addSubview:btn3];
    [btn3 addTarget:self action:@selector(notificationBack) forControlEvents:UIControlEventTouchUpInside];
}

- (void)delegateBack {
    if ([self.delegate respondsToSelector:@selector(testWithParam1:param2:)]) {
        [self.delegate testWithParam1:@"delegate111" param2:@"delegate222"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)blockBack {
    if (self.block) {
        self.block(@"block111", @"block222");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)notificationBack {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getValueFromVC" object:@{@"param1": @"notification111", @"param2": @"notification222"}];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
