//
//  BannerController.m
//  TestActionDemo
//
//  Created by Buck on 2025/6/2.
//  Copyright © 2025 rayor. All rights reserved.
//

#import "BannerController.h"
#import "BannersView.h"

@interface BannerController ()

@property (nonatomic, strong) BannersView *entranceMainView;
@end

@implementation BannerController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self.view addSubview:self.entranceMainView];
    CGFloat width = kScreenW - 2*40;
    CGFloat height =  kScreenW / width * 405;
    CGFloat leftPadding = 10;
    
    [self.entranceMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
 
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
 
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.entranceMainView showContainer];
//    [self.entranceMainView refreshWithData:nil];
  
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches
              withEvent:event];
    
}

- (BannersView *)entranceMainView {
    if (!_entranceMainView) {
        _entranceMainView = [[BannersView alloc] init];
//        _entranceMainView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    return _entranceMainView;
}


@end
