//
//  RunLoopController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/6.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "RunLoopController.h"
#import "XZQPermenantThread.h"

@interface RunLoopController ()

@property(nonatomic,strong) XZQPermenantThread *thread;

@end

@implementation RunLoopController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"RunLoop相关";
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(20, 200, 100, 40);
    [btn setTitle:@"execute" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(execute) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *stopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    stopBtn.frame = CGRectMake(140, 200, 100, 40);
    [stopBtn setTitle:@"stop" forState:UIControlStateNormal];
    [self.view addSubview:stopBtn];
    [stopBtn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    
    [self runloopObserver];
    
    [self performTest];
    
    self.thread = [[XZQPermenantThread alloc] init];
    [self.thread run];
}

- (void)runloopObserver {
    // NSRunLoop是基于CFRunLoopRef的一层OC包装
    NSLog(@"%p - %p", [NSRunLoop currentRunLoop], [NSRunLoop mainRunLoop]);
    NSLog(@"%p - %p", CFRunLoopGetCurrent(), CFRunLoopGetMain());
    
    // 创建Observer
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry: {
                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
                NSLog(@"kCFRunLoopEntry - %@", mode);
                CFRelease(mode);
                break;
            }
                
            case kCFRunLoopExit: {
                CFRunLoopMode mode = CFRunLoopCopyCurrentMode(CFRunLoopGetCurrent());
                NSLog(@"kCFRunLoopExit - %@", mode);
                CFRelease(mode);
                break;
            }
                
            default:
                break;
        }
    });
    // 添加Observer
    CFRunLoopAddObserver(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    // 释放
    CFRelease(observer);
}

- (void)performTest {
    // 主线程默认开启了RunLoop，所以可以执行
    [self performSelector:@selector(test) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(test) onThread:[NSThread currentThread] withObject:nil waitUntilDone:YES];
    
    // 子线程默认不开启RunLoop，不可以执行
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        [self performSelector:@selector(test) withObject:nil afterDelay:1.0];
        // 需要手动开启RunLoop才可以执行
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    });
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"1");
        // 需要开启RunLoop让线程永驻
//        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }];
    [thread start];
    [self performSelector:@selector(test) onThread:thread withObject:nil waitUntilDone:YES];
}

- (void)test {
    NSLog(@"test");
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
}

- (void)execute {
    [self.thread executeTask:^{
        NSLog(@"执行任务 - %@", [NSThread currentThread]);
    }];
}

- (void)stop {
    [self.thread stop];
}

@end
