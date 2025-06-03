//
//  HomeViewConroller.m
//  TestActionDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "HomeViewConroller.h"
#import "HomeViewConroller+DataSource.h"


// 最多显示几个列表
#define kMaxShowCellCount 3
// cell显示高度
#define kCellHeight 36

// cell 上下间距
#define kCellPadding 10

@interface HomeViewControllerCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation HomeViewControllerCell

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder: coder]) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    NSLog(@"UI进行了初始化");
    self.layer.cornerRadius = 5.f;
    self.layer.borderColor = [UIColor.redColor colorWithAlphaComponent:0.5].CGColor;
    self.layer.borderWidth = 1.f;
}


@end

#pragma mark - 控制器


@interface HomeViewConroller ()<UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray <HomeViewDataModel *>*dataModel;
@end

@implementation HomeViewConroller

static NSString * const reuseIdentifier = @"HomeViewControllerCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataModel = [HomeViewConroller homeViewModelArray];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModel.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewControllerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    HomeViewDataModel *model = self.dataModel[indexPath.row];
    
    cell.nameLabel.text = model.title;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeViewDataModel *model = self.dataModel[indexPath.row];
    
    UIViewController *vc = [self vcWihHomeVCModel:model];
    
    [self.navigationController pushViewController:vc animated:YES];
}


// 制造点击效果
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.alpha = 0.4f;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.alpha = 1.f;
}



// 根据反射机制来进行值的创建来实现跳转逻辑
- (UIViewController *)vcWihHomeVCModel:(HomeViewDataModel *)model {
    Class vcClass = NSClassFromString(model.className);
    
    // 判断文件是否存在，如果不存在xib，则使用init
    UIViewController *vc = nil;
    if([self isExistWithName:model.className]) {
        UIViewController *vcc = [vcClass alloc];
        vc = [vcc initWithNibName:model.className bundle:nil];
        vc.title = model.title;
    } else {
        vc = [[vcClass alloc] init];
        vc.title = model.title;
    }
    
    return vc;
}

- (BOOL)isExistWithName:(NSString *)xibName {
    NSString *xibPath = [[NSBundle mainBundle] pathForResource:xibName ofType:@"nib"];
    return xibPath.length > 0;
}



#pragma mark <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (self.view.width - (kMaxShowCellCount + 1) * kCellPadding - 4) / kMaxShowCellCount;
    return CGSizeMake(width, kCellHeight);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return kCellPadding;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return kCellPadding;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, kCellPadding, 0, kCellPadding);
}
@end
