//
//  KGPlayViewOptionPageAlert.m
//  ContactBookDemo
//
//  Created by rayor on 2022/2/24.
//

#import "KGPlayViewOptionPageAlert.h"
#import <Masonry/Masonry.h>
#import "KGPlayViewOptionPageAlertCell.h"

// 高度预算
#define kTrangleHeight 6
#define kTrangleWidth 16
#define kCollectionHeight 94
#define kMainHeight (kTrangleHeight+kCollectionHeight)

// 容器展示
#define kCollectionLeftRight 11     // 加cell居中有内间距5 ，共16
#define kCollecionInner 2
#define kCollectionCellHeight 64
#define kCollectionCellWidth 60     // 正好内部容器为50，有间距10， 左右各5


@interface KGPlayViewOptionPageAlert ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIVisualEffectView *effectView;

@property (nonatomic, strong) UIView *mainView;

// 容器视图
@property (nonatomic, strong) UICollectionView *collectionView;

// 三角形
@property (nonatomic, strong) UIImageView *trangleImageView;

/*支持的页面信息*/
@property (nonatomic, strong) NSArray *optionPages;

@end

@implementation KGPlayViewOptionPageAlert

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:UIScreen.mainScreen.bounds]) {
        [self createSubViews];
        [self registerCell];
    }
    return self;
}

- (void)createSubViews {
    
    [self.mainView addSubview:self.effectView];

    
    
    [self addSubview:self.mainView];
    [self.mainView addSubview:self.trangleImageView];
    [self.mainView addSubview:self.collectionView];
    
    // 设置约束，不设置mainView的上部和中间
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.collectionView.mas_width);  // 随着collectionview动态改变
        make.height.mas_equalTo(kMainHeight);
        
        // 这两项随着show进行重新调整
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.trangleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mainView);
        make.height.mas_equalTo(kTrangleHeight);
        make.width.mas_equalTo(kTrangleWidth);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);    // 此处可以刷新调整
        make.height.mas_equalTo(kCollectionHeight);
        make.top.mas_equalTo(self.trangleImageView.mas_bottom);
    }];
    
    [self.effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.mainView);
    }];
}



- (void)registerCell {
    [self.collectionView registerClass:KGPlayViewOptionPageAlertCell.class forCellWithReuseIdentifier:NSStringFromClass(KGPlayViewOptionPageAlertCell.class)];
}

- (void)prepareUIForShowWithTopPoint:(CGPoint)topPoint {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGFloat centerX = topPoint.x - UIScreen.mainScreen.bounds.size.width / 2.f;
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        // 这两项随着show进行重新调整
        make.top.mas_equalTo(topPoint.y + 10);
        make.centerX.mas_equalTo(centerX);
    }];
    
    
    // 根据宽度展示
    CGFloat width = [self collectionViewWidthForData];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    self.mainView.layer.mask = [self maskLayer];
}

#pragma mark - 显示/隐藏

- (void)showWithTopPoint:(CGPoint)topPoint {
    
    [self prepareUIForShowWithTopPoint:topPoint];
    
    self.mainView.transform = CGAffineTransformMakeTranslation(0, -10);
    self.mainView.alpha = 0;
    
    NSLog(@"%@",self.mainView);
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.alpha = 1;
        self.mainView.transform = CGAffineTransformIdentity;
    }completion:^(BOOL finished) {
        NSLog(@"finish:%@",self.mainView);
    }];
    
}

- (void)hide {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.mainView.alpha = 0;
        self.mainView.transform = CGAffineTransformMakeTranslation(0, -10);
    } completion:^(BOOL finished) {
        self.mainView.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
    }];
}

- (CGFloat)collectionViewWidthForData {
    
    NSInteger number = self.optionPages.count;
    
    CGFloat width = (kCollectionLeftRight * 2 + (number - 1) * kCollecionInner + number * kCollectionCellWidth);
    
    CGFloat maxWidth =  UIScreen.mainScreen.bounds.size.width - 40;
    
    if (width > maxWidth) {
        width = maxWidth;
    }
    return width;

}



#pragma mark - event
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGPoint point = [[touches anyObject] locationInView:self.mainView];
    if (!CGRectContainsPoint(self.mainView.bounds, point)) {
        [self hide];
    }
}


#pragma mark - collectionview delegae & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.optionPages.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KGPlayViewOptionPageAlertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(KGPlayViewOptionPageAlertCell.class) forIndexPath:indexPath];
    
    NSInteger optionType = [self.optionPages[indexPath.row] integerValue];
    
    cell.optionType = optionType;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger optionType = [self.optionPages[indexPath.row] integerValue];
    
    // 获取当前索引页
    NSInteger row = [self.optionPages indexOfObject:@([self pageConfig].currentType)];
    NSIndexPath *currentIndexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    // 改写状态
    [[self pageConfig] updateCurrentType:optionType];
    
    
    NSMutableArray *tmpArr = @[].mutableCopy;
    [tmpArr addObject:currentIndexPath];
    [tmpArr addObject:indexPath];
    
    
    // 找到新旧两个索引，然后进行设置
    self.collectionView.userInteractionEnabled = NO;
    [collectionView performBatchUpdates:^{
        KGPlayViewOptionPageAlertCell *currentCell = (KGPlayViewOptionPageAlertCell *)[self.collectionView cellForItemAtIndexPath:currentIndexPath];
        KGPlayViewOptionPageAlertCell *nextCell = (KGPlayViewOptionPageAlertCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        
        [currentCell updateStateWithAnimation:YES];
        [nextCell updateStateWithAnimation:YES];
        
    } completion:^(BOOL finished) {
        self.collectionView.userInteractionEnabled = YES;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self hide];
        });
    }];
    
    
}

#pragma mark - setter

- (KGPlayViewOptionPageConfig *)pageConfig {
    return [KGPlayViewOptionPageConfig shareManager];
}

- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
    }
    return _mainView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kCollectionCellWidth, kCollectionCellHeight);
        layout.minimumLineSpacing = kCollecionInner;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.layer.cornerRadius = 10;
        _collectionView.layer.masksToBounds = YES;
        _collectionView.contentInset = UIEdgeInsetsMake(0, kCollectionLeftRight, 0, kCollectionLeftRight);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = UIColor.clearColor;
    }
    return _collectionView;
}


- (UIImageView *)trangleImageView {
    if (!_trangleImageView) {
        _trangleImageView = [[UIImageView alloc] init];
        _trangleImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _trangleImageView;
}

- (NSArray *)optionPages {
    return [KGPlayViewOptionPageConfig optionPageList];
}



- (CALayer *)maskLayer {
//    底部一个圆角矩形，上面一个小三角形
    UIBezierPath *roundPath = [UIBezierPath bezierPathWithRoundedRect:self.collectionView.frame cornerRadius:10];
    
    CAShapeLayer *roundLayer = [[CAShapeLayer alloc] init];
    roundLayer.path = roundPath.CGPath;
    
    UIImage *maskImage = [UIImage imageNamed:@"player_bgmode_popups_bg_arrow"];
    
    CALayer *maskImageLayer = [[CALayer alloc] init];
    maskImageLayer.contents = (__bridge  id)maskImage.CGImage;
    maskImageLayer.frame = self.trangleImageView.frame;
    
    CALayer *maskLayer = [[CALayer alloc] init];
    maskLayer.frame = self.mainView.bounds;
    
    
    [maskLayer addSublayer:maskImageLayer];
    [maskLayer addSublayer:roundLayer];
    
    return maskLayer;
}

- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _effectView.backgroundColor = [UIColor colorWithWhite:0 alpha:.5f];
    }
    return _effectView;
}
@end
