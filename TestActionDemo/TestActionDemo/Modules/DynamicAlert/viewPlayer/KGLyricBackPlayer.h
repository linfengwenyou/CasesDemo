//
//  KGLyricBackPlayer.h
//  DynamicDemo
//
//  Created by rayor on 2022/6/30.
//  Copyright © 2022 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGLyricBackPlayer : UIView

// 当前是否正在播放
@property (nonatomic, assign, readonly) BOOL isPlaying;
/*当前视图是否显示*/
@property (nonatomic, assign) BOOL isAppear;

/*开始播放使用*/
- (void)playWithUrl:(NSString *)url;

- (void)play;

- (void)pause;

@end

NS_ASSUME_NONNULL_END
