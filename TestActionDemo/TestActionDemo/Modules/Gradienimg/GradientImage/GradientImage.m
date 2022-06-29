//
//  GradientImage.m
//  DemoTest
//
//  Created by rayor on 2020/8/31.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "GradientImage.h"

@implementation GradientImage

+ (UIImage *)imageWithFrame:(CGRect)frame locations:(NSArray *)locations colors:(NSArray *)colors {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置开始和结束位置(设置渐变的方向)
    gradient.startPoint = CGPointMake(0,0);
    gradient.endPoint = CGPointMake(0,1);
    gradient.colors = colors;
    gradient.locations = locations;
    gradient.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [gradient renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)imageWithFrame:(CGRect)frame locations:(NSArray *)locations backColor:(UIColor *)backColor opaqueValues:(NSArray *)opaques {
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    
    NSMutableArray *colors = @[].mutableCopy;
    
    for (NSNumber *alpha in opaques) {  // 作为遮罩不透明度正好翻转
#warning lius 需要配置颜色信息
        [colors addObject:(id)[UIColor colorWithWhite:1 alpha:alpha.floatValue].CGColor];
    }
    
    gradientMask.colors = colors;
    gradientMask.locations = locations;
    
    gradientMask.startPoint = CGPointMake(0.5, 0);  // 竖直方向上渐变
    gradientMask.endPoint = CGPointMake(0.5, 1);
    gradientMask.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    CALayer *backLayer  = [[CALayer alloc] init];
    backLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    backLayer.backgroundColor = backColor.CGColor;
    backLayer.mask = gradientMask;
    
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [backLayer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}


+ (UIImage *)imageWithImage:(UIImage *)image locations:(NSArray *)locations opaqueValues:(NSArray *)opaques {
    
    CAGradientLayer *gradientMask = [CAGradientLayer layer];
    
    NSMutableArray *colors = @[].mutableCopy;
    
    for (NSNumber *alpha in opaques) {  // 作为遮罩不透明度正好翻转
#warning lius 需要配置颜色信息
        [colors addObject:(id)[UIColor colorWithWhite:1 alpha:alpha.floatValue].CGColor];
    }
    
    gradientMask.colors = colors;
    gradientMask.locations = locations;
    
    gradientMask.startPoint = CGPointMake(0.5, 0);  // 竖直方向上渐变
    gradientMask.endPoint = CGPointMake(0.5, 1);
    gradientMask.frame = CGRectMake(0, 0, image.size.width , image.size.height);
    
    CALayer *backLayer  = [[CALayer alloc] init];
    backLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    backLayer.mask = gradientMask;
    backLayer.contents = (__bridge id _Nullable)(image.CGImage);
    
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [backLayer renderInContext:context];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
