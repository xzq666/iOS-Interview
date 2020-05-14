//
//  MVVMView.h
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MVVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVVMView : UIView

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UILabel *label;

@property(nonatomic,weak) MVVMViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
