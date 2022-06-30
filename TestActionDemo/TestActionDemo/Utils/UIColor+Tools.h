//
//  UIColor+Tools.h
//  DynamicDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static UIColor * UIColorFromRGB(NSInteger rgbValue)
{
    return  [UIColor
             colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0
             green:((float)((rgbValue & 0xFF00) >> 8))/255.0
             blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

#define UIColorFromRGBAndAlpha(rgbValue,pa) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:pa]


@interface UIColor (Tools)

@end

NS_ASSUME_NONNULL_END
