//
//  FrameObserverController.m
//  TestActionDemo
//
//  Created by rayor on 2020/7/9.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "FrameObserverController.h"
#import <Masonry/Masonry.h>

@interface FrameObserverController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation FrameObserverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addObserver];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
    }];
}

static void * frameObserve = &frameObserve;
- (void)addObserver {
    
    [self.containerView addObserver:self forKeyPath:@"layer.position" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:frameObserve];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (context != frameObserve) {
        return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
    
    NSLog(@"%@",object);
    
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGFloat width = arc4random() % (int)self.view.bounds.size.width;
    CGFloat height = arc4random() % (int)self.view.bounds.size.height;
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(height);
    }];
    NSLog(@"更新了一次布局信息");
}



@end
