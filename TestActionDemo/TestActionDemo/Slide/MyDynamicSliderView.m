
//
//  MyDynamicSliderView.m
//  DynamicDemo
//
//  Created by rayor on 2020/10/22.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "MyDynamicSliderView.h"
#import <Masonry/Masonry.h>

@interface MyDynamicSliderView ()
// 锚点信息
@property (nonatomic, strong) NSArray *anchors;

@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSArray *textLabels;

@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

// 当前选中的索引
@property (nonatomic, assign) NSInteger currentIndex;

/* 最大值 */
@property (nonatomic, assign) NSInteger maxValue;

@property (nonatomic, strong) UIView *thumbView;

@property (nonatomic, assign) CGPoint startPoint;

@property (nonatomic, assign) CGAffineTransform startTransform;
@end

@implementation MyDynamicSliderView

- (instancetype)initWithFrame:(CGRect)frame anchors:(NSArray *)anchors {
    if (self = [super initWithFrame:frame]) {
        _anchors = anchors;
        [self createSubViews];
        self.maxValue = _anchors.count > 1 ? anchors.count - 1 : 1;
    }
    return self;
}


- (void)createSubViews {
    // 创建一个slideView
    [self addSubview:self.sliderView];
    [self addSubview:self.thumbView];
    
    [self.sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(14);
        make.top.mas_equalTo(25);
    }];
    
    [self.thumbView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.sliderView.mas_left);
        make.centerY.mas_equalTo(self.sliderView);
        make.width.height.mas_equalTo(18);
    }];
    
    [self createLabels];
    [self createMarkLines];
    
}


- (void)createLabels {
    NSMutableArray *tmpArr = @[].mutableCopy;
    // 创建label信息
    if (_anchors.count == 1) {
        return;
    }
    
    CGFloat percent = 1.0f / (self.anchors.count-1);
    for (int i = 0; i < self.anchors.count; i++) {
        UILabel *label = [UILabel new];
        label.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        label.font = [UIFont systemFontOfSize:10];
        label.tag = i;
        label.text = self.anchors[i];
        [tmpArr addObject:label];
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.mas_equalTo(0);
            } else if (i == self.anchors.count - 1) {   // 最后一个
                make.right.mas_equalTo(0);
            } else {    // 其他
                make.centerX.mas_equalTo(self.sliderView.mas_right).multipliedBy(i * percent);
            }
            make.top.mas_equalTo(self.sliderView.mas_bottom).offset(5);
        }];
        
    }
    
    self.textLabels = tmpArr;
}

- (void)createMarkLines {
    // 配置滑动条上黑点的位置信息，黑点数量为奇数个，偶数个，黑条位置不一样
    NSInteger count = self.anchors.count - 1;
    BOOL isEven = count % 2 == 0;
    CGFloat blackPercent = isEven ? 1.0f / (count+1) : .5f / count;
    
    for (int i = 0; i < count; i++) {
        UIView *tmpView = [[UIView alloc] init];
        tmpView.backgroundColor = [UIColor blackColor];
        
        [self.sliderView insertSubview:tmpView atIndex:1];
        
        [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (isEven) {
                make.centerX.mas_equalTo(self.sliderView.mas_right).multipliedBy(blackPercent*(i+1));
            } else {
                make.centerX.mas_equalTo(self.sliderView.mas_right).multipliedBy(blackPercent * (i * 2 + 1));
            }
            make.height.mas_equalTo(4);
            make.centerY.mas_equalTo(self.sliderView);
            make.width.mas_equalTo(1);
        }];
    }
}

#pragma mark - 事件处理

- (void)didTapSlideView:(UITapGestureRecognizer *)tap {
    CGPoint touchPoint = [tap locationInView:self.sliderView];
    
    [self updateCurrentSlidOffsetX:touchPoint.x];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGFloat tranX = self.thumbView.transform.tx;
    CGFloat halfThumbWidth = self.thumbView.bounds.size.width / 2.0f;
    if (tranX < halfThumbWidth) {
        tranX = halfThumbWidth;
    } else if (tranX > self.sliderView.bounds.size.width - halfThumbWidth) {
        tranX = self.sliderView.bounds.size.width - halfThumbWidth;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.startPoint = [pan locationInView:self];
            self.startTransform = self.thumbView.transform;
        }
            break;
            case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [pan locationInView:self];
            
            CGFloat movx = point.x - self.startPoint.x;
            
            // 限制最左最右可以滑动的范围
            if (movx > 0) {     // 向右滑动
                CGFloat maxX = self.sliderView.bounds.size.width - halfThumbWidth - self.startTransform.tx;
                if (movx > maxX) {
                    movx = maxX;
                }
            }
            
            if (movx < 0) {     // 向左滑动
                CGFloat minX = halfThumbWidth - self.startTransform.tx;
                if (movx < minX) {
                    movx = minX;
                }
            }
            
            self.thumbView.transform = CGAffineTransformTranslate(self.startTransform, movx , 0);
            NSLog(@"thumbview: %@",self.thumbView);
        }
            break;
            case UIGestureRecognizerStateEnded:
            case UIGestureRecognizerStateCancelled:
            case UIGestureRecognizerStateFailed:
        {
            self.startPoint = CGPointZero;
            [self updateCurrentSlidOffsetX:self.thumbView.transform.tx];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)updateCurrentSlidOffsetX:(CGFloat)offsetX {
    CGFloat value = self.maxValue * (offsetX / self.sliderView.frame.size.width);
    [self updateSlideValue:value];
}

- (void)updateSlideValue:(CGFloat)value {
    
    NSInteger formatValue = round(value);
    
    [self updateTextLabelWithSelectIndex:formatValue];
    if (self.currentIndex == formatValue) {
        return;
    }
    self.currentIndex = formatValue;
    !self.selectIndexBlock ?: self.selectIndexBlock(formatValue);
}


- (void)updateTextLabelWithSelectIndex:(NSInteger)index {
    for (UILabel *label in self.textLabels) {
        BOOL isSelected = label.tag == index;
        label.textColor = isSelected ? UIColor.redColor : [UIColor colorWithWhite:1 alpha:0.5];
    }
    
    CGFloat percentWidth = self.sliderView.bounds.size.width / (self.maxValue);
    
    CGFloat value = percentWidth * index;
    if (index == 0) {
        value += self.thumbView.bounds.size.width / 2.0f;
    } else if (index == self.maxValue) {
        value -= self.thumbView.bounds.size.width / 2.0f;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.thumbView.transform = CGAffineTransformMakeTranslation(value, 0);
    }];
}

#pragma mark - 视图更新
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.gradientLayer.frame = CGRectMake(0, 5, self.sliderView.bounds.size.width, 4);
    
    [self updateTextLabelWithSelectIndex:_currentIndex];
}


#pragma mark - setter & getter

- (UIView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[UIView alloc] init];
        [_sliderView.layer insertSublayer:self.gradientLayer atIndex:0];
        [_sliderView addGestureRecognizer:self.tapGesture];
    }
    return _sliderView;
}


- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                                  (__bridge id)[UIColor yellowColor].CGColor,
                                  (__bridge id)[UIColor blueColor].CGColor];
        _gradientLayer.locations = @[@0,@0.5,@1];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.masksToBounds = YES;
        _gradientLayer.cornerRadius = 2.0f;
    }
    return _gradientLayer;
}

- (UIView *)thumbView {
    if (!_thumbView) {
        _thumbView = [[UIView alloc] init];
        _thumbView.backgroundColor = [UIColor whiteColor];
        _thumbView.layer.cornerRadius = 9;
        [_thumbView.layer masksToBounds];
        [_thumbView addGestureRecognizer:self.panGesture];
    }
    return _thumbView;
}

- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSlideView:)];
    }
    return _tapGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    }
    return _panGesture;
}

@end
