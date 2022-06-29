//
//  KGDynamicIntroduceAlert.m
//  DynamicDemo
//
//  Created by rayor on 2020/10/30.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "KGDynamicIntroduceAlert.h"
#import "KGDynamicIntroduceMenu.h"


// 主视图信息
#define pMainViewHeight 360.0f
#define pMainViewWidth 265.0f

@interface KGDynamicIntroduceAlert ()
// 缩小后的位置所在
@property (nonatomic,assign) CGRect shrinkedFrame;

// 正常展示的位置所在
@property (nonatomic,assign) CGRect normalFrame;

// 容器视图
@property (nonatomic, strong) UIView *mainView;

/* 标题栏 */
@property (nonatomic, strong) UILabel *titleLabel;

/* 左，歌手写真 */
@property (nonatomic, strong) KGDynamicIntroduceMenu *leftView;
/* 右，动感写真 */
@property (nonatomic, strong) KGDynamicIntroduceMenu *rightView;

@property (nonatomic, strong) UIButton *ensureButton;

/* 当前类型 */
@property (nonatomic,assign) KGDynamicIntroduceType currentType;

/* 是否正在消失 */
@property (nonatomic,assign) BOOL isDismissing;

@end

@implementation KGDynamicIntroduceAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
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
    closeImag.image = [UIImage imageNamed:@"headwear_alert_close_btn"];
    [self.mainView addSubview:closeImag];
    [closeImag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mainView.mas_right);
        make.bottom.mas_equalTo(self.mainView.mas_top).offset(-15);
        make.width.height.mas_equalTo(16);
    }];
    
    [self.mainView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(54);
    }];
    self.titleLabel.text = @"写真新增动感模式";
    
    
    [self.mainView addSubview:self.leftView];
    [self.mainView addSubview:self.rightView];
    [self.mainView addSubview:self.ensureButton];
    
    
    [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(12);
        make.top.mas_equalTo(self.titleLabel.mas_bottom);
        make.right.mas_equalTo(self.rightView.mas_left).offset(-12);
        make.height.mas_equalTo(225);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftView);
        make.width.mas_equalTo(self.leftView);
        make.right.mas_equalTo(-12);
        make.height.mas_equalTo(self.leftView);
    }];
    
    [self.ensureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leftView.mas_bottom).offset(22);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(36);
    }];
    
    [self.leftView setupImageUrl:@"singerPhoto.jpg" isMV:NO];
//    [self.rightView setupImageUrl:@"dynamic_singerPhoto.jpg" isMV:YES];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"dynamic_singer_photo" ofType:@"mp4"];
    [self.rightView setupImageUrl:path isMV:YES];
    
#warning lius 此处需要读取原始数据信息，或者一次搞定后，不再展示出来数据
    _currentType = KGDynamicIntroduceType_DynamicSingerPhoto;
    [self updateCurrentModeType:KGDynamicIntroduceType_DynamicSingerPhoto]; // 默认勾选动感写真模式
}

#pragma mark - 显示隐藏动画效果
- (void)showWithShrinkedFrame:(CGRect)shrinkedFrame {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
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
    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
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
- (void)updateCurrentModeType:(KGDynamicIntroduceType)type {
    self.leftView.selected = type == KGDynamicIntroduceType_SingerPhoto;
    self.rightView.selected = type == KGDynamicIntroduceType_DynamicSingerPhoto;
    
    NSString *title = @"";
    switch (type) {
        case KGDynamicIntroduceType_SingerPhoto:
        {
            title = @"保持歌手写真模式";
        }
            break;
        case KGDynamicIntroduceType_DynamicSingerPhoto:
        {
            title = @"切换到动感写真";
        };
            break;
    }
    
    [self.ensureButton setTitle:title forState:UIControlStateNormal];
}


- (void)didSelectEnsureAction:(UIButton *)sender {
    NSLog(@"点击了确认按钮:%@",self.currentType == KGDynamicIntroduceType_DynamicSingerPhoto ? @"动感写真" : @"歌手写真");
    !self.didSelectSingerMode ?: self.didSelectSingerMode(self.currentType);
    [self dismiss];
}

#pragma mark - setter & getter

- (void)setCurrentType:(KGDynamicIntroduceType)currentType {
    if (_currentType == currentType) {
        return;
    }
    
    _currentType = currentType;
    
    [self updateCurrentModeType:_currentType];
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:self.normalFrame];
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

- (KGDynamicIntroduceMenu *)leftView {
    if (!_leftView) {
        _leftView = [[KGDynamicIntroduceMenu alloc] init];
        _leftView.title = @"歌手写真";
        _leftView.subTitle = @"静态显示歌手写真";
        _leftView.didTapViewAction = ^{
#warning lius 注意循环引用
            self.currentType = KGDynamicIntroduceType_SingerPhoto;
        };
    }
    return _leftView;
}

- (KGDynamicIntroduceMenu *)rightView {
    if (!_rightView) {
        _rightView = [[KGDynamicIntroduceMenu alloc] init];
        _rightView.title = @"动感写真";
        _rightView.subTitle = @"写真跟随歌曲节奏抖动";
        _rightView.newFeature = YES;
        _rightView.didTapViewAction = ^{
#warning lius 注意循环引用
            self.currentType = KGDynamicIntroduceType_DynamicSingerPhoto;
        };
    }
    return _rightView;
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
@end
