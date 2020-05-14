//
//  MVPView.h
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVPModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVPView : UIView

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *label;

- (void)setViewWithModel:(MVPModel *)model;

@end

NS_ASSUME_NONNULL_END
