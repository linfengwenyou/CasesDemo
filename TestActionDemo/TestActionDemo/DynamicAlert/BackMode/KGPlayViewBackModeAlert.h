//
//  KGPlayViewBackModeAlert.h
//  DynamicDemo
//
//  Created by rayor on 2021/9/29.
//  Copyright © 2021 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

/*背景模式的弹框选择页, 需要从指定位置弹出效果来操作拓展*/
@interface KGPlayViewBackModeAlert : UIView

/*从某个位置显示出来*/
- (void)showWithShrinkedFrame:(CGRect)shrinkedFrame;
@end
