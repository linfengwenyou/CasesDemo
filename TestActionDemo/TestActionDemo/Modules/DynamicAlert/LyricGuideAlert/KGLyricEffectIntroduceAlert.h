//
//  KGLyricEffectIntroduceAlert.h
//  DynamicDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, KGLyricEffectType) {
    KGLyricEffectType_Star = 0,     // 闪烁星辰
    KGLyricEffectType_Ink,          // 水墨
};

NS_ASSUME_NONNULL_BEGIN

@interface KGLyricEffectIntroduceAlert : UIView

// 销毁时的尺寸位置
@property (nonatomic, assign) CGRect dismissFrame;

- (void)showWithShrinkedFrame:(CGRect)shrinkedFrame;

/* 选中模式的回调*/
@property (nonatomic, copy) void(^didSelectEffectType)(KGLyricEffectType lyricType);
@end

NS_ASSUME_NONNULL_END
