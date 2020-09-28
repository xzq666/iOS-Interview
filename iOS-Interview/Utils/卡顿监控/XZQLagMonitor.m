//
//  XZQLagMonitor.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/7/13.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQLagMonitor.h"
#import <mach/mach.h>
#import <execinfo.h>

@interface XZQLagMonitor () {
    int timeoutCount;  // 超时次数
    CFRunLoopObserverRef runLoopObserver;  // 观察者
    NSMutableArray *_backtrace;
    @public
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runLoopActivity;  // RunLoop运行阶段
}

@end

@implementation XZQLagMonitor

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)beginMoitor {
    NSLog(@"begin monitor");
    // 监测卡顿
    if (runLoopObserver) {
        return;
    }
    dispatchSemaphore = dispatch_semaphore_create(0);  // 创建信号保证同步
    // 创建一个观察者
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    // 将观察者添加到主线程runloop的common模式下
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    // 创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 子线程开启一个持续的loop用来进行监控
        while (YES) {
            // 假定连续5次超时50ms或单次超过250ms就认为是卡顿
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 50 * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->runLoopObserver) {
                    self->timeoutCount = 0;
                    self->dispatchSemaphore = 0;
                    self->runLoopActivity = 0;
                    return;
                }
                // BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                if (self->runLoopActivity == kCFRunLoopBeforeSources || self->runLoopActivity == kCFRunLoopAfterWaiting) {
                    NSLog(@"monitor trigger");
                    if (++self->timeoutCount < 5) {
                        continue;
                    }
                    [self logStack];
                    [self printLogTrace];
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        // 将堆栈信息上报服务器写在这里
                    });
                } //end activity
            } // end semaphore wait
            self->timeoutCount = 0;
        }
    });
}

- (void)logStack {
    void* callstak[128];
    int frames = backtrace(callstak, 128);
    char **strs = backtrace_symbols(callstak, frames);
    int i;
    _backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = 0; i < frames; i++) {
        [_backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
}

- (void)endMonitor {
    // 释放观察者
    if (!runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}

- (void)printLogTrace {
    NSLog(@"==========堆栈\n %@ \n", _backtrace);
}

#pragma mark - Private

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    XZQLagMonitor *lagMonitor = (__bridge XZQLagMonitor*)info;
    lagMonitor->runLoopActivity = activity;
    // 发送信号
    dispatch_semaphore_t semaphore = lagMonitor->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

@end
