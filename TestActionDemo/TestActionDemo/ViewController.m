//
//  ViewController.m
//  TestActionDemo
//
//  Created by rayor on 2020/7/2.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "ViewController.h"
#import "ViewShowManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    [self.view addGestureRecognizer:tap];
}

- (void)gestureAction:(UITapGestureRecognizer *)gesture {
    NSLog(@"执行手势事件");
    
    ViewShowManager *manager = [ViewShowManager new];
    [manager showActionDescription];
    
}


@end
