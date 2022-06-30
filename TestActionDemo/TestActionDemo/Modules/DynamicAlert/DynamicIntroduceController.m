//
//  DynamicIntroduceController.m
//  TestActionDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "DynamicIntroduceController.h"

#import "KGDynamicIntroduceAlert.h"
#import "KGDynamicMenuView.h"
#import "MyDynamicSliderView.h"
#import "KGDynamicVipTipView.h"
#import "KGDynamicVipAlertView.h"
#import "KGDynamicIntroduceAlert.h"
#import "KGPlayViewBackModeAlert.h"
#import "KGPlayViewTrumpetAlert.h"
#import "KGDynamicGuideAlert.h"
#import "KGLyricEffectIntroduceAlert.h"


@interface DynamicIntroduceController ()

@property (nonatomic, strong) KGDynamicMenuView *menuView;
@property (nonatomic, strong) KGDynamicIntroduceAlert *alert;
@property (nonatomic, strong) KGPlayViewBackModeAlert *backModeAlert;

@property (nonatomic, strong) KGDynamicGuideAlert *guidAlert;

@property (nonatomic, strong) KGPlayViewTrumpetAlert *trumpetAlert;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) KGLyricEffectIntroduceAlert *lyricAlert;
@end

@implementation DynamicIntroduceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 显示滑块视图
    [self showMySliderView];
    
    // 显示VIP提示条
}



- (IBAction)didClickButton:(UIButton *)sender {
    [self.backModeAlert showWithShrinkedFrame:frameFromCenterSize(sender.center, CGSizeZero)];
 }

// 律动
- (IBAction)didClickTrumpet:(UIButton *)sender {
    [self.trumpetAlert  showWithShrinkedFrame:frameFromCenterSize(sender.center, CGSizeZero)];
}

- (IBAction)didClickAlertAction:(UIButton *)sender {
    [self.alert showWithShrinkedFrame:frameFromCenterSize(sender.center, CGSizeZero)];
}

- (IBAction)didClickLyricEffect:(UIButton *)sender {
    [self.lyricAlert showWithShrinkedFrame:frameFromCenterSize(sender.center, CGSizeZero)];
}

- (IBAction)didClickMenu:(UIButton *)sender {
        [self.menuView showWithAnimation];
}

- (IBAction)didClickGuideAction:(UIButton *)sender {
    [self.guidAlert show];
}

- (void)showMySliderView {
    MyDynamicSliderView *slideView = [[MyDynamicSliderView alloc] initWithFrame:CGRectZero anchors:@[@"轻度",@"柔和",@"标准",@"强烈"]];
    [self.view addSubview:slideView];
    
    [slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(200);
    }];
    
    
    MyDynamicSliderView *slideView1 = [[MyDynamicSliderView alloc] initWithFrame:CGRectZero anchors:@[@"轻度",@"柔和",@"标准",@"强烈",@"猛烈",@"优雅"]];
    [self.view addSubview:slideView1];
    
    [slideView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(200);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(200);
    }];
}

- (void)showVipTipView {
    KGDynamicVipTipView *tipView = [[KGDynamicVipTipView alloc] init];
    [self.view addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(100);
        make.height.mas_equalTo(32);
    }];
    tipView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    tipView.layer.cornerRadius = 16;
    [tipView.layer masksToBounds];
    
    [tipView startTimer];
    
    
    tipView.didTapVipTipViewAction = ^{
        NSLog(@"点击vipTipView");
    };
    
    tipView.didFinishTimerAction =  ^{
        NSLog(@"事件结束");
        KGDynamicVipAlertView *alertView = [[KGDynamicVipAlertView alloc] init];
        [alertView show];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (alertView.superview == nil) {
                [self showVipTipView];
            }
        });
    };
    
}
#pragma mark - setter & getter

- (KGDynamicMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[KGDynamicMenuView alloc] initWithShrinkedFrame:frameFromCenterSize(self.button.center, CGSizeZero)];
        _menuView.selectSkinBlock = ^(NSString * _Nonnull skinId) {
            NSLog(@"skinid:%@",skinId);
        };
        
        _menuView.selectIntensityBlock = ^(NSInteger index) {
            NSLog(@"选中强度为：%d",index);
        };
        
        _menuView.selectSpeedBlock = ^(NSInteger index) {
            NSLog(@"选中速度：%d",index);
        };
    }
    return _menuView;
}



- (KGDynamicIntroduceAlert *)alert {
    if (!_alert) {
        _alert = [[KGDynamicIntroduceAlert alloc] init];
    }
    return _alert;
}


- (KGPlayViewBackModeAlert *)backModeAlert {
    if (!_backModeAlert) {
        _backModeAlert = [[KGPlayViewBackModeAlert alloc] init];
    }
    return _backModeAlert;
}


- (KGDynamicGuideAlert *)guidAlert {
    if (!_guidAlert) {
        _guidAlert = [KGDynamicGuideAlert new];
    }
    return _guidAlert;
}

- (KGPlayViewTrumpetAlert *)trumpetAlert {
    if (!_trumpetAlert) {
        _trumpetAlert = [KGPlayViewTrumpetAlert new];
    }
    return _trumpetAlert;
}
// 歌词动效使用
- (KGLyricEffectIntroduceAlert *)lyricAlert {
    if (!_lyricAlert) {
        _lyricAlert = [KGLyricEffectIntroduceAlert new];
        _lyricAlert.dismissFrame = CGRectMake(200, 100, 20, 20);
    }
    return _lyricAlert;
}
@end
