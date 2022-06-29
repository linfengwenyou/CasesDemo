//
//  KGPlayViewTrumpetMenuView.h
//  DynamicDemo
//
//  Created by rayor on 2022/4/1.
//  Copyright © 2022 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGPlayViewTrumpetMenuView : UIView

@property(nonatomic, copy) NSString *title;
/* 设置是否选中 */
@property (nonatomic,assign) BOOL selected;
@property (nonatomic, strong) UIImage *picImage;


@property (nonatomic, copy) void(^didTapViewAction)(void);

@end

NS_ASSUME_NONNULL_END
