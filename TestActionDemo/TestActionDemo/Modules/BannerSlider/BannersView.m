//
//  BannersView.m
//  TestActionDemo
//
//  Created by Buck on 2025/6/2.
//  Copyright © 2025 rayor. All rights reserved.
//

#import "BannersView.h"

#import "BannersViewLayout.h"
#import "KGPlayViewVideoEntranceListCell.h"


@interface BannersView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

/*布局信息*/
@property (nonatomic, strong) BannersViewLayout *layout;
@end

@implementation BannersView

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
    self.collectionView.alpha = 1;
}


#pragma mark - public
- (void)showContainer {

   
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

- (BannersViewLayout *)layout {
    if (!_layout) {
        
        CGFloat width = kScreenW - 2*40;
        CGFloat height =  kScreenW / width * 405;
        CGFloat leftPadding = 10;
        
        
        _layout = [[BannersViewLayout alloc] init];
        _layout.itemSize = CGSizeMake(width, height);
        _layout.minimumLineSpacing = 0; // 横向滑动为列间距
        _layout.minimumInteritemSpacing = 0;
        _layout.leftPadding = 12;
        _layout.itemPadding = 10;   // 怎么设置，看KGPlayViewVideoEntranceListLayout.h来实现
    }
    return _layout;
}

@end
