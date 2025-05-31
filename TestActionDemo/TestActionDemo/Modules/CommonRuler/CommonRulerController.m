//
//  CommonRulerController.m
//  TestActionDemo
//
//  Created by Buck on 2025/5/31.
//  Copyright © 2025 rayor. All rights reserved.
//

#import "CommonRulerController.h"
#import "QCCommonRulerView.h"
#import "QCProgressCircleView.h"

@interface CommonRulerController ()
/// <#desc#>
@property(nonatomic, strong) QCCommonRulerView *heightRulerView;
@property(nonatomic, strong) QCCommonRulerView *weightRulerView;

/// <#desc#>
@property(nonatomic, strong) QCProgressCircleView *circleView;
@end

@implementation CommonRulerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.heightRulerView = [[QCCommonRulerView alloc] initWithFrame:CGRectMake(0, 110, kScreenW, 80)];
    [self.view addSubview:self.heightRulerView];
    
    
    self.weightRulerView = [[QCCommonRulerView alloc] initWithFrame:CGRectMake(0, 200, 200, 20)];
    [self.view addSubview:self.weightRulerView];
    
    // 就是一个环形进度条
    self.circleView = [[QCProgressCircleView alloc] initWithFrame:CGRectMake(0, 300, 200, 200)];
    [self.view addSubview:self.circleView];
    
    self.heightRulerView.minValue = 100;
    self.heightRulerView.maxValue = 250;
    self.heightRulerView.minimumScale = 1;
    self.heightRulerView.numberScalesOfPerMainScale = 10;
    
    self.weightRulerView.minValue = 25;
    self.weightRulerView.maxValue = 250;
    self.weightRulerView.minimumScale = 0.1;
    self.heightRulerView.numberScalesOfPerMainScale = 10;
    
    
    // 初始值
    self.weightRulerView.currentValue = 60;
    self.heightRulerView.currentValue = 160;
    
    
    [self.heightRulerView startDrawRulerView];
    [self.weightRulerView startDrawRulerView];
    
    
    @weakify(self)
    
    
    self.weightRulerView.didSelectedCurrentValue = ^(CGFloat value) {
        
        @strongify(self);
       
    };
    
    self.heightRulerView.didSelectedCurrentValue = ^(CGFloat value) {
        
        @strongify(self);
        
    };
}



@end
