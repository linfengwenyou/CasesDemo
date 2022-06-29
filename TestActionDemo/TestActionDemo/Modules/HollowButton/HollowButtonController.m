//
//  HollowButtonController.m
//  TestActionDemo
//
//  Created by rayor on 2021/3/23.
//  Copyright © 2021 rayor. All rights reserved.
//

#import "HollowButtonController.h"
#import "HollowButton.h"

@interface HollowButtonController ()

@end

@implementation HollowButtonController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self crateSubViews];
}


- (void)crateSubViews {
    for (int i = 0; i< 10 ; i++) {
        @autoreleasepool {
            // 构建一个按钮
            HollowButton *view = [[HollowButton alloc] initWithFrame:CGRectMake(100, 80+ 60 * (i + 1), 200, 50)];
            NSString *title = [NSString stringWithFormat:@"测试数据一番:%d",i];
            [view setTitle:title forState:UIControlStateNormal];
            view.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
            UIColor *randomColor = [[UIColor alloc] initWithRed:arc4random() %255/255.0 green:arc4random() %255/255.0 blue:arc4random() %255/255.0 alpha:1];
            view.backgroundColor = randomColor;
            
            UIImage *image = [UIImage imageNamed:@"1"];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            
            [view setImage:image forState:UIControlStateNormal];
            view.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
            
            view.tintColor = [UIColor yellowColor];
            
            [self.view addSubview:view];
        }
    }
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UIColor *randomColor = [[UIColor alloc] initWithRed:arc4random() %255/255.0 green:arc4random() %255/255.0 blue:arc4random() %255/255.0 alpha:1];
    self.view.backgroundColor = randomColor;
    
    
    // 更新title信息
    for (UIButton *subView in self.view.subviews) {
        @autoreleasepool {
            if ([subView isKindOfClass:[UIButton class]]) {
                NSString *text = [NSString stringWithFormat:@"测试数据%ld",arc4random()%10];
                [subView setTitle:text forState:UIControlStateNormal];
            }
        }
    }
    
}


@end
