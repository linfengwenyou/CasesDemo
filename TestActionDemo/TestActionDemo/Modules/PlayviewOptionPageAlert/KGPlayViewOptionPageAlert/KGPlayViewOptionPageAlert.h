//
//  KGPlayViewOptionPageAlert.h
//  ContactBookDemo
//
//  Created by rayor on 2022/2/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGPlayViewOptionPageAlert : UIView

/** 从指定位置开始弹出, 注意，位置是相对mainScreen.bounds的 */
- (void)showWithTopPoint:(CGPoint)point;


@end

NS_ASSUME_NONNULL_END
