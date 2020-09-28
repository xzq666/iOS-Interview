//
//  XZQLagMonitor.h
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/7/13.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQLagMonitor : NSObject

+ (instancetype)sharedInstance;

- (void)beginMoitor;  // 开始监视卡顿
- (void)endMonitor;  // 停止监视卡顿

- (void)printLogTrace;  // 打印卡顿堆栈

@end

NS_ASSUME_NONNULL_END
