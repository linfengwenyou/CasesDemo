//
//  KGDynamicGuideAlert.m
//  DynamicDemo
//
//  Created by rayor on 2021/12/14.
//  Copyright © 2021 rayor. All rights reserved.
//

#import "KGDynamicGuideAlert.h"

#import <Masonry/Masonry.h>
#import "UIView+Frame.h"


// 主视图信息
#define pMainViewWidth 265.0f

@interface KGDynamicGuideAlert ()
// 缩小后的位置所在
@property (nonatomic,assign) CGRect shrinkedFrame;

// 容器视图
@property (nonatomic, strong) UIView *mainView;

/* 标题栏 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 子标题栏 */
@property (nonatomic, strong) UILabel *subLabel;

@property (nonatomic, strong) UIView *playerView;

/*确认按钮*/
@property (nonatomic, strong) UIButton *ensureButton;

/*新特性标签*/
@property (nonatomic, strong) UIImageView *newsFlag;

/* 是否正在消失 */
@property (nonatomic,assign) BOOL isDismissing;


@end

@implementation KGDynamicGuideAlert

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        [self createSubViews];
    }
    return self;
}


- (void)createSubViews {
    [self addSubview:self.mainView];
    
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(pMainViewWidth);
    }];
    
    // 关闭按钮无用，点击只要是非弹窗区域全部隐藏，关闭按钮只是个样式
    UIImageView *closeImag = [[UIImageView alloc] init];
    closeImag.image = [UIImage imageNamed:@"headwear_alert_close_btn"];
    [self.mainView addSubview:closeImag];
    [closeImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mainView.mas_right);
        make.bottom.mas_equalTo(self.mainView.mas_top).offset(-15);
        make.width.height.mas_equalTo(16);
    }];
    
    // 主标
    [self.mainView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(20);
    }];
    
    // 副标
    [self.mainView addSubview:self.subLabel];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(12);
    }];
    
    // 动感容器
    [self.mainView addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(self.subLabel.mas_bottom).mas_equalTo(15);
        make.width.mas_equalTo(225);
        make.height.mas_equalTo(225);
    }];
    
    // 新特性标签
    [self.mainView addSubview:self.newsFlag];
    [self.newsFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.playerView).mas_offset(-10);
        make.top.mas_equalTo(self.playerView).mas_offset(10);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(15);
    }];
    
    
    // 确认按钮
    [self.mainView addSubview:self.ensureButton];
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.playerView);
        make.height.mas_equalTo(36);
        make.top.mas_equalTo(self.playerView.mas_bottom).mas_offset(15);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self updateUiTitles];
}

#pragma mark - 显示隐藏动画效果
- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
//    self.mainView.transform = CGAffineTransformMakeScale(0.001f,0.001f);
    self.mainView.alpha = 0;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.alpha = 1;
        self.mainView.transform = CGAffineTransformIdentity;
    }];
    
}


- (void)dismiss {
    if (self.isDismissing) {
        return;
    }
    self.isDismissing = YES;
    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    
    self.mainView.transform = CGAffineTransformIdentity;
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

#pragma mark - 更新UI展示
- (void)updateUiTitles {
    self.titleLabel.text = @"播放页背景新增律动音响";
    self.subLabel.text = @"音响跟随歌曲节奏振动，震撼的视听享受";
    [self.ensureButton setTitle:@"切换到律动音响" forState:UIControlStateNormal];
}

#pragma mark - 事件
- (void)didSelectEnsureAction:(UIButton *)sender {
    [self dismiss];
}


#pragma mark - setter & getter

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectZero];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = 12.0f;
        _mainView.clipsToBounds = NO;
    }
    return _mainView;
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [[UILabel alloc] init];
        _subLabel.textColor = [UIColor blackColor];
        _subLabel.font = [UIFont systemFontOfSize:12.0f];
        _subLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subLabel;
}

- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
        _playerView.backgroundColor = UIColor.blueColor;
        _playerView.layer.cornerRadius = 18.f;
        _playerView.layer.masksToBounds = YES;
    }
    return _playerView;
}

- (UIButton *)ensureButton {
    if (!_ensureButton) {
        _ensureButton = [[UIButton alloc]  init];
        _ensureButton.layer.cornerRadius = 18.0f;
        _ensureButton.layer.masksToBounds = YES;
        _ensureButton.backgroundColor = [UIColor blueColor];
        _ensureButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_ensureButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_ensureButton addTarget:self action:@selector(didSelectEnsureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureButton;
}

- (UIImageView *)newsFlag {
    if (!_newsFlag) {
        _newsFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videoshare_new"]];
        _newsFlag.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _newsFlag;
}
@end
