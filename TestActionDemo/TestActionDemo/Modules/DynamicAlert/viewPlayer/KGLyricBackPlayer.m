//
//  KGLyricBackPlayer.m
//  DynamicDemo
//
//  Created by rayor on 2022/6/30.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "KGLyricBackPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface KGLyricBackPlayer ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
// 是否成功加载好视频
@property (nonatomic, assign) BOOL isLoadVideoSuccess;
@end

@implementation KGLyricBackPlayer

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)playWithUrl:(NSString *)url {
    NSAssert(url.length > 1, @"url不应该为空");
    
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:url]];
    self.player = [AVPlayer playerWithPlayerItem:item];
    self.player.volume = 0;
    
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame = self.bounds;
    layer.opacity = 0.f;
//    layer.cornerRadius = 0;
//    layer.masksToBounds = YES;
    
    self.playerLayer = layer;
    
    [self.layer addSublayer:layer];
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    self.playerItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endplay) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
}

- (void)endplay {
    [self.player seekToTime:kCMTimeZero];
    [self.player play];
}

#pragma mark - dealloc
- (void)dealloc {
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    AVPlayerStatus status = [[change valueForKey:NSKeyValueChangeNewKey] integerValue];
    NSLog(@"%ld", status);
    if (status == AVPlayerStatusReadyToPlay) {
        // 模拟的加载信息
        self.isLoadVideoSuccess = YES;
        self.playerLayer.opacity = 1.f;
        [self updatePlayerState];
    }
}

- (void)play {
    if (self.isAppear && self.isLoadVideoSuccess) {
        [self.player play];
        _isPlaying = YES;
    }
}

- (void)pause {
    if (self.isAppear && self.isLoadVideoSuccess) {
        [self.player pause];
        _isPlaying = NO;
    }
}

- (void)updatePlayerState {
    if (self.isAppear == NO || self.isLoadVideoSuccess == NO) { // 未显示或者未加载完毕不予展示处理
        return;
    }
    if (self.isLoadVideoSuccess && self.isAppear) {    // 视频加载成功，当前选中，且app也显示出来
        [self.player play];
        _isPlaying = YES;
    } else {
        [self.player pause];
        _isPlaying = NO;
    }
}
@end
