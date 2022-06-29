//
//  KGDynammicVipAlertView.m
//  DynamicDemo
//
//  Created by rayor on 2020/10/25.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "KGDynamicVipAlertView.h"
#import <Masonry/Masonry.h>

@interface KGDynamicVipAlertView ()

// 容器视图
@property (nonatomic, strong) UIView *mainView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *ensureButton;
@property (nonatomic, strong) UIButton *retryButton;
@end

@implementation KGDynamicVipAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [self createSubViews];
    }
    return self;
}

#pragma mark - UI


- (void)createSubViews {
    
    [self addSubview:self.mainView];
    // 内部子视图通过约束的方式添加上去
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
        make.width.mas_equalTo(265);
        make.height.mas_equalTo(300);
    }];
    
    // 关闭按钮无用，点击只要是非弹窗区域全部隐藏，关闭按钮只是个样式
    UIImageView *closeImag = [[UIImageView alloc] init];
    closeImag.image = [UIImage imageNamed:@"headwear_alert_close_btn"];
    [self addSubview:closeImag];
    [closeImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mainView.mas_right);
        make.bottom.mas_equalTo(self.mainView.mas_top).offset(-15);
        make.width.height.mas_equalTo(16);
    }];
    
    // 向mainView中填充数据
    UIImageView *imgView = [[UIImageView alloc] init];
    [self.mainView addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"dynamic_vip_alert"];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(128);
    }];
    
    [self.mainView addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(imgView.mas_bottom).offset(22);
        make.height.mas_equalTo(60);
    }];
    self.descLabel.text = @"动效试用结束，开通会员畅享完整写真动效";
    
    // 开通会员
    [self.mainView addSubview:self.ensureButton];
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
        make.top.mas_equalTo(self.descLabel.mas_bottom);
    }];
    
    [self.mainView addSubview:self.retryButton];
    [self.retryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.ensureButton);
        make.top.mas_equalTo(self.ensureButton.mas_bottom).offset(15);
        make.height.mas_equalTo(self.ensureButton);
    }];
    
}

#pragma mark - setter & getter

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:CGRectZero];
        _mainView.backgroundColor = [UIColor whiteColor];
        _mainView.layer.cornerRadius = 10.0f;
        _mainView.clipsToBounds = YES;
    }
    return _mainView;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor blackColor];
        _descLabel.font = [UIFont systemFontOfSize:14.0f];
        _descLabel.numberOfLines = 2;
    }
    return _descLabel;
}

- (UIButton *)ensureButton {
    if (!_ensureButton) {
        _ensureButton = [[UIButton alloc] init];
        [_ensureButton setTitle:@"开通会员" forState:UIControlStateNormal];
        [_ensureButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        _ensureButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_ensureButton addTarget:self action:@selector(didTapOpenVipAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensureButton;
}

- (UIButton *)retryButton {
    if (!_retryButton) {
        _retryButton = [[UIButton alloc] init];
        [_retryButton setTitle:@"继续试用" forState:UIControlStateNormal];
        [_retryButton setTitleColor:UIColor.redColor forState:UIControlStateNormal];
        _retryButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_retryButton addTarget:self action:@selector(didTapRetryAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

#pragma mark - 事件处理
- (void)didTapOpenVipAction:(UIButton *)sender {
    !self.didTapVipAction ?: self.didTapVipAction();
    [self dismiss];
}

- (void)didTapRetryAction:(UIButton *)sender {
    !self.didTapRetryAction ?: self.didTapRetryAction();
    [self dismiss];
}

#pragma mark - 显示隐藏动画效果
- (void)show {
    NSArray *subViews = [[UIApplication sharedApplication].keyWindow subviews];
    BOOL isShow = NO;
    for (UIView *sub in subViews) {
        if ([sub isKindOfClass:[self class]]) {
            isShow = YES;
        }
    }
    if (isShow) {
        return;
    }
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.15 animations:^{
        self.alpha = 1.0f;
    }];
    
}


- (void)dismiss {
    
    [UIView animateWithDuration:0.15f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
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



@end
