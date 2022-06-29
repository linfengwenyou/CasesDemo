//
//  KGDynammicVipAlertView.h
//  DynamicDemo
//
//  Created by rayor on 2020/10/25.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGDynamicVipAlertView : UIView

@property (nonatomic, copy) void(^didTapVipAction)(void);
@property (nonatomic, copy) void(^didTapRetryAction)(void);

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
