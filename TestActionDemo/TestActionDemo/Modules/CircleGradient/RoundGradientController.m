//
//  CircleGradientController.m
//  TestActionDemo
//
//  Created by rayor on 2021/5/26.
//  Copyright © 2021 rayor. All rights reserved.
//

#import "RoundGradientController.h"
#import "RoundGradientLayer.h"

@interface RoundGradientController ()

@end

@implementation RoundGradientController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 红色的底部视图
    CALayer *redLayer = [CALayer layer];
    redLayer.backgroundColor = UIColor.redColor.CGColor;
    redLayer.frame = CGRectMake(100, 200, 200, 200);
    
    
    CGRect frame = CGRectMake(0, 0, 200, 200);
    
    CGFloat locations[] = {0.f, 0.5f,1.0f};
    NSArray *color = @[(__bridge id)[UIColor.blueColor colorWithAlphaComponent:0].CGColor,
                       (__bridge id)[UIColor.blueColor colorWithAlphaComponent:0].CGColor,
                       (__bridge id)UIColor.blueColor.CGColor];
    
    RoundGradientLayer *layer = [RoundGradientLayer createGradientLayerWithFrame:frame locations:locations colors:color];
    
    layer.masksToBounds = YES;
    layer.cornerRadius = 100;
    
    redLayer.mask = layer;
    [self.view.layer addSublayer:redLayer];
    
    // 注意Layer是作为独立图层展示，还是作为遮罩进行展示的
    
    
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

@end
