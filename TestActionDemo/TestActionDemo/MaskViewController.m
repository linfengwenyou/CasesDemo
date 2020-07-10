//
//  MaskViewController.m
//  TestActionDemo
//
//  Created by rayor on 2020/7/10.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "MaskViewController.h"

@interface MaskViewController ()
@property (weak, nonatomic) IBOutlet UIView *myView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation MaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // 使用遮罩只是为了显示某一部分区域
    // 使用容器可以更方便的处理这些事情
    
    /* 使用遮罩还是容器：需要根据实际场景进行分析，确保找到一种何时的操作方案来进行展示 */
    
    
//    CALayer *layer = [[CALayer alloc] init];
//    layer.frame = CGRectMake(20, 50, 200, 200);
//    layer.backgroundColor = UIColor.redColor.CGColor;
//    self.myView.superview.layer.mask = layer;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    self.myView.transform = CGAffineTransformTranslate(self.myView.transform, 0, 10);
    
}

@end
