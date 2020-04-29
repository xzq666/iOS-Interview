//
//  BlockController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/28.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "BlockController.h"
#import "BlockModel.h"

@interface BlockController ()

@end

@implementation BlockController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"block相关";
    
    [self blockCatchVariable];
}

- (void)blockTest {
    NSInteger (^testBlock)(NSInteger) = ^NSInteger(NSInteger n) {
        return n * n;
    };
    NSLog(@"%zd", testBlock(5));
}

NSInteger k1 = 100;
static NSInteger k2 = 200;
NSMutableArray *k3;

// block变量截获
- (void)blockCatchVariable {
    // 局部auto变量截获是 值截获
    NSInteger num = 3;
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
    NSInteger (^block1)(NSInteger) = ^NSInteger(NSInteger n) {
//        num = 4;  // block里修改局部变量编译会报错
        [arr addObject:@"3"];
        NSLog(@"%@", arr);
        return num * n;
    };
    num = 4;  // block对局部变量是值截获，因此修改不影响内部调用
    [arr addObject:@"4"]; // 局部对象变量调用方法会影响block内部对局部对象变量的使用
    arr = nil;  // 在外部将局部对象变量置为nil对block内部调用是没有影响的
    NSLog(@"%zd", block1(2));
    
    // 局部静态变量截获是 指针截获
    static NSInteger m = 3;
    NSInteger (^block2)(NSInteger) = ^NSInteger(NSInteger n) {
        return m * n;
    };
    m = 4;  // block对局部静态变量是指针捕获，外部修改会对block内部产生影响
    NSLog(@"%zd", block2(2));
    
    // 全局变量，无论是静态全局变量还是auto全局变量都不截获，直接取值
    k3 = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
    NSInteger (^block3)(NSInteger) = ^NSInteger(NSInteger n) {
        [k3 addObject:@"3"];
        NSLog(@"%@", k3);
        return (k1 + k2) * n;
    };
    k1 = 150;
    k2 = 250;  // block对全局变量不捕获直接用，外部修改会对block内部产生影响
    [k3 addObject:@"4"];
    k3 = nil;  // 在外部将全局对象变量置为nil对block内部调用会产生影响
    NSLog(@"%zd", block3(2));
    
    __block NSInteger p1 = 2;
    __block NSInteger p2 = 2;
    __block NSMutableArray *p3 = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
    NSInteger (^block4)(NSInteger) = ^NSInteger(NSInteger n) {
        p1 = 3;  // 被__block修饰的局部变量在block内部可以修改
        NSLog(@"%@", p3);
        return (p1 + p2) * n;
    };
    p2 = 6;  // 被__block修饰的局部变量在block外部修改会影响block内部
    p3 = nil;
    NSLog(@"%zd", block4(2));
    
    NSLog(@"%@", [block1 class]);
    NSLog(@"%@", [block2 class]);
    NSLog(@"%@", [block3 class]);
    NSLog(@"%@", [block4 class]);

    BlockModel *model = [[BlockModel alloc] init];
    model.age = 25;
    __weak typeof(model) weakModel = model;
    model.block = ^NSInteger(NSInteger n) {
        NSLog(@"before age: %zd", weakModel.age);
        return model.age + n;
    };
    NSLog(@"%zd", model.block(2));
}

@end
