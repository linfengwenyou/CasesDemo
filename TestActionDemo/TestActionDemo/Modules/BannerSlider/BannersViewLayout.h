//
//  BannersViewLayout.h
//  TestActionDemo
//
//  Created by Buck on 2025/6/2.
//  Copyright © 2025 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BannersViewLayoutAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, assign) CGFloat coverAlpha;
@end


@interface BannersViewLayout : UICollectionViewFlowLayout

/*通过修改 sectionInset 属性的left来实现最大显示的视图，距离屏幕左边的距离;
 由于有最大最小情况，那么在设置Left时，会自动计算right,确保最后一个元素能达到最大的位置
 */
@property (nonatomic, assign) CGFloat leftPadding;

/// 放缩后要求展示间距
@property (nonatomic, assign) CGFloat itemPadding;
@end

NS_ASSUME_NONNULL_END
