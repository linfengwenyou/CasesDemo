//
//  KGLyricEffectIntroduceAlert.m
//  DynamicDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "KGLyricEffectIntroduceAlert.h"
#import <Masonry/Masonry.h>
#import "KGLyricEffectIntroduceMenu.h"
#import "UIView+Frame.h"

// 主视图信息
#define pMainViewHeight kgADW(372.0f)
#define pMainViewWidth kgADW(265.0f)


@interface KGLyricEffectIntroduceAlert ()

// 缩小后的位置所在
@property (nonatomic,assign) CGRect shrinkedFrame;

// 正常展示的位置所在
@property (nonatomic,assign) CGRect normalFrame;

// 容器视图
@property (nonatomic, strong) UIView *mainView;

@property (nonatomic, strong) UIImageView *backImageView;

/* 左，歌手写真 */
@property (nonatomic, strong) KGLyricEffectIntroduceMenu *leftView;
/* 右，动感写真 */
@property (nonatomic, strong) KGLyricEffectIntroduceMenu *rightView;

@property (nonatomic, strong) UIButton *ensureButton;

/* 当前类型 */
@property (nonatomic,assign) KGLyricEffectType currentType;

/* 是否正在消失 */
@property (nonatomic,assign) BOOL isDismissing;

@end

@implementation KGLyricEffectIntroduceAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        CGFloat y = ([UIScreen mainScreen].bounds.size.height - pMainViewHeight) / 2.0f;
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - pMainViewWidth) / 2.0f;
        
        self.normalFrame = CGRectMake(x , y , pMainViewWidth, pMainViewHeight);
        
        
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    [self addSubview:self.mainView];
    
    // 关闭按钮无用，点击只要是非弹窗区域全部隐藏，关闭按钮只是个样式
    UIImageView *closeImag = [[UIImageView alloc] init];
    closeImag.image = [UIImage imageNamed:@"lyric_effect_alert_close"];
    [self.mainView addSubview:closeImag];
    [closeImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mainView.mas_bottom).mas_offset(kgADW(25));
        make.centerX.mas_equalTo(self.mainView);
        make.size.mas_equalTo(CGSizeMake(kgADW(36), kgADW(36)));
    }];
    
    [self.mainView addSubview:self.backImageView];
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.mainView);
    }];
    
    
    [self.mainView addSubview:self.leftView];
    [self.mainView addSubview:self.rightView];
    [self.mainView addSubview:self.ensureButton];
    
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kgADW(20));
        make.top.mas_equalTo(kgADW(89));
        make.right.mas_equalTo(self.rightView.mas_left).offset(-kgADW(15));
        make.height.mas_equalTo(kgADW(223));
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftView);
        make.width.mas_equalTo(self.leftView);
        make.right.mas_equalTo(-kgADW(20));
        make.height.mas_equalTo(self.leftView);
    }];
    
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftView.mas_bottom).offset(0);
        make.left.mas_equalTo(kgADW(28));
        make.right.mas_equalTo(-kgADW(28));
        make.height.mas_equalTo(kgADW(35));
    }];
    
    [self.leftView setupImageUrl:@"lyric_star_default" isMV:NO];
    [self.rightView setupImageUrl:@"lyric_ink_default" isMV:NO];
    //    [self.rightView setupImageUrl:@"dynamic_singerPhoto.jpg" isMV:YES];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"dynamic_singer_photo" ofType:@"mp4"];
//    [self.rightView setupImageUrl:path isMV:YES];
    
    NSString *starPath = [[NSBundle mainBundle] pathForResource:@"lyric_default_star" ofType:@"mp4"];
    NSString *inkPath = [[NSBundle mainBundle] pathForResource:@"lyric_default_ink" ofType:@"mp4"];
    
    [self.leftView setupImageUrl:starPath isMV:YES];
    [self.rightView setupImageUrl:inkPath isMV:YES];
    
#warning lius 此处需要读取原始数据信息，或者一次搞定后，不再展示出来数据
    _currentType = KGLyricEffectType_Star;
    [self updateCurrentModeType:KGLyricEffectType_Star]; // 默认勾选动感写真模式
}

#pragma mark - 显示隐藏动画效果
- (void)showWithShrinkedFrame:(CGRect)shrinkedFrame {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.leftView.isAppear = YES;
    self.rightView.isAppear = YES;
    
    self.shrinkedFrame = shrinkedFrame;
    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
    self.mainView.transform = CGAffineTransformMakeScale(0.001f,0.001f);
    self.mainView.center = shrinkedCenter;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.transform = CGAffineTransformIdentity;
        self.mainView.center = normalCenter;
    }];
    
}


- (void)dismiss {
    if (self.isDismissing) {
        return;
    }
    self.isDismissing = YES;
    CGPoint shrinkedCenter = centerFromFrame(self.dismissFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
    self.leftView.isAppear = NO;
    self.rightView.isAppear = NO;
    
    self.mainView.transform = CGAffineTransformIdentity;
    self.mainView.center = normalCenter;
    NSLog(@"%@",[NSValue valueWithCGPoint:normalCenter]);
    [UIView animateWithDuration:0.5f animations:^{
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


#pragma mark - actions
- (void)updateCurrentModeType:(KGLyricEffectType)type {
    self.leftView.selected = type == KGLyricEffectType_Star;
    self.rightView.selected = type == KGLyricEffectType_Ink;
    
    NSString *title = @"试试";
//    switch (type) {
//        case KGLyricEffectType_Star:
//        {
//            title = @"保持歌手写真模式";
//        }
//            break;
//        case KGLyricEffectType_Ink:
//        {
//            title = @"切换到动感写真";
//        };
//            break;
//    }
    
    [self.ensureButton setTitle:title forState:UIControlStateNormal];
}


- (void)didSelectEnsureAction:(UIButton *)sender {
    NSLog(@"点击了确认按钮:%@",self.currentType == KGLyricEffectType_Star ? @"闪烁星辰" : @"烟染水墨");
    !self.didSelectEffectType ?: self.didSelectEffectType(self.currentType);
    [self dismiss];
}

#pragma mark - setter & getter

- (void)setCurrentType:(KGLyricEffectType)currentType {
    if (_currentType == currentType) {
        return;
    }
    
    _currentType = currentType;
    
    [self updateCurrentModeType:_currentType];
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:self.normalFrame];
        _mainView.backgroundColor = [UIColor clearColor];
//        _mainView.layer.cornerRadius = 12.0f;
//        _mainView.clipsToBounds = NO;
    }
    return _mainView;
}

- (UIImageView *)backImageView {
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lyric_effect_back_image"]];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}

- (KGLyricEffectIntroduceMenu *)leftView {
    if (!_leftView) {
        _leftView = [[KGLyricEffectIntroduceMenu alloc] init];
        _leftView.title = @"闪烁星辰";
        _leftView.didTapViewAction = ^{
#warning lius 注意循环引用
            self.currentType = KGLyricEffectType_Star;
        };
    }
    return _leftView;
}

- (KGLyricEffectIntroduceMenu *)rightView {
    if (!_rightView) {
        _rightView = [[KGLyricEffectIntroduceMenu alloc] init];
        _rightView.title = @"烟染水墨";
        _rightView.didTapViewAction = ^{
#warning lius 注意循环引用
            self.currentType = KGLyricEffectType_Ink;
        };
    }
    return _rightView;
}

- (UIButton *)ensureButton {
    if (!_ensureButton) {
        _ensureButton = [[UIButton alloc]  init];
        _ensureButton.layer.cornerRadius = kgADW(18.0f);
        _ensureButton.layer.masksToBounds = YES;
        _ensureButton.backgroundColor = kLyricSelectedColor;
        _ensureButton.titleLabel.font = [UIFont systemFontOfSize:kgADW(15.0f)];
        [_ensureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_ensureButton addTarget:self action:@selector(didSelectEnsureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureButton;
}

@end
