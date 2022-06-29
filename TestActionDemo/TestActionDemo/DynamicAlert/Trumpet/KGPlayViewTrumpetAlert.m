//
//  KGPlayViewTrumpetAlert.m
//  DynamicDemo
//
//  Created by rayor on 2022/4/1.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "KGPlayViewTrumpetAlert.h"

#import "KGPlayViewTrumpetMenuView.h"

#import <Masonry/Masonry.h>
#import "UIView+Frame.h"

// 主视图信息
#define pMainViewHeight 240.f
#define pMainLeftRightPadding 18.f
#define pMainBottomPadding 42
#define pPicImageWidth 120

#define ScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define ScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface KGPlayViewTrumpetAlert ()
// 缩小后的位置所在
@property (nonatomic,assign) CGRect shrinkedFrame;

// 正常展示的位置所在
@property (nonatomic,assign) CGRect normalFrame;

// 容器视图
@property (nonatomic, strong) UIView *mainView;

/* 标题栏 */
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong, readwrite) UILabel *subTitleLabel;
/* 左，梦幻紫 */
@property (nonatomic, strong) KGPlayViewTrumpetMenuView *leftView;
/* 右，冰爽蓝 */
@property (nonatomic, strong) KGPlayViewTrumpetMenuView *rightView;

/* 是否正在消失 */
@property (nonatomic,assign) BOOL isDismissing;
/// 0， 梦幻炫紫， 1，清爽冰蓝
@property (nonatomic, assign) BOOL currentType;
@end

@implementation KGPlayViewTrumpetAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        CGFloat y = (ScreenHeight - pMainViewHeight)  - pMainBottomPadding;
        CGFloat x = pMainLeftRightPadding;
        
        CGFloat width = ScreenWidth - 2 * x;
        self.normalFrame = CGRectMake(x , y , width, pMainViewHeight);
        
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    [self addSubview:self.mainView];
    
    [self.mainView addSubview:self.titleLabel];
    [self.mainView addSubview:self.subTitleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(16);
        make.left.mas_equalTo(20);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(10);
    }];
    
    [self.mainView addSubview:self.leftView];
    [self.mainView addSubview:self.rightView];
    
    CGFloat padding = (ScreenWidth - 2*pMainLeftRightPadding - 2 * pPicImageWidth) / 3.0f;
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(17);
        make.width.mas_equalTo(pPicImageWidth);
        make.bottom.mas_equalTo(self.mainView);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftView);
        make.width.mas_equalTo(self.leftView);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(self.leftView);
    }];
    
}

#pragma mark - 显示隐藏动画效果
- (void)showWithShrinkedFrame:(CGRect)shrinkedFrame {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.shrinkedFrame = shrinkedFrame;
    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
    self.mainView.transform = CGAffineTransformMakeScale(0.001f,0.001f);
    self.mainView.center = shrinkedCenter;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.transform = CGAffineTransformIdentity;
        self.mainView.center = normalCenter;
    }];
    
}


- (void)dismiss {
    if (self.isDismissing) {
        return;
    }
    self.isDismissing = YES;
    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
    self.mainView.transform = CGAffineTransformIdentity;
    self.mainView.center = normalCenter;
    NSLog(@"%@",[NSValue valueWithCGPoint:normalCenter]);
    [UIView animateWithDuration:0.25f animations:^{
        self.mainView.transform = CGAffineTransformMakeScale(0.001f,0.001f);
        self.mainView.center = shrinkedCenter;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.isDismissing = NO;
    }];
}


// 点击空白区域需要隐藏
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.mainView.frame, point)) {
        [self dismiss];
    }
}


- (void)updateCurrenTypeState:(NSInteger)type {
    self.currentType = type;
    self.rightView.selected = self.currentType == 1;
    self.leftView.selected = self.currentType == 0;
}
#pragma mark - setter & getter


- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:self.normalFrame];
        _mainView.backgroundColor = [UIColor blackColor];
        _mainView.layer.cornerRadius = 12.0f;
        _mainView.clipsToBounds = NO;
    }
    return _mainView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.text = @"律动模式";
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5f];
        _subTitleLabel.font = [UIFont systemFontOfSize:12.0f];
        _subTitleLabel.text = @"震撼音响效果，不一样的感观体验";
        _subTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _subTitleLabel;
}


- (KGPlayViewTrumpetMenuView *)leftView {
    if (!_leftView) {
        _leftView = [[KGPlayViewTrumpetMenuView alloc] init];
        _leftView.title = @"梦幻炫紫";
        _leftView.picImage = [UIImage imageNamed:@"player_mode_popups_trumpet_purple@3x.jpg"];
        _leftView.didTapViewAction = ^{
#warning lius 注意循环引用
            [self updateCurrenTypeState:0];
        };
    }
    return _leftView;
}

- (KGPlayViewTrumpetMenuView *)rightView {
    if (!_rightView) {
        _rightView = [[KGPlayViewTrumpetMenuView alloc] init];
        _rightView.title = @"清爽冰蓝";
        _rightView.picImage = [UIImage imageNamed:@"player_mode_popups_trumpet_white@3x.jpg"];
        _rightView.didTapViewAction = ^{
#warning lius 注意循环引用
            [self updateCurrenTypeState:1];
        };
    }
    return _rightView;
}


@end
