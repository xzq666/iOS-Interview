//
//  XZQView.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/21.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQView.h"

@implementation XZQView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (!self.isUserInteractionEnabled || self.isHidden || self.alpha <= 0.01) {
        return nil;
    }
    // 正常情况下子视图会判断点击是否在父视图的Bounds内，若不在则不会响应事件
    // 将此判断注释，就不会管是否在父视图的Bounds中了
//    if ([self pointInside:point withEvent:event]) {
        for (UIView *subview in [self.subviews reverseObjectEnumerator]) {
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hitTestView = [subview hitTest:convertedPoint withEvent:event];
            if (hitTestView) {
                return hitTestView;
            }
        }
        return self;
//    }
//    return nil;
}

@end
