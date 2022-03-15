//
//  KGPlayViewOptionGuideView.m
//  ContactBookDemo
//
//  Created by rayor on 2022/2/25.
//

#import "KGPlayViewOptionGuideView.h"
#import <Masonry/Masonry.h>

// 高度预算
#define kTrangleHeight 6
#define kTrangleWidth 16
#define kBackViewHeight 44
#define kMainHeight (kTrangleHeight+kBackViewHeight - 1)
#define kMainWidth 190


@interface KGPlayViewOptionGuideView ()
/*主视图*/
@property (nonatomic, strong) UIView *mainView;

/*三角视图*/
@property (nonatomic, strong) UIImageView *trangleView;

/*底视图*/
@property (nonatomic, strong) UIView *backView;

// 容器视图，视为了动画时，区分backView的遮罩慢，这样显示出层叠的效果
@property (nonatomic, strong) UIView *backContentView;

/*图片*/
@property (nonatomic, strong) UIImageView *iconView;

/*名称*/
@property (nonatomic, strong) UILabel *nameLabel;

// 遮罩
@property (nonatomic, strong) UIVisualEffectView *backEffectView;
// 遮罩
@property (nonatomic, strong) UIVisualEffectView *trangleEffectView;


@end

@implementation KGPlayViewOptionGuideView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
//    self.backgroundColor = UIColor.blueColor;
    
    
    [self addSubview:self.mainView];
    
    [self.trangleView addSubview:self.trangleEffectView];
    [self.mainView addSubview:self.trangleView];
    
    [self.mainView addSubview:self.backView];
    [self.backView addSubview:self.backEffectView];
    [self.backView addSubview:self.backContentView];
    
    [self.backContentView addSubview:self.iconView];
    [self.backContentView addSubview:self.nameLabel];
    
    
    // 设置约束，不设置mainView的上部和中间
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainWidth);  // 随着collectionview动态改变
        make.height.mas_equalTo(kMainHeight);
        
        // 这两项随着show进行重新调整
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.trangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mainView);
        make.height.mas_equalTo(kTrangleHeight);
        make.width.mas_equalTo(kTrangleWidth);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMainWidth);    // 此处可以刷新调整
        make.height.mas_equalTo(kBackViewHeight);
        make.top.mas_equalTo(self.trangleView.mas_bottom).mas_offset(-1);
    }];
    
    [self.backContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView);
    }];
    
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.mas_equalTo(self.backView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.backView);
    }];
    
    
    [self.backEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView);
    }];
    
    [self.trangleEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.trangleView);
    }];
    
}


- (void)prepareUIForShowWithTopPoint:(CGPoint)topPoint {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGFloat centerX = topPoint.x - UIScreen.mainScreen.bounds.size.width / 2.f;
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        // 这两项随着show进行重新调整
        make.top.mas_equalTo(topPoint.y + 10);
        make.centerX.mas_equalTo(centerX);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.trangleView.layer.mask = [self trangleViewLayer];
    self.backView.layer.mask = [self roundViewLayer];
    self.backContentView.layer.mask = [self contentRoundViewLayer];
}

#pragma mark - 显示/隐藏

- (void)showWithTopPoint:(CGPoint)topPoint {
    
    [self prepareUIForShowWithTopPoint:topPoint];
    
//    self.mainView.transform = CGAffineTransformMakeTranslation(0, -10);

    CGFloat duration = .5f;
    CGFloat offset = 0.15f;
    
    [self showCombandAnimation:duration topPoint:topPoint];
    [self showTrangleAnimation:duration];
    [self showBackViewAnimation:duration];
    [self showBackContentViewAnimation:duration - offset offset:offset];
    
}


- (void)showCombandAnimation:(CGFloat)duration topPoint:(CGPoint)position {
    CABasicAnimation *translAni = [CABasicAnimation animationWithKeyPath:@"position.y"];
    translAni.fromValue =@(position.y);
    translAni.toValue = @(position.y + 4);
    translAni.duration = duration * 2.4f;       // 1.2s
    translAni.repeatCount = MAXFLOAT;
    translAni.removedOnCompletion = NO;
//    translAni.timingFunction = [self showAnimationFunction];
    translAni.fillMode = kCAFillModeForwards;
    translAni.autoreverses = YES;
    [self.mainView.layer addAnimation:translAni forKey:@"transform"];
}

- (void)showTrangleAnimation:(CGFloat)duration {
    
    CABasicAnimation *trangleAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    trangleAni.fromValue = @(0);
    trangleAni.toValue = @(1);
    trangleAni.duration = duration;
    trangleAni.timingFunction = [self showAnimationFunction];
    trangleAni.removedOnCompletion = NO;
    trangleAni.fillMode = kCAFillModeForwards;
    
    [self.trangleView.layer.mask addAnimation:trangleAni forKey:@"alhpa"];
    
}

- (void)showBackViewAnimation:(CGFloat)duration {
    
    CABasicAnimation *alphaAni = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAni.fromValue = @(0);
    alphaAni.toValue = @(1);
    
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"path"];
    anima.fromValue = (__bridge  id)([self startPath]);
    anima.toValue = (__bridge id)([self endPath]);
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[alphaAni, anima];
    
    group.duration = duration;
    group.timingFunction = [self showAnimationFunction];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    
    [self.backView.layer.mask addAnimation:group forKey:@"mainAnimation"];
}

// 比外层慢一个偏移，目的实现两层展开效果
- (void)showBackContentViewAnimation:(CGFloat)duration offset:(CGFloat)offset {
   
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"path"];
    anima.fromValue = (__bridge  id)([self startPath]);
    anima.toValue = (__bridge id)([self endPath]);
    
    anima.duration = duration;
    anima.beginTime = CACurrentMediaTime() + offset;
    anima.timingFunction = [self showAnimationFunction];
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    
    
    [self.backContentView.layer.mask addAnimation:anima forKey:@"mainContentAnimation"];
}

// 动画执行效果，渐出
- (CAMediaTimingFunction *)showAnimationFunction {
    return [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
}

- (void)hide {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.alpha = 0;
    } completion:^(BOOL finished) {
        self.mainView.alpha = 1;
        [self removeFromSuperview];
    }];
}


#pragma mark - event
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGPoint point = [[touches anyObject] locationInView:self.mainView];
    if (!CGRectContainsPoint(self.mainView.bounds, point)) {
        [self hide];
    }
}


#pragma mark - setter & getter


- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
    }
    return _mainView;
}


- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
    }
    return _backView;
}

- (UIView *)backContentView {
    if (!_backContentView) {
        _backContentView = [[UIView alloc] init];
    }
    return _backContentView;
}

- (UIImageView *)trangleView {
    if (!_trangleView) {
        _trangleView = [[UIImageView alloc] init];
        _trangleView.contentMode = UIViewContentModeScaleAspectFit;
        _trangleView.image = [UIImage imageNamed:@"1"];
        
    }
    return _trangleView;
}


- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_bgmode_ic_guide"]];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"点击可切换背景模式";
        _nameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7f];
        _nameLabel.font = [UIFont systemFontOfSize:14];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}



- (CAShapeLayer *)roundViewLayer {

    CAShapeLayer *roundLayer = [[CAShapeLayer alloc] init];
    roundLayer.path = [self endPath];
    
    return roundLayer;
}


- (CAShapeLayer *)contentRoundViewLayer {
    CAShapeLayer *roundLayer = [[CAShapeLayer alloc] init];
    roundLayer.path = [self startPath];
    
    return roundLayer;
}

- (CALayer *)trangleViewLayer {
    CALayer *maskImageLayer = [[CALayer alloc] init];
    UIImage *maskImage = [UIImage imageNamed:@"player_bgmode_popups_bg_arrow"];
    maskImageLayer.contents = (__bridge  id)maskImage.CGImage;
    maskImageLayer.frame = self.trangleView.bounds;
    return maskImageLayer;
}

- (CGPathRef)startPath {
//        UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.backView.bounds, 50, 0) cornerRadius:kBackViewHeight/2.f];
    UIBezierPath *roundPath = [self roundPathWithRect:CGRectInset(self.backView.bounds, 50, 0) cornerRadius:kBackViewHeight/2.0f];
    return roundPath.CGPath;
}


- (CGPathRef)endPath {
//        UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:self.backView.bounds cornerRadius:kBackViewHeight/2.f];
    
    UIBezierPath *roundPath = [self roundPathWithRect:self.backView.bounds cornerRadius:kBackViewHeight/2.0f];
    
    return roundPath.CGPath;
}


// 绘制贝塞尔曲线，要求是两侧是 圆的
- (UIBezierPath *)roundPathWithRect:(CGRect)rect cornerRadius:(CGFloat)radius {
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGFloat centerY = CGRectGetMidY(rect);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    maskPath.lineWidth = 1.0;
    maskPath.lineCapStyle = kCGLineCapRound;
    maskPath.lineJoinStyle = kCGLineJoinRound;
    
    [maskPath moveToPoint:CGPointMake(x + radius, y)];
    [maskPath addArcWithCenter:CGPointMake(x + radius, centerY) radius:radius startAngle:3*M_PI_2 endAngle:M_PI_2 clockwise:NO];
    [maskPath addLineToPoint:CGPointMake(x + width-radius, y + height)];
    [maskPath addArcWithCenter:CGPointMake(x+width-radius, centerY) radius:radius startAngle:M_PI_2 endAngle:3*M_PI_2 clockwise:NO];
    [maskPath closePath];
    
    return maskPath;
}




- (UIVisualEffectView *)backEffectView {
    if (!_backEffectView) {
        _backEffectView = [self createEffectView];
    }
    return _backEffectView;
}

- (UIVisualEffectView *)trangleEffectView {
    if (!_trangleEffectView) {
        _trangleEffectView = [self createEffectView];
    }
    return _trangleEffectView;
}


// 由于多处使用保持同一个样式
- (UIVisualEffectView *)createEffectView {
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.backgroundColor = [UIColor colorWithWhite:0 alpha:.1f];
//    effectView.alpha = 0.5;
    return effectView;
}

@end
