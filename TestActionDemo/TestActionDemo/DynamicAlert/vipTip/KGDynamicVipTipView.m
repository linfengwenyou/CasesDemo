//
//  KGDynamicVipTipView.m
//  DynamicDemo
//
//  Created by rayor on 2020/10/22.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "KGDynamicVipTipView.h"
#import <Masonry.h>

// 默认尝试皮肤12s
#define kMaxTryVipSkinTime 500

@interface KGDynamicVipTipView ()
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIImageView *arrImgView;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, assign) NSInteger currentTryTime;
@end

@implementation KGDynamicVipTipView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _currentTryTime = kMaxTryVipSkinTime + 1;
        [self createSubViews];
        [self updateTipTitle];
    }
    return self;
}


- (void)createSubViews {
    
    UIView *lineV = [[UIView alloc] init];
    lineV.backgroundColor = [UIColor colorWithWhite:1 alpha:0.2];
    
    [self addSubview:self.timeLabel];
    [self addSubview:lineV];
    [self addSubview:self.tipLabel];
    [self addSubview:self.arrImgView];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(30);
    }];
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.timeLabel.mas_right);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(0.5);
        make.height.mas_equalTo(16);
    }];
    
    [self.arrImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.centerY.mas_equalTo(self);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrImgView.mas_left).offset(-5);
        make.left.mas_equalTo(lineV.mas_right).offset(10);
        make.centerY.mas_equalTo(self);
    }];
    
}


- (void)updateTipTitle {
    
    [self updateTimeLabel];
    
    NSString *text = @"动效试用中，开通会员即可畅享";
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    NSRange range = [text rangeOfString:@"开通会员"];
    [attr addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:range];
    
    self.tipLabel.attributedText = attr;

}

- (void)updateTimeLabel {
    self.timeLabel.text = @(self.currentTryTime).stringValue;
    if (self.currentTryTime == 0) {
        !self.didFinishTimerAction ?: self.didFinishTimerAction();
        [self cancelTimer];
        self.currentTryTime = (kMaxTryVipSkinTime+1);
        [self removeFromSuperview];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    !self.didTapVipTipViewAction ?: self.didTapVipTipViewAction();
}


#pragma mark 计时器
- (void)startTimer
{
    [self cancelTimer];
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0.5 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        self.currentTryTime -= 1;
        [self updateTimeLabel];
    });
    dispatch_resume(timer);
    self.timer = timer;
}


- (void)cancelTimer {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}


#pragma mark - setter & getter
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColor.whiteColor;
        _timeLabel.font = [UIFont systemFontOfSize:13.0f];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}


- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:11.0f];
        _tipLabel.textColor = [UIColor whiteColor];
    }
    return _tipLabel;
}

- (UIImageView *)arrImgView {
    if (!_arrImgView) {
        _arrImgView = [[UIImageView alloc] init];
        _arrImgView.image = [UIImage imageNamed:@"mc_arrow"];
    }
    return _arrImgView;
}

@end
