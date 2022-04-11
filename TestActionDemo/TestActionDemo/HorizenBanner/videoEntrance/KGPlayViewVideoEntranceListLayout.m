//
//  KGPlayViewVideoLayout.m
//  ContactBookDemo
//
//  Created by rayor on 2021/8/4.
//

#import "KGPlayViewVideoEntranceListLayout.h"
#import "KGPlayViewVideoEntranceListCell.h"
#import "KGPlayViewVideoEntranceConfig.h"

@implementation KGPlayViewVideoEntranceAttributes

- (KGPlayViewVideoEntranceAttributes *)copyWithZone:(NSZone *)zone {
    KGPlayViewVideoEntranceAttributes *newO = [super copyWithZone:zone];
    newO.coverAlpha = _coverAlpha;
    return newO;
}

- (BOOL)isEqual:(KGPlayViewVideoEntranceAttributes *)object {
    BOOL isEqual = [super isEqual:object];
    return isEqual && object.coverAlpha == self.coverAlpha;
}

@end


@interface KGPlayViewVideoEntranceListLayout ()
/// 记录上次滑动停止时 contentOffset 值
@property (nonatomic, assign) CGPoint lastOffset;

@property (nonatomic, assign) KGVideoEntranceLayouType type;
@end


@implementation KGPlayViewVideoEntranceListLayout

+ (Class)layoutAttributesClass {
    return KGPlayViewVideoEntranceAttributes.class;
}

#pragma mark - refreshLayout
- (void)prepareForShowType:(KGVideoEntranceLayouType)type {
    _type = type;   /// 预处理机制，只处理一次
    [self refreshWithDuration:0];
}
- (void)refreshLayoutForShow:(KGVideoEntranceLayouType)type {
    if ([self shouldUpdateLayoutWithType:type]) {
        [self refreshWithDuration:[KGPlayViewVideoEntranceConfig durateForUnfold]];
    }
}

// 判断是否需要进行刷新
- (BOOL)shouldUpdateLayoutWithType:(KGVideoEntranceLayouType)type {
    if (type == KGVideoEntranceLayouType_None) {
        return NO;
    }
    
    if (type == _type) {
        NSLog(@"当前的数据展示类型一样");
        return NO;
    }
    _type = type;
    return YES;
}

- (void)refreshWithDuration:(CGFloat)duration
{
    // 如果是全部刷新，使用
    [UIView animateWithDuration:duration animations:^{
        [self.collectionView performBatchUpdates:nil  completion:^(BOOL finished) {
            [self.collectionView layoutIfNeeded];
            self.collectionView.userInteractionEnabled = self.type == KGVideoEntranceLayouType_Show;
        }];
    }];
    
    
    // 如果仅仅是改变单元格的布局
    //    [self invalidateLayout];    // 触发刷新机制
    //
    //    [UIView animateWithDuration:0.25 animations:^{
    //        [self.collectionView layoutIfNeeded];
    //    }];
    
}
#pragma mark - 其他配置展示
/*返回最小的X，即展示为当前sectionInset设置的位置*/
- (CGFloat)findMinOffsetX {
    return 0;
}

/*最大偏移能够展示的位置， 需要确保最后一个元素能够展示到正确的位置*/
- (CGFloat)findMaxOffsetX {
    return self.collectionView.contentSize.width - self.sectionInset.right;
}

/// 计算每滑动一页的距离：步幅
- (CGFloat)findStepDistance {
    return self.itemSize.width + self.minimumLineSpacing;
}

#pragma mark - 方法重写
- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat right = self.collectionView.bounds.size.width - self.leftPadding - self.itemSize.width;
    
    self.sectionInset = UIEdgeInsetsMake(50, self.leftPadding, 50, right);      // 如何让cell展示的区域变大
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
}

/*屏幕尺寸发生变化需要刷新布局信息*/
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

/// 计算停止滚动时的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    CGFloat pageSpace = [self findStepDistance];
    CGFloat offsetMax = [self findMaxOffsetX];
    CGFloat offsetMin = [self findMinOffsetX];
    
    // 边界判断处理
    if (_lastOffset.x < offsetMin) {
        _lastOffset.x = offsetMin;
    } else if (_lastOffset.x > offsetMax) {
        _lastOffset.x = offsetMax;
    }
    
    // 当前位置与上一次位置的偏差
    CGFloat offsetForCurrentPointX = ABS(proposedContentOffset.x - _lastOffset.x);
    CGFloat velocityX = velocity.x;
    
    if (offsetForCurrentPointX > pageSpace / 8.f && _lastOffset.x >= offsetMin && _lastOffset.x <= offsetMax) {
        // 分页因子，用于计算滑过的 cell 个数
        NSInteger pageFactor = 0;
        BOOL isLeftScroll = (proposedContentOffset.x - _lastOffset.x) > 0;  // 区分左右滑动
        
        if (velocityX != 0) {
            // 滑动，速率越快，cell滑过数量越多
            pageFactor = ABS(velocityX);
        } else {
            // 拖动，没有速率，则计算：位移差 / 默认步距 = 分页因子
            pageFactor = ABS(offsetForCurrentPointX / pageSpace);
        }
        
        // 设置pageFactor上限为 2, 防止滑动速率过大，导致翻页过多
        pageFactor = pageFactor < 1 ? 1 : (pageFactor < 3 ? 1 : 2);
        
        CGFloat pageOffsetX = pageSpace * pageFactor;
        proposedContentOffset = CGPointMake(
                                            _lastOffset.x + (isLeftScroll ? pageOffsetX : -pageOffsetX),
                                            proposedContentOffset.y);
    } else {
        // 滚动距离，小于翻页步距一半，则不进行翻页操作
        proposedContentOffset = CGPointMake(_lastOffset.x, _lastOffset.y);
    }
    
    // 记录状态
    _lastOffset.x = proposedContentOffset.x;
    
    return proposedContentOffset;
    
}

/// 设置放大动画
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *arr = [super layoutAttributesForElementsInRect:rect].copy;
    
    /*计算相对最大展示视图的居中点*/
    CGFloat centerX = self.collectionView.contentOffset.x + self.sectionInset.left + self.itemSize.width / 2;
    NSArray *showedIndexPaths = [self sortedVisiableIndexPaths];
    
    for (KGPlayViewVideoEntranceAttributes *attributes in arr) {
        @autoreleasepool {
            CGFloat distance = fabs(attributes.center.x - centerX);
            
            // 当前要求目标的比例是多少？
            CGFloat rate = 64.0f / 76.0f;   // 最大和第二个的高度比例, 大概取个限制位数的小说
            
            // 让一个步幅的偏移正好对比这么大的rate
            CGFloat stepDistance = [self findStepDistance];
            
            CGFloat step = distance / stepDistance - 1;  // 距离当前中心第几个位置
            
            if (distance > stepDistance) {  // 第二个之后所有的保持一样的缩小比例
                distance = stepDistance;
            }
            
            // distance / stepDistance 为偏移中心的距离  (1-rate)为当前偏移距离为1个步幅时需要缩小的倍数
            // 注意这个scale最小的情况等于rate
            CGFloat scale = 1 - (distance / stepDistance) * (1-rate);
            
            // 高度处理 (1-scale) 代表的为实际缩小的值  *0.5是因为要取高度差的一半来保持底部平齐
            CGFloat width = attributes.size.width;
            CGFloat offsetY = attributes.size.height * (1-scale) * 0.5f;
            CGFloat offsetX = -width * (1-scale) * step; // 这里数据为25 * step, 相当于后面的数据都隐藏
            
            CGFloat maxPadding = width * (1-rate);
            
            offsetX = (maxPadding - self.itemPadding) / maxPadding * offsetX;
            
            CGAffineTransform translateTrans = CGAffineTransformMakeTranslation(offsetX, offsetY);
            
            CGAffineTransform trans = CGAffineTransformScale(translateTrans, scale, scale);
            
            attributes.transform = trans;
            
            attributes.coverAlpha = (1 - scale) * 3;
            
            
            if (self.type == KGVideoEntranceLayouType_hide
                && [showedIndexPaths containsObject:attributes.indexPath]) {  // 如果需要隐藏
                if (attributes.center.x >= self.collectionView.contentOffset.x) {   // 直接缩进
                    CGFloat rate = 30 / self.itemSize.width;
                    attributes.center = CGPointMake(self.collectionView.contentOffset.x + self.fromPoint.x, self.fromPoint.y);
                    attributes.transform =  CGAffineTransformMakeScale(rate, rate);
                    attributes.alpha = 1;
                } else {
                    attributes.alpha = 0;
                }
                
            }
            
        }
    }
    
    return arr;
}


#pragma mark - 尝试使用的方案
// 通过下面的方法来实现初始值的刷新展示
- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    NSLog(@"动画初始的方法----------------------------");
    return [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    // 此处需要计算初始值的展示方案
}

-  (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    
    // 此处需要计算结束值的展示方案
    NSLog(@"动画结束时的方法");
    return [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
}

/*返回默认的初始位置*/
- (UICollectionViewLayoutAttributes *)defaultPointAttributesForIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *actualAttr = [self attributeFromIndexPath:indexPath];
    
    CGFloat rate = 30 / self.itemSize.width;
    
    UICollectionViewLayoutAttributes *attr = [[UICollectionViewLayoutAttributes alloc] init];
    
    
    if (actualAttr.center.x < self.collectionView.contentOffset.x) {
        attr.center = actualAttr.center;
        attr.transform = actualAttr.transform;
        attr.alpha = 0;
    } else {
        attr.center = CGPointMake(self.collectionView.contentOffset.x + self.fromPoint.x, self.fromPoint.y);
        attr.transform =  CGAffineTransformMakeScale(rate, rate);
        attr.alpha = 1;
    }
    
    return attr;
}

- (UICollectionViewLayoutAttributes *)attributeFromIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
}

//- (void)updateCell:(UICollectionViewCell *)cell withAttributes:(UICollectionViewLayoutAttributes *)attr {
//    cell.center = attr.center;
//    cell.transform = attr.transform;
//    cell.alpha = attr.alpha;
//}

/*返回当前可见的cell的indexPath*/
- (NSArray *)sortedVisiableIndexPaths {
    // 先排序再执行
    NSArray *tmpArr = [self.collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath * obj1, NSIndexPath * obj2) {
        return obj1.row > obj2.row;
    }];
    return tmpArr;
}


- (NSArray *)visibleSortedIndex {
    return [self sortedVisiableIndexPaths];
}
@end
