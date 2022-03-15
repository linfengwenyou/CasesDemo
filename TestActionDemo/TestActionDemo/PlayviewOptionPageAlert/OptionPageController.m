//
//  OptionPageController.m
//  TestActionDemo
//
//  Created by rayor on 2022/3/15.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "OptionPageController.h"

#import "KGPlayViewOptionPageAlert.h"
#import "KGPlayViewOptionGuideView.h"

@interface OptionPageController ()
@property (nonatomic, strong) KGPlayViewOptionPageAlert *alert;

// 引导视图
@property (nonatomic, strong) KGPlayViewOptionGuideView *guideView;
@end

@implementation OptionPageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches
              withEvent:event];
    
    
    
    CGPoint point = [[touches anyObject] locationInView:[UIApplication sharedApplication].keyWindow];
    CGPoint showPoint = CGPointMake(point.x, point.y + 30);
    
    if (point.y > self.view.frame.size.height / 2.0f) {
        
        
        [self.guideView showWithTopPoint:showPoint];    // 显示引导视图
    } else {
        [self.alert showWithTopPoint:showPoint];    // 显示弹层视图
    }
    
}



- (KGPlayViewOptionPageAlert *)alert {
    if (!_alert) {
        _alert = [[KGPlayViewOptionPageAlert alloc] init];
    }
    return _alert;
}


- (KGPlayViewOptionGuideView *)guideView {
    if (!_guideView) {
        _guideView = [KGPlayViewOptionGuideView new];
    }
    return _guideView;
}

@end
