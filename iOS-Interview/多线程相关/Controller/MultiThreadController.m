//
//  MultiThreadController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/9.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MultiThreadController.h"

@interface MultiThreadController ()

@end

@implementation MultiThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"多线程相关";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
        // 开启RunLoop使子线程常驻
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    [thread start];
    
    // 因为子线程默认不开启RunLoop，因此执行到此句代码时子线程已退出，会crash
    // 需要在子线程手动开启RunLoop。
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
}

- (void)test {
    NSLog(@"2");
}

@end
