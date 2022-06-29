//
//  RippleAnimationView.m
//  DemoTest
//
//  Created by rayor on 2020/8/25.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "RippleAnimationView.h"

#define ColorWithAlpha(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
// 设置静态常量 脉冲数量，表示 Layer 的数量
static NSInteger const pulsingCount = 3;

// 设置静态常量 animationDuration ，表示动画时间
static double const animationDuration = 3;

@interface RippleAnimationView ()
@end



@implementation RippleAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _enlargeRate = 1.432f;

        _pulsBubbleColors =  @[(__bridge id)[UIColor colorWithWhite:1 alpha:0.15].CGColor,
                               (__bridge id)[UIColor colorWithWhite:1 alpha:0].CGColor];
        [self configMaskLayer];
       
    }
    return self;
}

- (void)configMaskLayer {
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, height/2.0f) radius:height/2.0f*_enlargeRate*2 startAngle:0 endAngle:2*M_PI clockwise:YES]];
    [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f,height/2.0f) radius:height/2.0f startAngle:0 endAngle:2*M_PI clockwise:YES].bezierPathByReversingPath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    self.layer.mask = layer;
}


- (void)drawRect:(CGRect)rect {
    CALayer *animationLayer = [CALayer layer];
    // 利用 for 循环创建三个动画 Layer
    for (int i = 0; i < pulsingCount; i++) {
        NSArray *animationArray = [self animationArray];
        // 通过传入参数 i 计算，错开动画时间
        CAAnimationGroup *animationGroup = [self animationGroupAnimations:animationArray index:i];
        CALayer *pulsingLayer = [self pulsingLayer:rect animation:animationGroup];
        [animationLayer addSublayer:pulsingLayer];
    }
    
    [self.layer insertSublayer:animationLayer atIndex:0];
}



- (NSArray *)animationArray {
    
    NSArray *animationArray = nil;
    
    CABasicAnimation *scaleAnimation = [self scaleAnimation];
    CAKeyframeAnimation *backgroundColorAnimation = [self backgroundColorAnimation];
    
    animationArray = @[scaleAnimation, backgroundColorAnimation];
    return animationArray;
}

- (CAAnimationGroup *)animationGroupAnimations:(NSArray *)array index:(int)index {
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.beginTime = CACurrentMediaTime() + (double)(index * animationDuration) / (double)pulsingCount;
    animationGroup.duration = animationDuration;
    animationGroup.repeatCount = HUGE;
    animationGroup.animations = array;
    animationGroup.removedOnCompletion = NO;
    animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    return animationGroup;
}


- (CABasicAnimation *)scaleAnimation {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @1;
    scaleAnimation.toValue = @(_enlargeRate);
    return scaleAnimation;
}

// 使用关键帧动画，使得颜色动画不要那么的线性变化
- (CAKeyframeAnimation *)backgroundColorAnimation {
    
    CAKeyframeAnimation *backgroundColorAnimation = [CAKeyframeAnimation animation];
    backgroundColorAnimation.keyPath = @"backgroundColor";
    backgroundColorAnimation.values = self.pulsBubbleColors;
    backgroundColorAnimation.keyTimes = @[@0.6,@1];
    
    return backgroundColorAnimation;
    
}


- (CALayer *)pulsingLayer:(CGRect)rect animation:(CAAnimationGroup *)animationGroup {
    
    CALayer *pulsingLayer = [CALayer layer];
    pulsingLayer.borderWidth = 0.5;
    pulsingLayer.borderColor = UIColor.clearColor.CGColor;
    pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    pulsingLayer.cornerRadius = rect.size.height / 2;
    [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
    
    return pulsingLayer;
}


#pragma mark - 配置信息
- (void)setPulsBubbleColors:(NSArray *)pulsBubbleColors {
    _pulsBubbleColors = pulsBubbleColors;
    [self setNeedsDisplay];
}

- (void)setenlargeRate:(CGFloat)enlargeRate {
    _enlargeRate = enlargeRate;
    [self configMaskLayer];
}


#pragma mark - hittest

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (CGRectContainsPoint(self.bounds, point)) {   // 如果点击了中间区域直接透传过去，其他自己处理
        return nil;
    }
    return [super hitTest:point withEvent:event];
}
@end

