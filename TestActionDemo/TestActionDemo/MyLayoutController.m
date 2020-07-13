//
//  MyLayoutController.m
//  TestActionDemo
//
//  Created by rayor on 2020/7/13.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "MyLayoutController.h"
#import <Masonry.h>

@interface MyLayoutController ()
@property (weak, nonatomic) IBOutlet UIView *yellowView;
@property (weak, nonatomic) IBOutlet UIView *blueView;

@end

@implementation MyLayoutController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.yellowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(120);
        make.left.right.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    
    
    [self.blueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.yellowView.mas_bottom);
        make.left.right.mas_equalTo(80);
        make.height.mas_equalTo(30);
    }];
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    // 只改变一个形变不会造成两个同时动画，如果需要同时动画，需要同时执行两个视图的形变一起执行
    [UIView animateWithDuration:0.25 animations:^{
        // 处理形变
        self.yellowView.transform = CGAffineTransformTranslate(self.yellowView.transform, 0, -10);
        self.blueView.transform = self.yellowView.transform;
    }];
    
}

@end
