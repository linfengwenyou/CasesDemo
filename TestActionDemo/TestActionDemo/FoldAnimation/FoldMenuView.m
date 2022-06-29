//
//  FoldMenuView.m
//  TestActionDemo
//
//  Created by rayor on 2020/10/22.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "FoldMenuView.h"


// 主视图信息
#define pMainViewHeight 286.0f
#define pMainViewLeftRightPadding 17.5f
#define pMainViewBottomPadding 58.0f


@interface FoldMenuView ()

// 缩小后的位置所在
@property (nonatomic,assign) CGRect shrinkedFrame;

// 正常展示的位置所在
@property (nonatomic,assign) CGRect normalFrame;

// 容器视图
@property (nonatomic, strong) UIView *mainView;

@end

@implementation FoldMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat width =[UIScreen mainScreen].bounds.size.width - 2 * pMainViewLeftRightPadding;
        CGFloat y = [UIScreen mainScreen].bounds.size.height - pMainViewHeight - pMainViewBottomPadding;
        
        self.normalFrame = CGRectMake(pMainViewLeftRightPadding , y , width, pMainViewHeight);
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.mainView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 100)];
    textLabel.textColor = UIColor.whiteColor;
    [textLabel setFont:[UIFont systemFontOfSize:14]];
    textLabel.text = @"可以跟着一起放缩";
    [self.mainView addSubview:textLabel];
}

#pragma mark - 显示隐藏动画效果
- (void)showWithAnimationWithShrnkedFrame:(CGRect)shrinkedFrame {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.shrinkedFrame = shrinkedFrame;
    
    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
    self.mainView.transform = CGAffineTransformMakeScale(0.001f,0.001f);
    self.mainView.center = shrinkedCenter;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.transform = CGAffineTransformIdentity;
        self.mainView.center = normalCenter;
    }];
    
}

// 点击空白区域需要隐藏
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.mainView.frame, point)) {
        [self dismissWithAnimation];
    }
}

- (void)dismissWithAnimation {
    
    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
    self.mainView.transform = CGAffineTransformIdentity;
    self.mainView.center = normalCenter;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.mainView.transform = CGAffineTransformMakeScale(0.001f,0.001f);
        self.mainView.center = shrinkedCenter;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}



#pragma mark - setter & getter
- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:self.normalFrame];
        _mainView.backgroundColor = [UIColor blackColor];
        _mainView.layer.cornerRadius = 12.0f;
        _mainView.clipsToBounds = YES;
    }
    return _mainView;
}


@end
