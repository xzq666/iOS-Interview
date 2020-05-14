//
//  MVCChangeView.h
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVCChangeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVCChangeView : UIView

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *label;

- (void)setViewWithModel:(MVCChangeModel *)model;

@end

NS_ASSUME_NONNULL_END
