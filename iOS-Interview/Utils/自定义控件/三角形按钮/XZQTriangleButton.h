//
//  XZQTriangleButton.h
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/11/19.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XZQTriangleButton : UIView

@property(nonatomic, copy) void(^buttonClick)(void);

@end

NS_ASSUME_NONNULL_END
