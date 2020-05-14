//
//  MVPView.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/5/14.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "MVPView.h"

@implementation MVPView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        [self addSubview:imageView];
        _imageView = imageView;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 100, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        _label = label;
    }
    return self;
}

- (void)setViewWithModel:(MVPModel *)model {
    self.imageView.image = [UIImage imageNamed:model.iconUrl];
    self.label.text = model.name;
}

@end
