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
    self.view.backgroundColor = [UIColor systemBackgroundColor];
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
    [self barrierTest];
    
    // 其内部使用的是 dispatch_time_t 管理时间，而不是 NSTimer，所以不用关心RunLoop是否开启
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"执行");
//    });
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

- (void)dealloc
{
    pthread_mutex_destroy(&_mutexLock);
    pthread_rwlock_destroy(&_rwlock);
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
