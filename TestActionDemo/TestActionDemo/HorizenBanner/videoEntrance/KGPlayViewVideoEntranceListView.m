//
//  KGPlayViewVideoContainerView.m
//  ContactBookDemo
//
//  Created by rayor on 2021/8/4.
//

#import "KGPlayViewVideoEntranceListView.h"
#import "KGPlayViewVideoEntranceListLayout.h"
#import <Masonry/Masonry.h>
#import "KGPlayViewVideoEntranceListCell.h"
#import "KGPlayViewVideoEntranceConfig.h"

@interface KGPlayViewVideoEntranceListView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

/*布局信息*/
@property (nonatomic, strong) KGPlayViewVideoEntranceListLayout *layout;

@end

@implementation KGPlayViewVideoEntranceListView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}


- (void)createSubviews {
    [self addSubview:self.collectionView];
    [self registerCell];
    [self resetDefaultState];
}


- (void)updateConstraints {
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [super updateConstraints];
}


- (void)registerCell {
    [self.collectionView registerClass:KGPlayViewVideoEntranceListCell.class forCellWithReuseIdentifier:NSStringFromClass(KGPlayViewVideoEntranceListCell.class)];
}

/*回置为初始状态*/
- (void)resetDefaultState {
    self.collectionView.alpha = 0;
}

#pragma mark - 属性信息配置, 刷新展示动画使用
/*返回默认的初始位置*/
- (UICollectionViewLayoutAttributes *)defaultPointAttributesForIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *actualAttr = [self attributeFromIndexPath:indexPath];
    
    CGFloat rate = 30 / self.layout.itemSize.width;
    
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

- (void)updateCell:(UICollectionViewCell *)cell withAttributes:(UICollectionViewLayoutAttributes *)attr {
    cell.center = attr.center;
    cell.transform = attr.transform;
    cell.alpha = attr.alpha;
}

/*返回当前可见的cell的indexPath*/
- (NSArray *)sortedVisiableIndexPaths {
    // 先排序再执行
    NSArray *tmpArr = [self.collectionView.indexPathsForVisibleItems sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath * obj1, NSIndexPath * obj2) {
        return obj1.row > obj2.row;
    }];
    return tmpArr;
}


- (CGFloat)durationForFoldAnimation {
    return [KGPlayViewVideoEntranceConfig durateForUnfold];
}

#pragma mark - public
- (void)showContainer {
    for (UICollectionViewCell *cell in self.collectionView.visibleCells) {
        cell.alpha = 0;
    }
    self.collectionView.alpha = 1;  // 显示出来
    
    for (NSIndexPath *indexPath in [self sortedVisiableIndexPaths]) {
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        [self.collectionView sendSubviewToBack:cell];
        [self updateCell:cell withAttributes:[self defaultPointAttributesForIndexPath:indexPath]];
        
        [UIView animateWithDuration:[self durationForFoldAnimation] animations:^{
            [self updateCell:cell withAttributes:[self attributeFromIndexPath:indexPath]];
        }];
    }
}

- (void)hideContainer {

    for (NSIndexPath *indexPath in [self sortedVisiableIndexPaths]) {
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        [self.collectionView sendSubviewToBack:cell];
        [self updateCell:cell withAttributes:[self attributeFromIndexPath:indexPath]];
        
        [UIView animateWithDuration:[self durationForFoldAnimation] animations:^{
            [self updateCell:cell withAttributes:[self defaultPointAttributesForIndexPath:indexPath]];
        } completion:^(BOOL finished) {
            self.collectionView.alpha = 0;
        }];
    }
 }


#pragma mark - delegate & datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 根据不同的section展示不同的UI样式
    KGPlayViewVideoEntranceListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KGPlayViewVideoEntranceListCell.class) forIndexPath:indexPath];
    [cell refresh];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *menu = self.menusList[indexPath.section][indexPath.row];
    NSLog(@"---点击:%@",indexPath);
}


#pragma mark - getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.backgroundColor = UIColor.clearColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

- (KGPlayViewVideoEntranceListLayout *)layout {
    if (!_layout) {
        _layout = [[KGPlayViewVideoEntranceListLayout alloc] init];
        _layout.itemSize = CGSizeMake(136, 76);
        _layout.minimumLineSpacing = 0; // 横向滑动为列间距
        _layout.minimumInteritemSpacing = 0;
        _layout.leftPadding = 24;
        _layout.itemPadding = 10;   // 怎么设置，看KGPlayViewVideoEntranceListLayout.h来实现
    }
    return _layout;
}

@end
