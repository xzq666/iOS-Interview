//
//  XZQPermenantThread.h
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/7.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XZQTask)(void);

@interface XZQPermenantThread : NSObject

/*
 开启线程
 */
- (void)run;

/*
 执行任务
 */
- (void)executeTask:(XZQTask)task;

/*
 结束线程
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
