//
//  MultiThreadController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/9.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MultiThreadController.h"
#import <os/lock.h>
#import <pthread.h>

static int gcdIdx = 0;

@interface MultiThreadController ()

@property(nonatomic,assign) NSInteger count;

// os_unfair_lock
@property(nonatomic,assign) os_unfair_lock osUnFairLock;
// pthread_mutex
@property(nonatomic,assign) pthread_mutex_t mutexLock;

// pthread_rwlock
@property(nonatomic,assign) pthread_rwlock_t rwlock;

@end

@implementation MultiThreadController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"多线程相关";
    
    self.count = 0;
//    [self semaphoreAppliacation1];
//    [self semaphoreAppliacation2];
    
    // os_unfair_lock
//    self.osUnFairLock = OS_UNFAIR_LOCK_INIT;
//    [self osUnfairLockTest];
    
    // pthread_mutex普通锁
//    pthread_mutexattr_t attr;
//    pthread_mutexattr_init(&attr);
//    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_DEFAULT);  // 当为PTHREAD_MUTEX_RECURSIVE时是pthread_mutex递归锁，允许同一线程加多把锁
//    pthread_mutex_init(&_mutexLock, &attr);
//    pthread_mutexattr_destroy(&attr);
//    [self pthreadMutexLock];
    
    // 使用读写锁rwlock实现多读单写
//    pthread_rwlock_init(&_rwlock, NULL);
//    [self pthreadRwLockTest];
    
    // 使用GCD栅栏函数实现多读单写
//    [self barrierTest];
    
    // 其内部使用的是 dispatch_time_t 管理时间，而不是 NSTimer，所以不用关心RunLoop是否开启
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"执行");
//    });
    
    NSLog(@"开始任务");
    // 创建定时器对象
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    // 设置定时器
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC, 0.0 * NSEC_PER_SEC);
    // 设置定时器任务
    gcdIdx = 0;
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"执行一次");
//        NSLog(@"GCD Method: %d", gcdIdx++);
//        NSLog(@"%@", [NSThread currentThread]);
//
//        if(gcdIdx == 5) {
//            // 终止定时器
//            NSLog(@"结束任务");
//            dispatch_suspend(timer);
//        }
        if (gcdIdx == 5) {
            dispatch_suspend(timer);
        }
    });
    // 启动任务
    dispatch_resume(timer);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"stop" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(stop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)stop {
    NSLog(@"停止");
    gcdIdx = 5;
}

- (void)dealloc
{
    gcdIdx = 5;
    pthread_mutex_destroy(&_mutexLock);
    pthread_rwlock_destroy(&_rwlock);
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

// semaphore保持线程同步（将异步执行任务转换为同步执行任务）
- (void)semaphoreAppliacation1 {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block NSInteger number = 0;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        number = 100;
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"number is %zd", number);
}

// semaphore为线程加锁，保证线程安全
- (void)semaphoreAppliacation2 {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            self.count++;
            sleep(1);
            NSLog(@"执行任务%zd", self.count);
            dispatch_semaphore_signal(semaphore);
        });
    }
}

// os_unfair_lock
- (void)osUnfairLockTest {
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 加锁
            os_unfair_lock_lock(&self->_osUnFairLock);
            self.count++;
            sleep(1);
            NSLog(@"执行任务%zd", self.count);
            // 解锁
            os_unfair_lock_unlock(&self->_osUnFairLock);
        });
    }
}

// pthread_mutex普通锁
- (void)pthreadMutexLock {
    for (int i = 0; i < 10; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 加锁
            pthread_mutex_lock(&self->_mutexLock);
            self.count++;
            sleep(1);
            NSLog(@"执行任务%zd", self.count);
            // 解锁
            pthread_mutex_unlock(&self->_mutexLock);
        });
    }
}

// 使用读写锁rwlock实现多读单写
- (void)pthreadRwLockTest {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            [self read];
        });
    }
    for (int i = 0; i < 5; i++) {
        dispatch_async(queue, ^{
            [self write];
        });
    }
}

- (void)read {
    pthread_rwlock_rdlock(&_rwlock);
    sleep(1);
    NSLog(@"%s - %@", __func__, [NSThread currentThread]);
    pthread_rwlock_unlock(&_rwlock);
}

- (void)write {
    pthread_rwlock_wrlock(&_rwlock);
    sleep(1);
    NSLog(@"%s - %@", __func__, [NSThread currentThread]);
    pthread_rwlock_unlock(&_rwlock);
}

// 使用GCD栅栏函数实现多读单写
- (void)barrierTest {
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < 10; i++) {
        dispatch_async(queue, ^{
            sleep(1);
            NSLog(@"read - %@", [NSThread currentThread]);
        });
    }
    for (int i = 0; i < 5; i++) {
        dispatch_barrier_async(queue, ^{
            sleep(1);
            NSLog(@"write - %@", [NSThread currentThread]);
        });
    }
}

@end
