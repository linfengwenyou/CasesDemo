//
//  HorizenBannerViewController.m
//  TestActionDemo
//
//  Created by rayor on 2021/8/7.
//  Copyright © 2021 rayor. All rights reserved.
//

#import "HorizenBannerViewController.h"
#import "KGPLayViewVideoEntranceMainView.h"

@interface HorizenBannerViewController ()
@property (nonatomic, strong) KGPLayViewVideoEntranceMainView *entranceMainView;
@end

@implementation HorizenBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    [self.view addSubview:self.entranceMainView];
    
    [self.entranceMainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(160);
    }];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.entranceMainView refreshWithData:nil];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches
              withEvent:event];
    
}

- (KGPLayViewVideoEntranceMainView *)entranceMainView {
    if (!_entranceMainView) {
        _entranceMainView = [[KGPLayViewVideoEntranceMainView alloc] init];
        _entranceMainView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }
    return _entranceMainView;
}


@end
