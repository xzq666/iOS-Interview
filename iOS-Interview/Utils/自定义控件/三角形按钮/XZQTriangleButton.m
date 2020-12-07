//
//  XZQTriangleButton.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/11/19.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "XZQTriangleButton.h"

@interface XZQTriangleButton ()

@property(nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation XZQTriangleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.shapeLayer = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 100, 0);
    CGPathAddLineToPoint(path, nil, 100, 100);
    CGPathAddLineToPoint(path, nil,0, 100);
    self.shapeLayer.path = path;
    CGPathRelease(path);
    [self.layer setMask:self.shapeLayer];
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor redColor];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick)];
    [self addGestureRecognizer:tap];
}

- (void)btnClick {
    if (self.buttonClick) {
        self.buttonClick();
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGPathContainsPoint(self.shapeLayer.path, nil, point, YES)) {
        NSLog(@"1");
        return [super pointInside:point withEvent:event];
    } else {
        NSLog(@"2");
        return false;
    }
}

@end
