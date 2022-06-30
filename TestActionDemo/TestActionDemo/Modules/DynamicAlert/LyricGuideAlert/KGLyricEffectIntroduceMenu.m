//
//  KGLyricEffectIntroduceMenu.m
//  DynamicDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "KGLyricEffectIntroduceMenu.h"
#import <AVFoundation/AVFoundation.h>

@interface KGLyricEffectIntroduceMenu ()
/* containerView */
@property (nonatomic, strong) UIView *picContainerView; // 用来设置阴影，和圆角展示

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIImageView *picImageView;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL readyToPlay;

// 是否成功加载好视频
@property (nonatomic, assign) BOOL isLoadVideoSuccess;

// 图片外边框
@property (nonatomic, strong) CALayer *imageOutterLayer;
@end

@implementation KGLyricEffectIntroduceMenu

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.picContainerView];
    [self addSubview:self.picImageView];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectedImageView];
    
    [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(self.picContainerView.mas_width).multipliedBy(175/105.0f);
    }];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.picContainerView);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.selectedImageView.mas_right).mas_offset(5);
        make.centerY.mas_equalTo(self.selectedImageView);
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.picImageView.mas_left).mas_offset(17);
        make.top.mas_equalTo(self.picImageView.mas_bottom).mas_offset(17);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];

    self.imageOutterLayer = [self outterLayerWithView:self.picContainerView borderWidth:1.5f];
    [self.picContainerView.layer addSublayer:self.imageOutterLayer];
    
    [self updateState:NO];  // 初始设置为NO
}



- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateOutterLayerForView:self.picContainerView layer:self.imageOutterLayer];
}
#pragma mark - action

- (void)updateState:(BOOL)selected {
//    self.picContainerView.layer.borderWidth = selected ? 1.5f : 0;

    NSString *imageName = selected ? @"lyric_effect_select" : @"lyric_effect_unselect";
    
    UIImage *image = [UIImage imageNamed:imageName];
    self.selectedImageView.image = image;
    
    self.imageOutterLayer.hidden = selected ? NO : YES;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    !self.didTapViewAction ?: self.didTapViewAction();
}


#pragma mark - Public
- (void)setupImageUrl:(NSString *)url isMV:(BOOL)isMV {
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    if (!isMV) {
        self.picImageView.image = [UIImage imageNamed:url];
    } else {
        // 需要初始化播放器，当播放器初始化完毕隐藏在图片上开始播放
        NSLog(@"需要配置图片信息");
        [self configPlayerWithUrl:url];
    }
}

- (void)configPlayerWithUrl:(NSString *)url {
    
    NSAssert(url.length > 1, @"url不应该为空");
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:url]];
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.player.volume = 0;
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.frame = self.picImageView.bounds;
    playerLayer.opacity = 0.f;
    playerLayer.cornerRadius = 6.0f;
    playerLayer.masksToBounds = YES;
    
    self.playerLayer = playerLayer;
    [self.picImageView.layer addSublayer:playerLayer];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.playerItem = item;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endplay) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}


- (void)endplay {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerStatus status = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
    if (status == AVPlayerStatusReadyToPlay) {
        // 模拟的加载信息
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.isLoadVideoSuccess = YES;
            self.playerLayer.opacity = 1.f;
            [self updatePlayerState];
//        });
    }
}


#pragma mark - dealloc
- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 添加外边框
- (CALayer *)outterLayerWithView:(UIView *)view borderWidth:(CGFloat)borderWidth {
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(view.x - borderWidth, view.y - borderWidth, view.width + 2 * borderWidth, view.height + 2*borderWidth);
    layer.masksToBounds = YES;
    layer.cornerRadius = view.layer.cornerRadius + borderWidth;
    layer.borderWidth = borderWidth;
    layer.borderColor = UIColorFromRGBAndAlpha(0x6CDFFF, 0.6f).CGColor;
    
    return layer;
}


- (void)updateOutterLayerForView:(UIView *)view layer:(CALayer *)layer {
    CGFloat borderWidth = layer.borderWidth;
    layer.frame = CGRectMake(view.x - borderWidth, view.y - borderWidth, view.width + 2 * borderWidth, view.height + 2*borderWidth);
}

#pragma mark - setter & getter
- (UIView *)picContainerView {
    if (!_picContainerView) {
        _picContainerView = [[UIView alloc] init];
        _picContainerView.layer.cornerRadius = 9.0f;
        _picContainerView.backgroundColor = UIColor.lightGrayColor;
        
        
        // 设置阴影效果
        _picContainerView.layer.shadowColor = UIColorFromRGB(0x3873CA).CGColor;
        _picContainerView.layer.shadowOffset = CGSizeMake(12, 24);
        _picContainerView.layer.shadowRadius = 24.f;
        _picContainerView.layer.shadowOpacity = 0.12f;
        
        
    }
    return _picContainerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithRed:129/255.0 green:136/255.0 blue:148/255.0 alpha:1.0];
        _titleLabel.font = [UIFont systemFontOfSize:12.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}


- (void)setSelected:(BOOL)selected {
    if (selected == _selected) {
        return;
    }
    _selected = selected;
    [self updateState:_selected];
    [self updatePlayerState];
}

- (void)setIsAppear:(BOOL)isAppear {
    _isAppear = isAppear;
    [self updatePlayerState];
}

- (void)updatePlayerState {
    if (self.isAppear == NO || self.isLoadVideoSuccess == NO) { // 未显示或者未加载完毕不予展示处理
        return;
    }
    if (self.isLoadVideoSuccess && self.selected && self.isAppear) {    // 视频加载成功，当前选中，且app也显示出来
        [self.player play];
//        self.readyToPlay = NO;
    } else {
        [self.player pause];
//        self.readyToPlay = NO;
    }
}

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_mode_selected"]];
        _selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _selectedImageView;
}

- (UIImageView *)picImageView {
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.contentMode = UIViewContentModeScaleAspectFit;
        _picImageView.layer.cornerRadius = 9;
        _picImageView.layer.masksToBounds = YES;
    }
    return _picImageView;
}

@end
