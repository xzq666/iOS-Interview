//
//  KVOController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/26.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "KVOController.h"

@interface KVOController ()

@property(nonatomic,copy) NSString *name;

@end

@implementation KVOController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"KVO相关";
    
    NSLog(@"添加KVO前-->%s", object_getClassName(self));  // KVOController
    [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    NSLog(@"添加KVO后-->%s", object_getClassName(self));  // NSKVONotifying_KVOController
    
    self.name = @"123";
    self.name = @"456";
}
          
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"change: %@", change);
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"name"];
}

@end
