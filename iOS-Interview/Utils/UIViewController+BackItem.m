//
//  UIViewController+BackItem.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/27.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "UIViewController+BackItem.h"
#import <objc/runtime.h>

@implementation UIViewController (BackItem)

+ (void)load
{
    Method oldMethod = class_getInstanceMethod([self class], @selector(viewDidLoad));
    Method newMethod = class_getInstanceMethod([self class], @selector(viewDidLoadNew));
    method_exchangeImplementations(oldMethod, newMethod);
}

- (void)viewDidLoadNew {
    [self viewDidLoadNew];  // 因为经过了方法交换，这个方法实际上是原来的viewDidLoad
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
}

@end
