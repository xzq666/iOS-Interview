//
//  MessagePassController.h
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/24.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TestDelegate <NSObject>

@optional

- (void)testWithParam1:(NSString *)param1 param2:(NSString *)param2;

@end

typedef void (^TestBlock)(NSString *, NSString *);

@interface MessagePassController : UIViewController

@property(nonatomic,weak) id<TestDelegate> delegate;
@property(nonatomic,copy) TestBlock block;

@end

NS_ASSUME_NONNULL_END
