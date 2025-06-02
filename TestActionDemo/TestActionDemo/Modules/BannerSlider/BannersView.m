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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self makeConstraints];
        [self.collectionView reloadData];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    [self addSubview:self.collectionView];
    [self registerCell];
}

- (void)makeConstraints {
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}


- (void)registerCell {
    [self.collectionView registerClass:KGPlayViewVideoEntranceListCell.class forCellWithReuseIdentifier:NSStringFromClass(KGPlayViewVideoEntranceListCell.class)];
}



#pragma mark - public
- (void)showContainer {
    
    CGPoint offset = [self.layout contentXForScrollToIndex:1];
    [self.collectionView setContentOffset:offset];
    
    // 等 scrollTo 完成后再强制 layout 刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView performBatchUpdates:^{} completion:nil];
    });
   
    
    
    
    
    
    
//    [self.collectionView.collectionViewLayout invalidateLayout];
//    self.layout.defaultIndex = 1;
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
        
        _layout = [[BannersViewLayout alloc] init];
        _layout.itemSize = CGSizeMake(width, height);

        _layout.itemPadding = 12;
    }
    return _layout;
}

@end
