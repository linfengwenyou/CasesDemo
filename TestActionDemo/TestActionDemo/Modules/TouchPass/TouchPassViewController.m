//
//  TouchPassViewController.m
//  TestActionDemo
//
//  Created by rayor on 2020/7/9.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "TouchPassViewController.h"
#import "MyCoverView.h"

@interface TouchPassViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet MyCoverView *coverView1;
@end

@implementation TouchPassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)touchButtonAction:(id)sender {
    NSLog(@"点击按钮触发事件1");
    
}
- (IBAction)didTapViewAction:(id)sender {
    NSLog(@"点击了按钮测试2");
}

- (IBAction)didClickInnerButton:(id)sender {
    NSLog(@"点击了内层视图3");
}

@end
