//
//  ViewHiracyController.m
//  TestActionDemo
//
//  Created by rayor on 2020/7/10.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "ViewHiracyController.h"

@interface ViewHiracyController ()
@property (weak, nonatomic) IBOutlet UIView *container1;
@property (weak, nonatomic) IBOutlet UIView *container2;

@end

@implementation ViewHiracyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
    myLabel.textColor = [UIColor blackColor];
    myLabel.text = @"测试数据展示";
    
    // insert subView的方式
    /*
     1. 如果在当前receiver子视图中发现 siblingView，那么就按照要求在其前后插入视图
     2. 如果在当前receiver子视图中未发现siblingView，那么久直接插入到尾部
     
     3. 当碰到需要某一部分视图展示在顶部时，可以构建容器，让容器只响应子空间事件，其他事件直接透传
     */
    
    
//    [self.container1 insertSubview:myLabel aboveSubview:self.container2];
//    [self.view insertSubview:myLabel aboveSubview:self.container2];
    
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    redView.backgroundColor = UIColor.redColor;
//    [self.container2 addSubview:redView];
    
    [self.container1 addSubview:redView];
    [self.container2 insertSubview:myLabel aboveSubview:redView];
    
//    [self.container2 insertSubview:redView aboveSubview:myLabel];
    
}

@end
