//
//  FoldMenuView.h
//  TestActionDemo
//
//  Created by rayor on 2020/10/22.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FoldMenuView : UIView


// 显示动画，隐藏动画不开放出来，因为隐藏只由此空间自己控制不由外部控制
- (void)showWithAnimationWithShrnkedFrame:(CGRect)shrinkedFrame;


@end

NS_ASSUME_NONNULL_END
