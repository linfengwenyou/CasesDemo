//
//  KGPlayViewVideoLayout.h
//  ContactBookDemo
//
//  Created by rayor on 2021/8/4.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KGVideoEntranceLayouType) {
    KGVideoEntranceLayouType_None = 0,       // 默认状态是刷新使用，包括初始化
    KGVideoEntranceLayouType_Show,           // 显示展示
    KGVideoEntranceLayouType_hide,           // 隐藏展示
};

@interface KGPlayViewVideoEntranceAttributes : UICollectionViewLayoutAttributes
@property (nonatomic, assign) CGFloat coverAlpha;
@end


@interface KGPlayViewVideoEntranceListLayout : UICollectionViewFlowLayout

/*通过修改 sectionInset 属性的left来实现最大显示的视图，距离屏幕左边的距离;
 由于有最大最小情况，那么在设置Left时，会自动计算right,确保最后一个元素能达到最大的位置
 */
@property (nonatomic, assign) CGFloat leftPadding;

/* 两个item中间的距离, 由于视图进行了缩小处理，会导致本身为0的间距会变大为更大空间，
 * 这个值是用来计算找到合适的offsetX来调整itme的间距展示
 */
@property (nonatomic, assign) CGFloat itemPadding;

/*预处理机制*/
- (void)prepareForShowType:(KGVideoEntranceLayouType)ype;

/*刷新布局做动画*/
- (void)refreshLayoutForShow:(KGVideoEntranceLayouType)type;

@property (nonatomic, assign) CGPoint fromPoint;

@property (nonatomic, strong, readonly) NSArray *visibleSortedIndex;

/* 定制两个cell横向间距的方法：
 * minimumLineSpacing , 设置这个量，相当于增加两个Cell之间横向的间距，均增加
 * 示例如： a A a a a               A 代表当前最大展示，即不缩小， a为缩小到最小标准
 * 需要注意的是，已有间距 A a 之间的间距  disAa = (最大宽 - 最小宽) / 2 + minimumLineSpacing;
 *
 * a a 之间的间距为 disaa  = 2 * disAa + minimumLineSpacing   如果设置了 itemPadding 则disaa = itemPadding + minimumLineSpacing
 *
 * 如果itemPadding 为固定 aa之间的距离
 *
 * 如果需要调整 A a 距离，可以通过minimumLineSpacing来调整
 */



/*如果需要对cell做动画：
 1. 调用 invalidateLayout
 
 2. 重新加载所需要的indexPath或performBatchUpudates块中所有的数据
 collectionView.performBatchUpdates {
 self.collectionview.reload()
 }
 
 3. 返回sizeForItemAtIndexPath: 委托方法计算出新的位置尺寸信息
 
 */


@end
