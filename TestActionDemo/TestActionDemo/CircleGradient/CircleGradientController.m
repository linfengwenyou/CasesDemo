//
//  CircleGradientController.m
//  TestActionDemo
//
//  Created by rayor on 2021/5/26.
//  Copyright © 2021 rayor. All rights reserved.
//

#import "CircleGradientController.h"

@interface CircleGradientController ()

@end

@implementation CircleGradientController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 红色的底部视图
    CALayer *redLayer = [CALayer layer];
    redLayer.backgroundColor = UIColor.redColor.CGColor;
    redLayer.frame = CGRectMake(100, 100, 200, 200);
    
    
    // 创建遮罩， 会显示出redLayer边缘的部分
    CALayer *layer = [CALayer layer];
    layer.frame = redLayer.bounds;
    layer.cornerRadius = redLayer.bounds.size.width / 2.0f;
    layer.masksToBounds = YES;
    layer.contents = (__bridge id)[self circleImageWithSize:redLayer.bounds.size].CGImage;
    
    redLayer.mask = layer;
    
    [self.view.layer addSublayer:redLayer];
    
    
    // 动画改变底部红色效果
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"backgroundColor";
    anim.values = @[(id)UIColor.redColor.CGColor,
                    (id)UIColor.blueColor.CGColor,
                    (id)UIColor.yellowColor.CGColor
    ];
    anim.duration = 0.3f;
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = YES;
    
    [redLayer addAnimation:anim forKey:nil];

    
}


// 绘制一个圆形的图片，这个是个圆，从中心到边会有渐变
- (UIImage *)circleImageWithSize:(CGSize)size {
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 创建路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, size.width, size.height)];
    
    
    CGFloat locations[] = {0.f, 0.5f,1.0f};
    
    // 绘制路径
    [self drawRadialGradient:ctx
                        path:path.CGPath
                      colors:@[(__bridge id)[UIColor.redColor colorWithAlphaComponent:0].CGColor,
                               (__bridge id)[UIColor.redColor colorWithAlphaComponent:0].CGColor,
                               (__bridge id)UIColor.redColor.CGColor
                      ] locations:locations
     ];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)drawRadialGradient:(CGContextRef)context path:(CGPathRef)path colors:(NSArray *)colors locations:(CGFloat[])locations
{
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat locations[] = {0.f, 1.f};
    
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge  CFArrayRef)colors, locations);
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0f, pathRect.size.height / 2.0f) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    
    CGColorSpaceRelease(colorSpace);
    
}

@end
