//
//  MySlideViewController.m
//  TestActionDemo
//
//  Created by rayor on 2020/10/22.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "MySlideViewController.h"
#import <Masonry/Masonry.h>
#import "MyDynamicSliderView.h"

@interface MySlideViewController ()

@end

@implementation MySlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyDynamicSliderView *slideView = [[MyDynamicSliderView alloc] initWithFrame:CGRectZero anchors:@[@"轻度",@"柔和",@"标准",@"强烈"]];
    [self.view addSubview:slideView];
    
    [slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(200);
    }];
    
    
    MyDynamicSliderView *slideView1 = [[MyDynamicSliderView alloc] initWithFrame:CGRectZero anchors:@[@"轻度",@"柔和",@"标准",@"强烈",@"猛烈",@"优雅"]];
    [self.view addSubview:slideView1];
    
    [slideView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(200);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(200);
    }];
}

@end
