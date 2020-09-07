//
//  AnimationController.m
//  iOS-Interview
//
//  Created by qhzc-iMac-02 on 2020/4/22.
//  Copyright © 2020 Xuzq. All rights reserved.
//

#import "AnimationController.h"

@interface AnimationController ()

@property(nonatomic,strong) CALayer *layer;

@property(nonatomic,strong) UIView *animationView;

@end

@implementation AnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.view.backgroundColor = [UIColor systemBackgroundColor];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
    };
    self.title = @"Animation动画";
    
//    [self implicitAnimation];
//    [self viewAnimation];
    [self layerAnimation];
}

// 核心动画
- (void)layerAnimation {
    self.animationView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 50, 50)];
    self.animationView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.animationView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click)];
    self.animationView.userInteractionEnabled = YES;
    [self.animationView addGestureRecognizer:tap];
}

- (void)click {
    NSLog(@"click");
}

// UIView动画
- (void)viewAnimation {
    self.animationView = [[UIView alloc] initWithFrame:CGRectMake(10, 100, 50, 50)];
    self.animationView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.animationView];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.animationView.frame = CGRectMake(100, 150, 50, 50);
    }];
    
    [UIView animateWithDuration:2.0 animations:^{
        self.animationView.frame = CGRectMake(30, 120, 60, 60);
    } completion:^(BOOL finished) {
        NSLog(@"动画完成 - %@", NSStringFromCGRect(self.animationView.frame));
    }];
    
    [UIView animateWithDuration:1.0 delay:3.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.animationView.frame = CGRectMake(50, 140, 40, 40);
    } completion:^(BOOL finished) {
        NSLog(@"延迟动画完成 - %@", NSStringFromCGRect(self.animationView.frame));
    }];
}

// 隐式动画
- (void)implicitAnimation {
    self.layer = [[CALayer alloc] init];
    self.layer.frame = CGRectMake(10, 100, 100, 100);
    self.layer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.layer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /* 隐式动画
    [CATransaction begin];
    
    // 设置事务是否有动画 YES无动画 NO有动画
    [CATransaction setDisableActions:NO];
    // 设置d事务动画执行时长
    [CATransaction setAnimationDuration:1.0];
    
    self.layer.anchorPoint = CGPointMake(0.0, 0.0);
    self.layer.bounds = CGRectMake(0, 0, arc4random_uniform(200), arc4random_uniform(200));
    self.layer.position = CGPointMake(arc4random_uniform(300), arc4random_uniform(400));
    self.layer.backgroundColor = [self randomColor].CGColor;
    self.layer.cornerRadius = arc4random_uniform(50);
    
    [CATransaction commit];
    
    NSLog(@"position - %@, anchorPoint - %@", NSStringFromCGPoint(self.layer.position), NSStringFromCGPoint(self.layer.anchorPoint)); */
    
    // 核心动画
    /*
    // 基本动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    anim.keyPath = @"position";
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 400)];
    // removedOnCompletion若为YES会恢复到动画前
    anim.removedOnCompletion = NO;
    // 保存动画最前面效果，维持在动画结束后的状态
    anim.fillMode = kCAFillModeForwards;
    [self.animationView.layer addAnimation:anim forKey:nil];
    // 即使保存了动画结束后的状态，UIView的真实位置仍为变化前的
    NSLog(@"frame - %@", NSStringFromCGRect(self.animationView.frame));
    NSLog(@"layer position - %@", NSStringFromCGPoint(self.animationView.layer.position));
    // 虽然可以手动修改，但存在用户交互时我们使用UIView动画
//    self.animationView.frame = CGRectMake(175, 375, 50, 50);
//    self.animationView.layer.position = CGPointMake(200, 400);
     */
    /*
    // 关键帧动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"position";
    UIBezierPath *path = [UIBezierPath bezierPath];
    // point是基于layer的position的
    [path moveToPoint:CGPointMake(140, 125)];
    [path addLineToPoint:CGPointMake(180, 125)];
    anim.path = path.CGPath;
    anim.repeatCount = MAXFLOAT;
    anim.autoreverses = YES;
    anim.duration = 1.0;
    [self.animationView.layer addAnimation:anim forKey:nil];
     */
    // 动画组
    CAAnimationGroup *group = [CAAnimationGroup animation];
    // 缩放
    CABasicAnimation *anim1 = [CABasicAnimation animation];
    anim1.keyPath = @"transform.scale";
    anim1.toValue = @0.5;
    // 平移
    CABasicAnimation *anim2 = [CABasicAnimation animation];
    anim2.keyPath = @"position.y";
    anim2.toValue = @400;
    group.animations = @[anim1, anim2];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    [self.animationView.layer addAnimation:group forKey:nil];
}

- (UIColor *)randomColor {
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
