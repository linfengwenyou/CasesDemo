//
//  KGDynamicVipTipView.h
//  DynamicDemo
//
//  Created by rayor on 2020/10/22.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGDynamicVipTipView : UIView

// 倒计时结束，需要通知外面提示弹框，并切换回上一次的默认免费效果
@property (nonatomic, copy) void(^didFinishTimerAction)(void);

// 点击了会员弹层，需要跳转到会员页面
@property (nonatomic, copy) void(^didTapVipTipViewAction)(void);
- (void)startTimer;

/* 当歌曲停止播放时，需要停止计时，下次开启重新计时 */
- (void)cancelTimer;

@end

NS_ASSUME_NONNULL_END
