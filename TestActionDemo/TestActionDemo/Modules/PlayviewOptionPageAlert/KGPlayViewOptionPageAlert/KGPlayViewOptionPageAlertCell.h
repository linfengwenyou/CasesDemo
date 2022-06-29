//
//  KGPlayViewOptionPageAlertCell.h
//  ContactBookDemo
//
//  Created by rayor on 2022/2/24.
//

#import <UIKit/UIKit.h>
#import "KGPlayViewOptionPageConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface KGPlayViewOptionPageAlertCell : UICollectionViewCell

// 页面类型
@property (nonatomic, assign) KGPlayViewOptionType optionType;

- (void)updateStateWithAnimation:(BOOL)animate;
@end

NS_ASSUME_NONNULL_END
