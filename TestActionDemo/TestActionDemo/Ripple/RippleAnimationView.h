//
//  RippleAnimationView.h
//  DemoTest
//
//  Created by rayor on 2020/8/25.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RippleAnimationView : UIView
/**
  设置扩散倍数。默认1.423倍
*/
@property (nonatomic, assign) CGFloat enlargeRate;

/* 设置脉冲的图片信息，如果需要配置外围脉冲颜色需要自己配置
 _pulsBubbleColors =  @[
 (__bridge id)ColorWithAlpha(255, 231, 152, 0.5).CGColor,
 (__bridge id)ColorWithAlpha(255, 241, 197, 0.5).CGColor];
 */
@property (nonatomic, strong) NSArray *pulsBubbleColors;


- (instancetype)initWithFrame:(CGRect)frame;
@end

NS_ASSUME_NONNULL_END
