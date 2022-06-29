//
//  RippleAnmationController.m
//  TestActionDemo
//
//  Created by rayor on 2020/8/26.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "RippleAnmationController.h"
#import "RippleAnimationView.h"

@interface RippleAnmationController ()<CAAnimationDelegate>
@property (weak, nonatomic) IBOutlet UIButton *mybutton;

@property (nonatomic, strong) RippleAnimationView *pulsView;

@end

@implementation RippleAnmationController


- (void)viewDidLoad {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect frame = [self.mybutton convertRect:self.mybutton.bounds toView:self.view];
    
    
    RippleAnimationView *view = [[RippleAnimationView alloc] initWithFrame:frame];
    view.enlargeRate = 2;
    [self.view addSubview:view];
    self.pulsView = view;
}


- (IBAction)didClickAction:(id)sender {
    
    NSLog(@"点击测试按钮");
    
    [self.pulsView removeFromSuperview];
    
}


@end
