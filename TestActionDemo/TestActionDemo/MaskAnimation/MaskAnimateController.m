//
//  MaskAnimateController.m
//  TestActionDemo
//
//  Created by rayor on 2020/8/25.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "MaskAnimateController.h"

@interface MaskAnimateController ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (nonatomic, strong) CALayer *picMaskLayer;
@end

@implementation MaskAnimateController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.blueColor;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches
              withEvent:event];
    
}

- (IBAction)didTapAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.picView.layer.mask = self.picMaskLayer;
        return;
    }
    [self startWithBasicAnimation];
}


- (void)startWithBasicAnimation {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    self.picMaskLayer.frame = CGRectMake(0, -height, width, 2*height);
    self.picView.layer.mask = self.picMaskLayer;
    
    
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.translation.y";
    animation.fromValue = @(0);
    animation.toValue = @(height);
    animation.duration = 0.25;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    [self.picMaskLayer addAnimation:animation forKey:@"keyPath"];
    
}



- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.picView.layer.mask = nil;
}


- (CALayer *)picMaskLayer {
    if (!_picMaskLayer) {
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        // 设置渐变图层
        CAGradientLayer *gradientMask = [CAGradientLayer layer];
        gradientMask.frame = CGRectMake(0, 0, width, 2*height);
        gradientMask.colors = @[(id)[UIColor whiteColor].CGColor,
                                (id)[UIColor whiteColor].CGColor,
                                (id)[UIColor clearColor].CGColor,
                                (id)[UIColor clearColor].CGColor,
        ];
        
        gradientMask.locations = @[@0,@0.5,@0.65,@1];
        
        gradientMask.startPoint = CGPointMake(0.5, 0);  // 竖直方向上渐变
        gradientMask.endPoint = CGPointMake(0.5, 1);
        _picMaskLayer = gradientMask;
    }
    return _picMaskLayer;
    
}

@end
