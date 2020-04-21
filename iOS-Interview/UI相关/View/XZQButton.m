//
//  XZQButton.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

/**
 扩大UIButton的响应热区
 */

#import "XZQButton.h"

@interface XZQButton ()

@property(nonatomic,assign) CGFloat minimumHitWidth;
@property(nonatomic,assign) CGFloat minimumHitHeight;

@end

@implementation XZQButton

- (instancetype)initWithFrame:(CGRect)frame minimumHitWidth:(CGFloat)minimumHitWidth minimumHitHeight:(CGFloat)minimumHitHeight
{
    self = [super initWithFrame:frame];
    if (self) {
        self.minimumHitWidth = minimumHitWidth;
        self.minimumHitHeight = minimumHitHeight;
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGRectContainsPoint(HitTestingBounds(self.bounds, self.minimumHitWidth, self.minimumHitHeight), point);
}

CGRect HitTestingBounds(CGRect bounds, CGFloat minimumHitTestWidth, CGFloat minimumHitTestHeight) {
    CGRect hitTestingBounds = bounds;
    if (minimumHitTestWidth > bounds.size.width) {
        hitTestingBounds.size.width = minimumHitTestWidth;
        hitTestingBounds.origin.x -= (hitTestingBounds.size.width - bounds.size.width) / 2;
    }
    if (minimumHitTestHeight > bounds.size.height) {
        hitTestingBounds.size.height = minimumHitTestHeight;
        hitTestingBounds.origin.y -= (hitTestingBounds.size.height - bounds.size.height) / 2;
    }
    return hitTestingBounds;
}

@end
