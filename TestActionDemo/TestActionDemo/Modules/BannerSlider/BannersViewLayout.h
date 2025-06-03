//
//  BannersViewLayout.h
//  TestActionDemo
//
//  Created by Buck on 2025/6/2.
//  Copyright © 2025 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface BannersViewLayout : UICollectionViewFlowLayout

@property(nonatomic, assign) NSInteger defaultIndex;

@property (nonatomic, assign) CGFloat leftPadding;

@property (nonatomic, assign) CGFloat itemPadding;


- (CGPoint)contentXForScrollToIndex:(NSInteger)index;
// 初始化布局更新
- (void)updateContentOffsetXForIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
