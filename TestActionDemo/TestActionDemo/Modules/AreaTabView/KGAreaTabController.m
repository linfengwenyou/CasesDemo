//
//  KGAreaTabController.m
//  TestActionDemo
//
//  Created by rayor on 2022/6/10.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "KGAreaTabController.h"

#import "KGPlayQueueTabView.h"

@interface KGAreaTabController ()

@property (nonatomic, strong) KGPlayQueueTabView *tabView;
@end

@implementation KGAreaTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tabView = [[KGPlayQueueTabView alloc] init];
    
    
    [self.view addSubview:self.tabView];
    [self.tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(120);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(35);
    }];
    
    NSArray *tmp = @[@"在听", @"历史1",@"历史2"];//,@"历史3",@"历史4", @"历史5",@"历史6",@"历史7",@"历史8"];
    
    __weak typeof(self) weakSelf = self;
    self.tabView.currentSelectAction = ^{
        NSInteger index = weakSelf.tabView.selectIndex;
        //        [weakSelf didSelectAction:index];
    };
    [self.tabView updateWithItems:tmp defaultIndex:0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    //此处处理顶部圆角
    CGFloat radius = 10;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.tabView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    self.tabView.layer.mask = layer;
    
    
}

- (void)didSelectAction:(NSInteger)index {
}

@end
