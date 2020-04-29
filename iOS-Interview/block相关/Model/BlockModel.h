//
//  BlockModel.h
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/29.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlockModel : NSObject

@property(nonatomic,assign) NSInteger age;
@property(nonatomic,copy) NSInteger(^block)(NSInteger);

@end

NS_ASSUME_NONNULL_END
