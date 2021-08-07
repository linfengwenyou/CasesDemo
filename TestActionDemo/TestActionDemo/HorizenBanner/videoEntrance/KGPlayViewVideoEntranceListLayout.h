//
//  KGPlayViewVideoLayout.h
//  ContactBookDemo
//
//  Created by rayor on 2021/8/4.
//

#import <UIKit/UIKit.h>

@interface KGPlayViewVideoEntranceListLayout : UICollectionViewFlowLayout

/*通过修改 sectionInset 属性的left来实现最大显示的视图，距离屏幕左边的距离;
 由于有最大最小情况，那么在设置Left时，会自动计算right,确保最后一个元素能达到最大的位置
 */
@property (nonatomic, assign) CGFloat leftPadding;

/* 两个item中间的距离, 由于视图进行了缩小处理，会导致本身为0的间距会变大为更大空间，
 * 这个值是用来计算找到合适的offsetX来调整itme的间距展示
 */
@property (nonatomic, assign) CGFloat itemPadding;


/*如果需要对cell做动画：
 1. 调用 invalidateLayout
 
 2. 重新加载所需要的indexPath或performBatchUpudates块中所有的数据
 collectionView.performBatchUpdates {
 self.collectionview.reload()
 }
 
 3. 返回sizeForItemAtIndexPath: 委托方法计算出新的位置尺寸信息
 
 */


@end
