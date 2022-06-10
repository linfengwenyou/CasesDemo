//
//  KGPlayViewVideoEntranceView.m
//  ContactBookDemo
//
//  Created by rayor on 2021/8/4.
//

#import "KGPlayViewVideoEntranceView.h"
#import "KGPlayViewVideoEntranceConfig.h"

#define DEGREES_TO_RADIANS(x) (x * M_PI/180.0)

@interface KGPlayViewVideoEntranceView ()
/*点击按钮，用来处理事件*/
@property (nonatomic, strong, readwrite) UIButton *coverButton;

/*展开视图的容器, 内部防止一个关闭图标*/
@property (nonatomic, strong) UIView *unfoldContainer;
/*未展开视图的容器， 内部放层叠视图*/
@property (nonatomic, strong) UIView *foldContainer;

/*imageView数组信息*/
@property (nonatomic, strong) NSMutableArray *imageViews;

/*提示语label*/
@property (nonatomic, strong) UILabel *badgeLabel;

/*暂停按钮*/
@property (nonatomic, strong) UIImageView *pauseImageView;

@property (nonatomic, strong) UIImageView *closeImageView;

@end

@implementation KGPlayViewVideoEntranceView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    // 底部统一按钮
    [self addSubview:self.coverButton];
    
    [self addSubview:self.unfoldContainer];
    [self addSubview:self.foldContainer];
    
    for (UIImageView *imgView in self.imageViews.reverseObjectEnumerator.allObjects) {  // 翻转调整添加的层级
        [self.foldContainer addSubview:imgView];
    }
    [self.foldContainer addSubview:self.pauseImageView];
    [self.foldContainer addSubview:self.badgeLabel];
    
    [self.unfoldContainer addSubview:self.closeImageView];
    
    self.unfoldContainer.alpha = 0;
}


- (void)updateConstraints {
    
    // 更新约束信息
    
    // 底层按钮
    [self.coverButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.foldContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.unfoldContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    
    // 视图层级
    for (int i = 0; i<self.imageViews.count ; i++) {
        UIImageView *imgView =  self.imageViews[i];
        CGFloat centerXOffset = -1.5f + 6.f * i;
        CGFloat centerYOffset = 4.0f * i;
        
        [imgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self).mas_offset(centerXOffset);
            make.centerY.mas_equalTo(self).mas_offset(centerYOffset);
            make.width.mas_equalTo(30);
            make.height.mas_equalTo(18);
        }];
        
    }
    
    
    UIImageView *imageView = self.imageViews.firstObject;
    
    [self.pauseImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(imageView);
        make.width.height.mas_equalTo(9);
    }];
    
    
    
    CGFloat height = 14;
    CGFloat width = [self.badgeLabel sizeThatFits:CGSizeMake(100, height)].width;
    if (width < height * 0.8) {
        width = height;
    } else {
        width += 5;
    }
    
    [self.badgeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView.mas_right);
        make.centerY.mas_equalTo(imageView.mas_top);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    
    
    [self.closeImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.unfoldContainer);
        make.width.height.mas_equalTo(12);
    }];
    
    [super updateConstraints];
}


- (void)setBadgeValue:(NSInteger)badgeValue {
    _badgeValue = badgeValue;
    self.badgeLabel.text = [NSString stringWithFormat:@"%ld",_badgeValue];
    [self setNeedsUpdateConstraints];
}


- (void)setImageUrls:(NSArray *)imageUrls {
    // 只需要取前面两个即可
    _imageUrls = imageUrls;
    
#warning lius 此处需要处理展示逻辑
}


#pragma mark - 动画段效果

- (CGFloat)secondAnimationDuration {
    return 0.15f;
}
- (CGFloat)firstAnimationDuration {
    CGFloat duration = [KGPlayViewVideoEntranceConfig durateForUnfold] - [self secondAnimationDuration];
    if (duration < 0) {
        duration = 0.15f;
    }
    return duration;
}

#pragma mark - public
- (void)updateEntransViewWithIsUnfold:(BOOL)unfold {
    if (unfold) {
        [self showUnfoldView];
    } else {
        [self showFoldView];
    }
}

/*显示折叠视图*/
- (void)showFoldView {
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:[self firstAnimationDuration] animations:^{
        self.unfoldContainer.alpha = 0;
        self.closeImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:[self secondAnimationDuration] animations:^{
            self.foldContainer.alpha = 1;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled  = YES;
        }];
    }];
}

/*显示展开视图*/
- (void)showUnfoldView {
    self.userInteractionEnabled = NO;
    self.foldContainer.alpha = 0;
    [UIView animateWithDuration:[self firstAnimationDuration] animations:^{
        self.unfoldContainer.alpha = 1;
        self.closeImageView.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(179.5));
    } completion:^(BOOL finished) {
        self.userInteractionEnabled = YES;
    }];
}



#pragma mark - getter
/*折叠的容器*/
- (UIView *)foldContainer {
    if (!_foldContainer) {
        _foldContainer = [[UIView alloc] init];
        _foldContainer.userInteractionEnabled = NO;
    }
    return _foldContainer;
}
/*展开的容器*/
- (UIView *)unfoldContainer {
    if (!_unfoldContainer) {
        _unfoldContainer = [[UIView alloc] init];
        _unfoldContainer.userInteractionEnabled = NO;
    }
    return _unfoldContainer;
}

- (NSMutableArray *)imageViews {
    if (!_imageViews) {
        _imageViews = @[].mutableCopy;
        
        // 创建两个视图
        for (int i = 0; i < 2; i++) {
            UIImageView *tmpView = [self createAImageView];
            [_imageViews addObject:tmpView];
            tmpView.alpha = i == 0 ? 1.0f : 0.55f;
        }
    }
    return _imageViews;
}


- (UIImageView *)createAImageView {
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.layer.cornerRadius = 3.0f;
    imgView.layer.borderWidth = 1.0f;
    imgView.layer.borderColor = UIColor.whiteColor.CGColor;
    imgView.backgroundColor = UIColor.purpleColor;
    imgView.layer.masksToBounds = YES;
    return imgView;
}

- (UIButton *)coverButton {
    if (!_coverButton) {
        _coverButton = [[UIButton alloc] init];
    }
    return _coverButton;
}

- (UILabel *)badgeLabel {
    if (!_badgeLabel) {
        _badgeLabel = [[UILabel alloc] init];
        _badgeLabel.textColor = UIColor.blackColor;
        _badgeLabel.backgroundColor = UIColor.whiteColor;
        _badgeLabel.font = [UIFont boldSystemFontOfSize:9];
        _badgeLabel.layer.cornerRadius = 7.0f;
        _badgeLabel.layer.masksToBounds = YES;
        _badgeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _badgeLabel;
}

- (UIImageView *)pauseImageView {
    if (!_pauseImageView) {
        _pauseImageView = [[UIImageView alloc] init];
        _pauseImageView.contentMode = UIViewContentModeScaleAspectFit;
        _pauseImageView.image = [UIImage imageNamed:@"kg_ic_player_video_play_small"];
    }
    return _pauseImageView;
}


- (UIImageView *)closeImageView {
    if (!_closeImageView) {
        _closeImageView = [[UIImageView alloc] init];
        _closeImageView.contentMode = UIViewContentModeScaleAspectFit;
        _closeImageView.image = [UIImage imageNamed:@"kg_ic_player_close_large"];
    }
    return _closeImageView;
}
@end
