//
//  XZQPermenantThread.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQPermenantThread.h"

@interface XZQPermenantThread ()

@property(nonatomic,strong) NSThread *innerThread;
@property(nonatomic,assign,getter=isStopped) BOOL stopped;

@end

@implementation XZQPermenantThread

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stopped = NO;
        __weak typeof(self) weakSelf = self;
        self.innerThread = [[NSThread alloc] initWithBlock:^{
            [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
            while (weakSelf && !weakSelf.isStopped) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
        }];
    }
    return self;
}

/*
 开启线程
 */
- (void)run {
    if (!self.innerThread) {
        return;
    }
    [self.innerThread start];
}

/*
 执行任务
 */
- (void)executeTask:(XZQTask)task {
    if (!self.innerThread || !task) {
        return;
    }
    [self performSelector:@selector(__executeTask:) onThread:self.innerThread withObject:task waitUntilDone:NO];
}

/*
 结束线程
 */
- (void)stop {
    if (!self.innerThread) {
        return;
    }
    [self performSelector:@selector(__stop) onThread:self.innerThread withObject:nil waitUntilDone:YES];
}

- (void)dealloc
{
    NSLog(@"%s", __func__);
    [self stop];
}

- (void)__stop {
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.innerThread = nil;
}

- (void)__executeTask:(XZQTask)task {
    task();
}

@end
