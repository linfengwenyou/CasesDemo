//
//  StarRateController.m
//  TestActionDemo
//
//  Created by Buck on 2025/5/31.
//  Copyright © 2025 rayor. All rights reserved.
//

#import "StarRateController.h"
#import "RAYStarRateView.h"


@interface StarRateController ()

@property(nonatomic, strong) RAYStarRateView *rateView;


@end

@implementation StarRateController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    self.rateView = [[RAYStarRateView alloc] initWithFrame:CGRectMake(0, 160, kScreenW, 50) numberOfStar:5 rateStyle:DRStarRateViewRateStyeHalfStar isAnimation:YES completion:^(CGFloat currentScore) {
        NSLog(@"当前的评分:%.2f",currentScore);
    }];
    self.rateView.currentRating = 3.5f;
    [self.view addSubview:self.rateView];
    
}

@end
