//
//  UIView+KGDeviceAdaptive.m
//  KGCommonVC
//
//  Created by SaboWong on 2019/12/11.
//

#import "UIView+KGDeviceAdaptive.h"

@implementation UIView (KGDeviceAdaptive)

- (instancetype)initWithKGAdaptiveByiPhoneXWidthFrame:(CGRect)frame{
    CGRect newFrame = [self kgAdaptiveByiPhoneXWidthWithFreme:frame];
    self = [self initWithFrame:newFrame];
    if (self) {}
    return self;
}

- (void)kgAdaptiveByiPhoneXWidth{
    self.frame = [self kgAdaptiveByiPhoneXWidthWithFreme:self.frame];
}

- (CGRect)kgAdaptiveByiPhoneXWidthWithFreme:(CGRect)frame{
    CGRect newFrame = frame;
    CGSize size = newFrame.size;
    size.width = [UIView kgAdaptiveByiPhoneXWidthWithValue:size.width];
    size.height = [UIView kgAdaptiveByiPhoneXWidthWithValue:size.height];
    newFrame.size = size;
    
    return newFrame;
}

+ (CGFloat)kgAdaptiveByiPhoneXWidthWithValue:(CGFloat)value{
    CGFloat screenWidth = MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    CGFloat tmp = value*(screenWidth/360.0) + 0.5;
    NSInteger tmpInt = (NSInteger)tmp;
    return tmpInt*1.0;
}

@end

CGRect KGRectMakeADR(CGRect rect)
{
    CGRect newFrame = rect;
    CGSize size = newFrame.size;
    size.width = [UIView kgAdaptiveByiPhoneXWidthWithValue:size.width];
    size.height = [UIView kgAdaptiveByiPhoneXWidthWithValue:size.height];
    newFrame.size = size;
    
    return newFrame;
}

CGFloat kgADW(CGFloat widthValue)
{
    return [UIView kgAdaptiveByiPhoneXWidthWithValue:widthValue];
}

CGFloat kgADWSupportH(CGFloat value)
{
    CGFloat screenWidth = MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    CGFloat tmp = value*(screenWidth/375.0) + 0.5;
    NSInteger tmpInt = (NSInteger)tmp;
    return tmpInt*1.0;
}
