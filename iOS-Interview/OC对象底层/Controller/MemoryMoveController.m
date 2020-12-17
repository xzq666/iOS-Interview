//
//  MemoryMoveController.m
//  iOS-Interview 内存平移
//
//  Created by qhzc-iMac-02 on 2020/12/17.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MemoryMoveController.h"

@interface XZQClass : NSObject
@property(nonatomic,copy) NSString *name;
- (void)sayHello;
@end
@implementation XZQClass
- (void)sayHello { NSLog(@"%s: 你好 - %@", __func__, self.name); }
@end

@interface MemoryMoveController ()

@end

@implementation MemoryMoveController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"内存平移";
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    
    // 指针读取类地址，强转为对象，调用方法
    Class cls = [XZQClass class];
    // &cls只是和isa一样指向了XZQClass。并不是真正的isa
    void *ht = &cls;
    // 之所以这里name属性会打印出MemoryMoveController是因为发生了越界读取
//    [(__bridge id)ht setName:@"666"];  // 调用set方法运行时是会报错的
    [(__bridge id)ht sayHello];
    
    // 实例化对象，调用方法
    XZQClass *xzq = [[XZQClass alloc] init];
    xzq.name = @"xzq";
    [xzq sayHello];
}

@end
