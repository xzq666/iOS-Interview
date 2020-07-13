//
//  XZQLagMonitor.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/7/13.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQLagMonitor.h"
#import <mach/mach.h>

@interface XZQLagMonitor () {
    int timeoutCount;  // 超时次数
    CFRunLoopObserverRef runLoopObserver;  // 观察者
    @public
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runLoopActivity;  // RunLoop运行阶段
}

@property(nonatomic,strong) NSTimer *cpuMonitorTimer;

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
    // 监测CPU消耗
    self.cpuMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateCPUInfo) userInfo:nil repeats:YES];
    // 监测卡顿
    if (runLoopObserver) {
        return;
    }
    dispatchSemaphore = dispatch_semaphore_create(0);  // 保证同步
    // 创建一个观察者
    CFRunLoopObserverContext context = {0, (__bridge void *)self, NULL, NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, &runLoopObserverCallBack, &context);
    // 将观察者添加到主线程runloop的common模式下
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    // 创建子线程监控
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 子线程开启一个持续的loop用来进行监控
        while (YES) {
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore, dispatch_time(DISPATCH_TIME_NOW, 20 * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->runLoopObserver) {
                    self->timeoutCount = 0;
                    self->dispatchSemaphore = 0;
                    self->runLoopActivity = 0;
                    return;
                }
                // BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                if (self->runLoopActivity == kCFRunLoopBeforeSources || self->runLoopActivity == kCFRunLoopAfterWaiting) {
                    // 将堆栈信息上报服务器的代码放到这里
                    NSLog(@"monitor trigger");
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                        
                    });
                } //end activity
            } // end semaphore wait
            self->timeoutCount = 0;
        }
    });
}

- (void)endMonitor {
    // 释放线程
    [self.cpuMonitorTimer invalidate];
    self.cpuMonitorTimer = nil;
    // 释放观察者
    if (!runLoopObserver) {
        return;
    }
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(runLoopObserver);
    runLoopObserver = NULL;
}

#pragma mark - Private

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    XZQLagMonitor *lagMonitor = (__bridge XZQLagMonitor*)info;
    lagMonitor->runLoopActivity = activity;
    dispatch_semaphore_t semaphore = lagMonitor->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

- (void)updateCPUInfo {
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount = 0;
    const task_t thisTask = mach_task_self();
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    if (kr != KERN_SUCCESS) {
        return;
    }
    for (int i = 0; i < threadCount; i++) {
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        if (thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
            threadBaseInfo = (thread_basic_info_t)threadInfo;
            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                integer_t cpuUsage = threadBaseInfo->cpu_usage / 10;
                if (cpuUsage > 70) {  // 这里的70可以根据不同需求设定
                    // cup 消耗大于 70 时打印和记录堆栈 smStackOfThread(threads[i])
                    NSLog(@"CPU useage overload thread stack：\n%@", threadBaseInfo);
                }
            }
        }
    }
}

@end
