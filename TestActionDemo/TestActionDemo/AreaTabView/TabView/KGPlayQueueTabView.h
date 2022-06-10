//
//  KGPlayQueueTabView.h
//  KGAreaSelectDemo
//
//  Created by rayor on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGPlayQueueTabView : UIView

/// 当前选中的索引
@property (nonatomic, assign, readonly) NSInteger selectIndex;


/*当前选中操作*/
@property (nonatomic, copy) void (^currentSelectAction)(void);


/// 更新整体配置项，同时标记默认选中第几个
/// @param items 选项
/// @param index 当前选中的索引
- (void)updateWithItems:(NSArray *)items defaultIndex:(NSInteger)index;


/// 更新当前选中的选项
/// @param index 当前选中索引
- (void)updateCurrentSelectIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
