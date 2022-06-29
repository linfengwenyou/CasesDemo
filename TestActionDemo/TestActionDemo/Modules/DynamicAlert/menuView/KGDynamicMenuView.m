//
//  DynamicMenuView.m
//  DynamicDemo
//
//  Created by rayor on 2020/10/9.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "KGDynamicMenuView.h"
#import <Masonry/Masonry.h>
#import "KGDynamicMenuSkinCell.h"
#import "DynamicSkinsManager.h"
#import "MyDynamicSliderView.h"

// 主视图信息
#define pMainViewHeight 286.0f
#define pMainViewLeftRightPadding 17.5f
#define pMainViewBottomPadding 58.0f


@interface KGDynamicMenuView ()<UICollectionViewDelegate, UICollectionViewDataSource>

// 缩小后的位置所在
@property (nonatomic,assign) CGRect shrinkedFrame;

// 正常展示的位置所在
@property (nonatomic,assign) CGRect normalFrame;

// 容器视图
@property (nonatomic, strong) UIView *mainView;

// 音效视图
@property (nonatomic, strong) UICollectionView *skinCollectionView;

/* 选中的动效效果 */
@property (nonatomic, assign) NSInteger selectIndex;

// 效果模型数组
@property (nonatomic, strong) NSArray *skinModes;
@end

@implementation KGDynamicMenuView

- (instancetype)initWithShrinkedFrame:(CGRect)shrinkedFrame {
    
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        
        self.backgroundColor = [UIColor clearColor];
     
        self.shrinkedFrame = shrinkedFrame;
        
        CGFloat width =[UIScreen mainScreen].bounds.size.width - 2 * pMainViewLeftRightPadding;
        CGFloat y = [UIScreen mainScreen].bounds.size.height - pMainViewHeight - pMainViewBottomPadding;

        self.normalFrame = CGRectMake(pMainViewLeftRightPadding , y , width, pMainViewHeight);
        
        [self createSubViews];
        [self loadDynamicSkinModels];
    }
    return self;
}


- (UIView *)mainView {
    if (!_mainView) {
        _mainView = [[UIView alloc] initWithFrame:self.normalFrame];
        _mainView.backgroundColor = [UIColor blackColor];
        _mainView.layer.cornerRadius = 12.0f;
        _mainView.clipsToBounds = YES;
    }
    return _mainView;
}


- (UICollectionView *)skinCollectionView {
    if (!_skinCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(58, 92);
        flowLayout.minimumLineSpacing = 10;
        
        _skinCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _skinCollectionView.contentInset = UIEdgeInsetsMake(0, 17, 0, 17);
        _skinCollectionView.dataSource = self;
        _skinCollectionView.delegate = self;
        [_skinCollectionView registerClass:[KGDynamicMenuSkinCell class] forCellWithReuseIdentifier:NSStringFromClass([KGDynamicMenuSkinCell class])];
        _skinCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _skinCollectionView;
}

- (void)createSubViews {
    
    [self addSubview:self.mainView];
    // 内部子视图通过约束的方式添加上去
    
    UIView *effectContainer = [self createPhotoEffectView];
    UIView *intensityView = [self createEffectIntensityView];
    UIView *speedView = [self createEffectSpeedView];
    
    // 颜色效果分区测试
//    effectContainer.backgroundColor = UIColor.blueColor;
//    intensityView.backgroundColor = UIColor.redColor;
//    speedView.backgroundColor = UIColor.yellowColor;
    
    [self.mainView addSubview:effectContainer];
    [self.mainView addSubview:intensityView];
    [self.mainView addSubview:speedView];

    // 设置约束
    [effectContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(138);
    }];
    
    [intensityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(effectContainer.mas_bottom);
        make.height.mas_equalTo(60);
    }];
    
    [speedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(intensityView.mas_bottom);
        make.height.mas_equalTo(60);
    }];
}

// 写真动效视图， 返回容器视图
- (UIView *)createPhotoEffectView {
    // label， collectionView
    UIView *containerView = [[UIView alloc] init];
    
    // 46个高度来展示标题信息
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"写真动效";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];  // 需要换为平方字体
    
    UILabel *subLabel = [[UILabel alloc] init];
    subLabel.text = @"写真跟随歌曲节奏抖动";
    subLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    subLabel.font = [UIFont systemFontOfSize:11.0f];  // 需要换为平方字体
    
    [containerView addSubview:titleLabel];
    [containerView addSubview:subLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(18);
    }];
    
    [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleLabel);
        make.left.mas_equalTo(titleLabel.mas_right).offset(5);
    }];
    
    
    [containerView addSubview:self.skinCollectionView];
    [self.skinCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(9);
        make.bottom.mas_equalTo(containerView.mas_bottom);
    }];
    
    return containerView;
}

// 动效强度强度
- (UIView *)createEffectIntensityView {
    UIView *containerView = [[UIView alloc] init];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"动效强度";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];  // 需要换为平方字体
    
    [containerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(16);
    }];
    
    
    MyDynamicSliderView *slideView = [[MyDynamicSliderView alloc] initWithFrame:CGRectZero anchors:@[@"轻度",@"柔和",@"标准",@"强烈",@"缓慢",@"正常"]];
    slideView.selectIndexBlock = ^(NSInteger index) {
#warning lius 注意强引用问题
        !self.selectIntensityBlock ?: self.selectIntensityBlock(index);
    };
    [containerView addSubview:slideView];
    
    [slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).offset(20);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.right.mas_equalTo(-15);
    }];
    
    
    return containerView;
}


// 动效速度
- (UIView *)createEffectSpeedView {
    UIView *containerView = [[UIView alloc] init];
    
    // 标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"切换速度";
    titleLabel.textColor = UIColor.whiteColor;
    titleLabel.font = [UIFont systemFontOfSize:13.0f];  // 需要换为平方字体
    [containerView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(16);
    }];
    
    MyDynamicSliderView *slideView = [[MyDynamicSliderView alloc] initWithFrame:CGRectZero anchors:@[@"缓慢",@"正常",@"快速"]];
    slideView.selectIndexBlock = ^(NSInteger index) {
#warning lius 注意强引用问题
        !self.selectSpeedBlock ?: self.selectSpeedBlock(index);
    };
    [containerView addSubview:slideView];
    
    [slideView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_right).offset(20);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(60);
        make.right.mas_equalTo(-15);
    }];
    

    return containerView;
}



#pragma mark - collectionView代理信息
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.skinModes.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KGDynamicMenuSkinCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KGDynamicMenuSkinCell class]) forIndexPath:indexPath];
    cell.selected = indexPath.row == self.selectIndex;
    cell.model = [self.skinModes objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    [collectionView reloadData];
    
    KGDynamicMenuSkinCellMode *model = [self.skinModes objectAtIndex:indexPath.row];
    !self.selectSkinBlock ?: self.selectSkinBlock(model.skinId);
}


#pragma mark - 数据加载
- (void)loadDynamicSkinModels {
    [DynamicSkinsManager loadDynamicEffectsComplete:^(NSArray<KGDynamicMenuSkinCellMode *> *effects) {
        self.skinModes = effects;
        [self.skinCollectionView reloadData];
    }];
}

#pragma mark - 显示隐藏动画效果
- (void)showWithAnimation {
    [[UIApplication sharedApplication].keyWindow addSubview:self];

    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
    self.mainView.transform = CGAffineTransformMakeScale(0.001f,0.001f);
    self.mainView.center = shrinkedCenter;

    [UIView animateWithDuration:0.5 animations:^{
        self.mainView.transform = CGAffineTransformIdentity;
        self.mainView.center = normalCenter;
    }];
    
    if (self.selectIndex != 0) {    // 需要滑动到显示区域
        [self.skinCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.selectIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    }
}


- (void)dismissWithAnimation {
    
    CGPoint shrinkedCenter = centerFromFrame(self.shrinkedFrame);
    CGPoint normalCenter = centerFromFrame(self.normalFrame);
    
    self.mainView.transform = CGAffineTransformIdentity;
    self.mainView.center = normalCenter;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.mainView.transform = CGAffineTransformMakeScale(0.001f,0.001f);
        self.mainView.center = shrinkedCenter;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


// 点击空白区域需要隐藏
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.mainView.frame, point)) {
        [self dismissWithAnimation];
    }
}





@end
