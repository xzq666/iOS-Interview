//
//  XZQProxy2.h
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/12.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQProxy2 : NSObject

@property(nonatomic,weak) id target;

+ (id)initWithtarget:(id)target;

@end

NS_ASSUME_NONNULL_END
