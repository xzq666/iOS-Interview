//
//  UIController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "UIController.h"
#import "XZQButton.h"
#import "XZQView.h"

@interface UIController ()

@end

@implementation UIController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"UI相关";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    [self hitResponsePass];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self tableViewDataSync];
}

// 模拟UITableView数据源同步问题
// 使用串行方式解决
- (void)tableViewDataSync {
    dispatch_queue_t serial = dispatch_queue_create("serial", DISPATCH_QUEUE_SERIAL);
    
    // 串行队列
    dispatch_sync(serial, ^{
        // 子线程网络请求，数据解析
        sleep(2);
        NSLog(@"请求数据 - %@", [NSThread currentThread]);
    });
    // 串行队列
    dispatch_sync(serial, ^{
        // 主线程中删除datasource的某一个元素，因为是被加入到了串行队列，因此删除操作需要等待网络请求和数据解析结束后才能进行
        NSLog(@"删除元素 - %@", [NSThread currentThread]);
    });

    NSLog(@"主线程更新");
}

// UIView与CALayer
- (void)viewAndLayer {
    UIView *view = [[UIView alloc] init];
    NSLog(@"block外请求动作 - %@", [view actionForLayer:view.layer forKey:@"position"]);  // 返回<null>，NSNull
    [UIView animateWithDuration:0.3 animations:^{
        NSLog(@"block内请求动作 - %@", [view actionForLayer:view.layer forKey:@"position"]);  // 返回_UIViewAdditiveAnimationAction，一个动画Action
    }];
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(10, 100, 50, 50);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:layer];
}

// 事件传递与视图响应链
- (void)hitResponsePass {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
//    view.userInteractionEnabled = NO;  // 父视图禁止事件时子视图事件就无法传递了
    [self.view addSubview:view];
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    subView.backgroundColor = [UIColor yellowColor];
    subView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    [subView addGestureRecognizer:tap];
    [view addSubview:subView];
    
    
    // XZQView取消判断是否在其bounds内的判断，因此其下的子控件即使超出它的bounds也能响应事件
    XZQView *view2 = [[XZQView alloc] initWithFrame:CGRectMake(10, 230, 100, 100)];
    view2.backgroundColor = [UIColor redColor];
    [self.view addSubview:view2];
    
    // 将UIButton的响应热区扩大
    XZQButton *btn = [[XZQButton alloc] initWithFrame:CGRectMake(-10, 10, 50, 50) minimumHitWidth:70 minimumHitHeight:70];
    btn.backgroundColor = [UIColor yellowColor];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:btn];
}

- (void)click {
    NSLog(@"click");
}

@end
