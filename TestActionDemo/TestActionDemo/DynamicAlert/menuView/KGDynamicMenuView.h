//
//  DynamicMenuView.h
//  DynamicDemo
//
//  Created by rayor on 2020/10/9.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Frame.h"

NS_ASSUME_NONNULL_BEGIN

@interface KGDynamicMenuView : UIView

// 选中某种皮肤
@property (nonatomic, copy) void(^selectSkinBlock)(NSString *skinId);

// 选中某种动效强度
@property (nonatomic, copy) void(^selectIntensityBlock)(NSInteger index);

// 选中切换速度
@property (nonatomic, copy) void(^selectSpeedBlock)(NSInteger index);

// 初始化位置展示
- (instancetype)initWithShrinkedFrame:(CGRect)shrinkedFrame;

// 显示动画，隐藏动画不开放出来，因为隐藏只由此空间自己控制不由外部控制
- (void)showWithAnimation;



@end

NS_ASSUME_NONNULL_END
