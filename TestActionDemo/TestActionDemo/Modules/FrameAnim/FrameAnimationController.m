//
//  FrameAnimationController.m
//  TestActionDemo
//
//  Created by rayor on 2020/9/4.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "FrameAnimationController.h"

@interface FrameAnimationController () <CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mybutton;
@property (weak, nonatomic) IBOutlet UIImageView *picView;

@end

@implementation FrameAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.picView.layer.cornerRadius = 10;
    [self.picView.layer masksToBounds];
}

- (IBAction)didClickAction:(id)sender {
    
    // 需要做形变处理
    [self addScaleAnimation];
}


- (void)addScaleAnimation {
    
    [self.picView.layer removeAnimationForKey:@"transform"];
    
    CGFloat scale = 0.8;
    CGFloat duration = 5;
    
    CAKeyframeAnimation *ani = [CAKeyframeAnimation animation];
    ani.keyPath = @"transform";
    ani.duration = duration;
    
    CGFloat frameTimeRate = 0.678f / duration;
    
    // 原型
    NSValue *trans = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    // 缩小
    NSValue *trans1 = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, 1)];
    
    // 旋转
    CATransform3D tmp = CATransform3DRotate(CATransform3DMakeScale(scale, scale, 1), M_PI, 0, 1, 0);
    tmp.m34 = 1.0 / 1000.0f;
    NSValue *trans2 = [NSValue valueWithCATransform3D:tmp];
    
    // 保持旋转状态放大
    NSValue *trans3 = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(M_PI, 0, 1, 0), 1, 1, 1)];
    
    // 后续要保持一段时间，所以需要再次设置trans3
    
    // 回置操作
    // 等待一段时间后缩小
    NSValue *trans4 = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DMakeRotation(M_PI, 0, 1, 0), scale, scale, 1)];
    
    
    // 逆向翻转回去
    CATransform3D tmp1 = CATransform3DRotate(CATransform3DMakeScale(scale, scale, 1), 0, 0, 1, 0);
    tmp1.m34 = -1.0 / 1000.0f;
    NSValue *trans5 = [NSValue valueWithCATransform3D:tmp1];
    
    // 回复原型，使用原型trans即可
    
    
    NSArray *values = @[trans, trans1, trans2, trans3,trans3, trans4, trans5,trans];
    ani.cumulative = NO;
    ani.values = values;
    ani.fillMode = kCAFillModeForwards;
    ani.keyTimes = @[@0,@(frameTimeRate),@(frameTimeRate*2),@(3*frameTimeRate),@(1-3*frameTimeRate),@(1-2*frameTimeRate),@(1-frameTimeRate),@1];
    
    [self.picView.layer addAnimation:ani forKey:@"transform"];
    
}

static bool animationPause = NO;

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches
              withEvent:event];
    animationPause = !animationPause;
    if (animationPause) {
        [self pauseLayer:self.picView.layer];
    } else {
        [self resumeLayer:self.picView.layer];
    }
}

- (void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

//继续layer上面的动画
- (void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = timeSincePause;
}
@end
