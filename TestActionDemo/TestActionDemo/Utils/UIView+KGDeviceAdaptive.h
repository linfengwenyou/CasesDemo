//
//  UIView+KGDeviceAdaptive.h
//  KGCommonVC
//
//  Created by SaboWong on 2019/12/11.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (KGDeviceAdaptive)

/// 基于iPhoneX的屏幕宽度作为适配，根据当前设备宽度与iPhoneX的屏幕的比值对frame的size进行相乘返回新的frame的构造方法
/// @param frame 传入需要适配的frame
- (instancetype)initWithKGAdaptiveByiPhoneXWidthFrame:(CGRect)frame;

/// 基于iPhoneX的屏幕宽度作为适配，根据当前设备宽度与iPhoneX的屏幕的比值对frame的size进行相乘结果调整view的frame
- (void)kgAdaptiveByiPhoneXWidth;

/// 基于iPhoneX的屏幕宽度作为适配，根据当前设备宽度与iPhoneX的屏幕的比值对frame的size进行相乘返回新的frame
- (CGRect)kgAdaptiveByiPhoneXWidthWithFreme:(CGRect)frame;

/// 基于iPhoneX的屏幕宽度作为适配，根据当前设备宽度与iPhoneX的屏幕的比值对value进行相乘返回新的value
/// @param value 传入需要适配的value
+ (CGFloat)kgAdaptiveByiPhoneXWidthWithValue:(CGFloat)value;

@end
NS_ASSUME_NONNULL_END
//简称方法
CGRect KGRectMakeADR(CGRect rect);//kgAdaptiveByiPhoneXWidthWithFreme
CGFloat kgADW(CGFloat widthValue);// kgAdaptiveByiPhoneXWidthWithValue
CGFloat kgADWSupportH(CGFloat widthValue);//修改kgADW来支持横竖屏
