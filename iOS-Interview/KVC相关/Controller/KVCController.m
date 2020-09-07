//
//  KVCController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/26.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "KVCController.h"
#import "KVCModel.h"

@interface KVCController ()

@property(nonatomic,strong) KVCModel *model;

@end

@implementation KVCController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"KVC相关";
    
    self.model = [[KVCModel alloc] init];
    [self.model setValue:@"xzq" forKey:@"name"];
    NSLog(@"name: %@", [self.model valueForKey:@"name"]);
    
    // KVC修改属性会触发KVO
    [self.model addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    NSLog(@"%s", object_getClassName(self.model));
    [self.model setValue:@"qlh" forKey:@"name"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"change: %@", change);
}

- (void)dealloc
{
    [self.model removeObserver:self forKeyPath:@"name"];
}

@end
