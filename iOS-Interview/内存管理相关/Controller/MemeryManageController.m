//
//  MemeryManageController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/12.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MemeryManageController.h"
#import "CopyModel.h"
#import "XZQProxy.h"
#import "XZQProxy2.h"

@interface MemeryManageController ()

@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) CADisplayLink *link;

@end

@implementation MemeryManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"内存管理相关";
    
//    [self copyingTest];
//    [self NSTimerTest];
//    [self CADisplayLinkTest];
    
    [self taggedPointerTest];
}

extern uintptr_t objc_debug_taggedpointer_obfuscator;
uintptr_t _objc_decodeTaggedPointer(id ptr) {
    return (uintptr_t)ptr ^ objc_debug_taggedpointer_obfuscator;
}

- (void)taggedPointerTest {
    NSNumber *number1 = @1;
    NSNumber *number2 = @3;
    NSNumber *number3 = @12;
    
    NSLog(@"number1: %@, %lx", number1, _objc_decodeTaggedPointer(number1));
    NSLog(@"number2: %@, %lx", number2, _objc_decodeTaggedPointer(number2));
    NSLog(@"number3: %@, %lx", number3, _objc_decodeTaggedPointer(number3));
}

- (void)copyingTest {
    CopyModel *model1 = [[CopyModel alloc] init];
    model1.age = 20;
    model1.name = @"xzq";
    NSLog(@"model1 age:%d", model1.age);
    NSLog(@"model1 name:%@", model1.name);
    
    // 若CopyModel没有实现NSCopying协议，调用copy方法程序会crash
    CopyModel *model2 = [model1 copy];
    NSLog(@"model2 age:%d", model2.age);
    NSLog(@"model2 name:%@", model2.name);
}

- (void)NSTimerTest {
    __weak typeof(self) weakSelf = self;
//    // NSTimer对target产生强引用，target又对NSTimer产生强引用，会引发循环引用，导致控制器无法释放，NSTimer也无法释放
//    // weakSelf只有在block内部才是弱引用，是由block底层特性决定的，这里target传的只是一个参数，本质只是一个内存地址，故使用weakSelf是无法解决循环引用的问题的
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(test) userInfo:nil repeats:YES];
    
    // 方法一：使用block，在block内部使用weak指针可以打破循环引用条件
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        [weakSelf test];
//    }];
    
    // 方法二：引入代理来成为target，通过代理来打破循环引用，将代理内部的实际target设置成弱引用，再应用Runtime消息机制来转发要调用的方法
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[XZQProxy initWithTarget:self] selector:@selector(test) userInfo:nil repeats:YES];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:[XZQProxy2 initWithtarget:self] selector:@selector(test) userInfo:nil repeats:YES];
}

- (void)CADisplayLinkTest {
//    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(test)];
    self.link = [CADisplayLink displayLinkWithTarget:[XZQProxy2 initWithtarget:self] selector:@selector(test)];
    [self.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)test {
    NSLog(@"test");
}

- (void)dealloc
{
    [self.timer invalidate];
    [self.link invalidate];
}

@end
