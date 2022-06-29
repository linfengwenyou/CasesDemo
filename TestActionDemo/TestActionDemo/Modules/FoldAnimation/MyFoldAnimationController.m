//
//  MyFoldAnimationController.m
//  TestActionDemo
//
//  Created by rayor on 2020/10/22.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "MyFoldAnimationController.h"
#import "FoldMenuView.h"

@interface MyFoldAnimationController ()
@property (nonatomic, strong) FoldMenuView *menuView;
@end

@implementation MyFoldAnimationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"可以一起放缩调整";
}

- (IBAction)popAnimationAction:(UIButton *)sender {
    [self.menuView showWithAnimationWithShrnkedFrame:frameFromCenterSize(sender.center, CGSizeZero)];
}

- (FoldMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[FoldMenuView alloc] initWithFrame:CGRectZero];
    }
    return _menuView;
}

@end
