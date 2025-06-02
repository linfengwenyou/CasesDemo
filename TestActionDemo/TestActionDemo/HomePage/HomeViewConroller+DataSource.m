//
//  HomeViewConroller+DataSource.m
//  TestActionDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "HomeViewConroller+DataSource.h"

@implementation HomeViewConroller (DataSource)

+ (NSArray<HomeViewDataModel *> *)homeViewModelArray {
    
    NSMutableArray *tmpArr = @[].mutableCopy;
    
    // 图片遮罩
    HomeViewDataModel *model = [HomeViewDataModel dataModelWithTitle:@"图片遮罩" className:@"MaskViewController"];
    [tmpArr addObject:model];
    
    // 图片渐变
    HomeViewDataModel *gradient = [HomeViewDataModel dataModelWithTitle:@"图片渐变" className:@"GradientViewController"];
    [tmpArr addObject:gradient];
    
    // frame 监听
    HomeViewDataModel *framObserve = [HomeViewDataModel dataModelWithTitle:@"Frame监听" className:@"FrameObserverController"];
    [tmpArr addObject:framObserve];
    
    // 事件透传
    HomeViewDataModel *touchPass = [HomeViewDataModel dataModelWithTitle:@"事件透传" className:@"TouchPassViewController"];
    [tmpArr addObject:touchPass];
    
    // 视图层级
    HomeViewDataModel *viewHiracy = [HomeViewDataModel dataModelWithTitle:@"视图层级" className:@"ViewHiracyController"];
    [tmpArr addObject:viewHiracy];
    
    // 布局动画
    HomeViewDataModel *layoutAnimation = [HomeViewDataModel dataModelWithTitle:@"布局动画" className:@"MyLayoutController"];
    [tmpArr addObject:layoutAnimation];
    
    // 遮罩动画
    HomeViewDataModel *maskAnimation = [HomeViewDataModel dataModelWithTitle:@"遮罩动画" className:@"MaskAnimateController"];
    [tmpArr addObject:maskAnimation];
    
    // 脉冲动画
    HomeViewDataModel *rippleAnimation = [HomeViewDataModel dataModelWithTitle:@"脉冲动画" className:@"RippleAnmationController"];
    [tmpArr addObject:rippleAnimation];
    
    // 渐变图像
    HomeViewDataModel *gradientImage = [HomeViewDataModel dataModelWithTitle:@"渐变图像" className:@"GradientImageController"];
    [tmpArr addObject:gradientImage];
    
    // 翻转帧动画处理
    HomeViewDataModel *frameAnimation = [HomeViewDataModel dataModelWithTitle:@"翻转帧动画" className:@"FrameAnimationController"];
    [tmpArr addObject:frameAnimation];
    
    // 动感写真相关弹窗
    HomeViewDataModel *dynamicRelate = [HomeViewDataModel dataModelWithTitle:@"动感写真" className:@"DynamicIntroduceController"];
    [tmpArr addObject:dynamicRelate];
    
    // 通用弹层容器
    HomeViewDataModel *commonAlert = [HomeViewDataModel dataModelWithTitle:@"通用弹窗" className:@"MyFoldAnimationController"];
    [tmpArr addObject:commonAlert];
    
    // 图片切换过渡
    HomeViewDataModel *imageEase = [HomeViewDataModel dataModelWithTitle:@"图片渐变切换" className:@"RASwitchImageController"];
    [tmpArr addObject:imageEase];
    
    // 按钮镂空
    HomeViewDataModel *hallowButton = [HomeViewDataModel dataModelWithTitle:@"按钮镂空" className:@"HollowButtonController"];
    [tmpArr addObject:hallowButton];
    
    // 环内渐变
    HomeViewDataModel *circleGradient = [HomeViewDataModel dataModelWithTitle:@"环内渐变" className:@"RoundGradientController"];
    [tmpArr addObject:circleGradient];
    
    // 水平Banner
    HomeViewDataModel *horizenBanner = [HomeViewDataModel dataModelWithTitle:@"水平Banner" className:@"HorizenBannerViewController"];
    [tmpArr addObject:horizenBanner];
    
    // 场景弹层动画, 播放页场景模式
    HomeViewDataModel *scenenAlert = [HomeViewDataModel dataModelWithTitle:@"播放页场景" className:@"OptionPageController"];
    [tmpArr addObject:scenenAlert];
    
    // 区域滑块，播放队列
    HomeViewDataModel *sliderArea = [HomeViewDataModel dataModelWithTitle:@"区域滑块" className:@"KGAreaTabController"];
    [tmpArr addObject:sliderArea];
    
    // 通用尺子类型
    HomeViewDataModel *ruleModel = [HomeViewDataModel dataModelWithTitle:@"通用尺子" className:@"CommonRulerController"];
    [tmpArr addObject:ruleModel];
    
    // 星星评分
    HomeViewDataModel *rateModel = [HomeViewDataModel dataModelWithTitle:@"星星评分" className:@"StarRateController"];
    [tmpArr addObject:rateModel];
    
    // 横向banner
    HomeViewDataModel *bannerModel = [HomeViewDataModel dataModelWithTitle:@"放缩Banner" className:@"BannerController"];
    [tmpArr addObject:bannerModel];
    
    return tmpArr;
}

// 图片遮罩


@end
