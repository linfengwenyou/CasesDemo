//
//  BannersViewLayout.m
//  TestActionDemo
//
//  Created by Buck on 2025/6/2.
//  Copyright © 2025 rayor. All rights reserved.
//

#import "BannersViewLayout.h"



@interface BannersViewLayout ()

/// 记录上次滑动停止时 contentOffset 值
@property (nonatomic, assign) CGPoint lastOffset;
@end

@implementation BannersViewLayout


- (instancetype)init {
    if(self = [super init]) {
        self.minimumLineSpacing = 0; // 横向滑动为列间距
        self.minimumInteritemSpacing = 0;
        
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        
    }
    
    return self;
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

- (BOOL)isRTL {
    return self.collectionView.effectiveUserInterfaceLayoutDirection == UIUserInterfaceLayoutDirectionRightToLeft;
}
#pragma mark - 方法重写
- (void)prepareLayout {
    [super prepareLayout];
    
    CGFloat inset = (self.collectionView.bounds.size.width - self.itemSize.width)/2.f;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);      // 如何让cell展示的区域变大
  
}

/*屏幕尺寸发生变化需要刷新布局信息*/
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSInteger)toIndex:(NSInteger)index {
    if([self isRTL]) {
        index = [self.collectionView numberOfItemsInSection:0] - index - 1;
    }
    return index;
}

- (CGPoint)contentXForScrollToIndex:(NSInteger)index {
   
    return [self targetContentOffsetForProposedContentOffset:CGPointMake([self toIndex:index] *[self findStepDistance], 0)
                                       withScrollingVelocity:CGPointZero];
}

- (void)updateContentOffsetXForIndex:(NSInteger)index {
    // 这个只能触发一次，需要换一个地方
    CGFloat x = 0;
    if([self isRTL]) {
        x =  [self toIndex:index] * [self findStepDistance];
    }
    self.lastOffset = CGPointMake(x, 0);

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
    
    if (offsetForCurrentPointX > pageSpace / 4.f && _lastOffset.x >= offsetMin && _lastOffset.x <= offsetMax) {
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
    NSLog(@"输出要定位到的偏移点:%.2f",proposedContentOffset.x);
    return proposedContentOffset;
    
}

/// 设置放大动画
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttrs = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *attrsArray = [NSMutableArray arrayWithCapacity:originalAttrs.count];
    
    CGFloat collectionViewCenterX = self.collectionView.contentOffset.x + self.collectionView.bounds.size.width / 2.0;
    CGFloat itemWidth = self.itemSize.width;
    
    CGFloat maxScale = 1.0;
    CGFloat minScale = 341.0 / 405.0;
    CGFloat scaleRange = maxScale - minScale;
    
    CGFloat maxOffset = itemWidth + self.itemPadding; // 一个 cell 位置偏移最大
    
    for (UICollectionViewLayoutAttributes *attributes in originalAttrs) {
        UICollectionViewLayoutAttributes *attr = [attributes copy];
        
        CGFloat distanceFromCenter = fabs(attr.center.x - collectionViewCenterX);
        if (distanceFromCenter > maxOffset) {
            distanceFromCenter = maxOffset; // 只处理最近的左右两个
        }
        
        CGFloat distanceX = attr.center.x - collectionViewCenterX;
        CGFloat absDistance = fabs(distanceX);
        
        CGFloat ratio = distanceFromCenter / maxOffset;
        CGFloat scale = maxScale - scaleRange * ratio;
        
        
        CGFloat transX = 0;
        if (absDistance != 0) {
            
            CGFloat direction = distanceX > 0 ? -1 : 1; // 右边的往左，左边的往右
            
            transX = (scaleRange * ratio * (itemWidth/2.f) - (ratio * self.itemPadding)) * direction;
            
        }
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(transX, 0);
        
        attr.transform = CGAffineTransformScale(translate, scale, scale);
        
        // 设置 coverAlpha（可选）
        attr.alpha = (1-ratio)*0.3+0.7;
        
        [attrsArray addObject:attr];
    }
    
    return attrsArray;
}

@end
