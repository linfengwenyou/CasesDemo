//
//  KGPlayQueueTabCell.h
//  KGAreaSelectDemo
//
//  Created by rayor on 2022/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGPlayQueueTabCell : UICollectionViewCell

/// 标签名称
@property (nonatomic, copy) NSString *name;

/// 是否显示线条
@property (nonatomic, assign) BOOL showLine;

@property (nonatomic, assign) BOOL currentSelect;
@end

NS_ASSUME_NONNULL_END
