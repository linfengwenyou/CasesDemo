//
//  KGDynamicIntroduceMenu.m
//  DynamicDemo
//
//  Created by rayor on 2020/10/30.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "KGDynamicIntroduceMenu.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>

@interface KGDynamicIntroduceMenu ()
/* containerView */
@property (nonatomic, strong) UIView *picContainerView;

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong, readwrite) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UIImageView *newsFlag;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, assign) BOOL readyToPlay;

@end

@implementation KGDynamicIntroduceMenu

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.picContainerView];
    [self.picContainerView addSubview:self.picImageView];
    [self addSubview:self.newsFlag];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.subTitleLabel];
    [self addSubview:self.selectedImageView];
    
    [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(self.picContainerView.mas_width).multipliedBy(184/114.0f);
    }];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.picContainerView);
    }];
    
    [self.newsFlag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.picContainerView.mas_right).offset(6);
        make.top.mas_equalTo(self.picContainerView.mas_top).offset(-6);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.picContainerView.mas_bottom).offset(7);
        make.height.mas_equalTo(20);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(2);
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.picContainerView).offset(-7.5);
        make.bottom.mas_equalTo(self.picContainerView).offset(-7.5);
        make.height.width.mas_equalTo(27);
    }];
    
    self.newFeature = NO;
    [self updateState:NO];  // 初始设置为NO
}

#pragma mark - action

- (void)updateState:(BOOL)selected {
    self.picContainerView.layer.borderWidth = selected ? 3 : 0;
    self.titleLabel.textColor = selected ? UIColor.blueColor : UIColor.blackColor;
    self.subTitleLabel.textColor = selected ? UIColor.blueColor : UIColor.lightGrayColor;
    self.selectedImageView.hidden = !selected;
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
        self.picImageView.hidden = YES;
//        self.picImageView.image = [UIImage imageNamed:url];
        // 需要初始化播放器，当播放器初始化完毕隐藏在图片上开始播放
        NSLog(@"需要配置图片信息");
        [self configPlayerWithUrl:url];
        self.readyToPlay = YES;
        [self.player play];
    }
}

- (void)configPlayerWithUrl:(NSString *)url {
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:url]];
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.player.volume = 0;
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.frame = self.picContainerView.bounds;
    playerLayer.opacity = 0.f;
    playerLayer.cornerRadius = 6.0f;
    playerLayer.masksToBounds = YES;
    
    self.playerLayer = playerLayer;
    [self.picContainerView.layer addSublayer:playerLayer];
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
        if (self.readyToPlay) {
            self.playerLayer.opacity = 1.f;
            [self.player play];
            self.readyToPlay = NO;
        }
    }
}


#pragma mark - dealloc
- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNewFeature:(BOOL)newFeature {
    _newFeature = newFeature;
    self.newsFlag.hidden = !_newFeature;
}
#pragma mark - setter & getter
- (UIView *)picContainerView {
    if (!_picContainerView) {
        _picContainerView = [[UIView alloc] init];
        _picContainerView.layer.cornerRadius = 6.0f;
        _picContainerView.layer.borderWidth = 3;
        _picContainerView.backgroundColor = UIColor.lightGrayColor;
        _picContainerView.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return _picContainerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel {
    if (!_subTitleLabel) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor lightGrayColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:10.0f];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subTitleLabel;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.subTitleLabel.text = subTitle;
}

- (void)setSelected:(BOOL)selected {
    if (selected == _selected) {
        return;
    }
    _selected = selected;
    [self updateState:_selected];
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
        _picImageView.layer.cornerRadius = 6;
        _picImageView.layer.masksToBounds = YES;
    }
    return _picImageView;
}

- (UIImageView *)newsFlag {
    if (!_newsFlag) {
        _newsFlag = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videoshare_new"]];
        _newsFlag.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _newsFlag;
}
@end
