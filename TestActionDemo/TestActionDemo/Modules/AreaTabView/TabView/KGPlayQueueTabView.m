//
//  KGPlayQueueTabView.m
//  KGAreaSelectDemo
//
//  Created by rayor on 2022/6/9.
//
/*设计方案：
 * 整体设计一个 collectionview来显示
 * 底部添加一个滑块，滑块要放到最底部，当选中某个点时，滑块自动滑动到中心的位置
 * 还有分割线要注意下怎么放，如果能放到滑块底部就方便处理，如果是放到cell上就有点尴尬了
 */
#import "KGPlayQueueTabView.h"
#import "KGPlayQueueTabCell.h"

// 横屏最多展示多少个条目
#define KMaxItemCount 5

@interface KGPlayQueueTabView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *mainView;
@property (nonatomic, strong) UIView *backSliderView;

/// 当前选中的索引
@property (nonatomic, assign, readwrite) NSInteger selectIndex;
/// 选项
@property (nonatomic, strong) NSArray *items;

/*条目宽度/高度*/
@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, assign) CGFloat itemHeight;
@end

@implementation KGPlayQueueTabView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    
    self.backgroundColor = UIColor.lightTextColor;
    self.mainView.backgroundColor = UIColor.clearColor;
    
    [self addSubview:self.mainView];
    [self.mainView insertSubview:self.backSliderView atIndex:0];
    
    // 添加约束信息，默认选中第一个
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
//    [self.backSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(104);
//        make.height.mas_equalTo(35);
//        make.centerY.mas_equalTo(self.mainView);
//    }];
//
    self.backSliderView.bounds = CGRectMake(0, 0, 104, 35);
    self.backSliderView.center = CGPointMake(36, 17.5);
    
    self.mainView.delegate = self;
    self.mainView.dataSource = self;
    // 注册cell
    [self.mainView registerClass:[KGPlayQueueTabCell class] forCellWithReuseIdentifier:NSStringFromClass(KGPlayQueueTabCell.class)];
}

// 选中指定文件时，需要自己去进行处理
#pragma mark - 外部事件的处理
/// 更新整体配置项，同时标记默认选中第几个
/// @param items 选项
/// @param index 当前选中的索引
- (void)updateWithItems:(NSArray *)items defaultIndex:(NSInteger)index {
    self.items = items;
    self.selectIndex = index;
    [self refreshMainView];
}


/// 更新当前选中的选项
/// @param index 当前选中索引
- (void)updateCurrentSelectIndex:(NSInteger)index {
    self.selectIndex = index;
    [self refreshMainView];
}

- (void)refreshMainView {
    [self.mainView reloadData];
    
    self.itemWidth = [self itemWidth];
    self.itemHeight = 35;
    
    CGFloat imageWidth = self.itemWidth + 32;
    self.backSliderView.bounds = CGRectMake(0, 0,imageWidth, self.itemHeight);
    self.backSliderView.center = CGPointMake(self.itemWidth / 2, self.itemHeight / 2.f);
    
    self.backSliderView.layer.mask = [self maskLayerForSliderView];
}

#pragma mark - delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 根据不同的section展示不同的UI样式
    NSString *menu = self.items[indexPath.row];
    
    KGPlayQueueTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KGPlayQueueTabCell.class) forIndexPath:indexPath];
    
    UIColor *randomColor = [[UIColor alloc] initWithRed:arc4random() %255/255.0 green:arc4random() %255/255.0 blue:arc4random() %255/255.0 alpha:1];
//    cell.backgroundColor = randomColor;
    cell.name = menu;
    
    BOOL hideLine = (indexPath.row == self.selectIndex || indexPath.row - self.selectIndex == 1 || indexPath.row == 0);
    cell.showLine = !hideLine;
    cell.currentSelect = indexPath.row == self.selectIndex;
    
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    
    [self.mainView reloadData];
    
    !self.currentSelectAction ?: self.currentSelectAction();
    
    NSString *menu = self.items[indexPath.row];
    NSLog(@"---点击:%@",menu);
}


- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.mainView sendSubviewToBack:self.backSliderView];
    // 此时调整展示
    if (indexPath.row == self.selectIndex) {
        [UIView animateWithDuration:0.25 animations:^{
            CGFloat tranX = cell.center.x - self.itemWidth/2.0f;   // 减去第一个展示的中心
            self.backSliderView.transform = CGAffineTransformMakeTranslation(tranX, 0);
        }];
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.itemWidth, self.itemHeight);
}

- (CGFloat)itemWidth {
    CGFloat width = UIScreen.mainScreen.bounds.size.width;
    
    NSInteger count = self.items.count;
    if (count > KMaxItemCount) {
        count = KMaxItemCount;
    }
    
    CGFloat itemWidth = width / count;
    return itemWidth;
}

- (CALayer *)maskLayerForSliderView {
    // 左上10，左下外10，
    CGFloat radius = 10;
    
    CGRect frame = self.backSliderView.bounds;
    CGFloat height = CGRectGetMaxY(frame);
    CGFloat width = CGRectGetMaxX(frame);
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0,height)];
    
    // 构造圆切线 左下角圆弧 -> 向上， 左上角圆弧
    [path addArcWithCenter:CGPointMake(0, height - radius) radius:radius startAngle:M_PI_2 endAngle:0 clockwise:NO];
    [path addLineToPoint:CGPointMake(radius, radius)];
    [path addArcWithCenter:CGPointMake(2*radius, radius) radius:radius startAngle:M_PI endAngle:3*M_PI_2 clockwise:YES];
    
    // 顶部连线到右侧
    [path addLineToPoint:CGPointMake(width - height, 0)];
    
    // 绘制右侧线 右上角圆弧 -> 向下线 -> 右下角圆弧
    [path addArcWithCenter:CGPointMake(width - 2*radius, radius) radius:radius startAngle:3*M_PI_2 endAngle:2*M_PI clockwise:YES];
    [path addLineToPoint:CGPointMake(width - radius, height - radius)];
    [path addArcWithCenter:CGPointMake(width, height-radius) radius:radius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    [path closePath];
    
    layer.path = path.CGPath;
    
    return layer;
    
}

#pragma mark - setter & getter
- (UICollectionView *)mainView {
    if (!_mainView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _mainView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mainView.showsHorizontalScrollIndicator = NO;
    }
    return _mainView;
}

- (UIView *)backSliderView {
    if (!_backSliderView) {
        _backSliderView = [[UIView alloc] init];
        _backSliderView.backgroundColor = UIColor.whiteColor;
    }
    return _backSliderView;
}

- (UIImage *)sliderOriginImage {
    return [UIImage imageNamed:@"sliderImage"];
}
@end
