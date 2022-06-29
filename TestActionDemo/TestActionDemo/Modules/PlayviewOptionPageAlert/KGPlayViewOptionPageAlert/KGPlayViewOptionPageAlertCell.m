//
//  KGPlayViewOptionPageAlertCell.m
//  ContactBookDemo
//
//  Created by rayor on 2022/2/24.
//

#import "KGPlayViewOptionPageAlertCell.h"

@interface KGPlayViewOptionPageAlertCell ()
// 只是用作圆角展示，此处不切角，为了让右上角显示打钩选项
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *label;

// 选中的视图展示
@property (nonatomic, strong) UIImageView *selectIconView;

@end

@implementation KGPlayViewOptionPageAlertCell

-  (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubviews];
    }
    return self;
}

#pragma mark - 注意皮肤适配问题

- (void)createSubviews {
  
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.iconView];
    [self.backView addSubview:self.label];
    
    [self.contentView addSubview:self.selectIconView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(50, 64));
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.width.height.mas_equalTo(24);
        make.centerX.mas_equalTo(self.backView);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).mas_offset(6);
        make.left.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(11);
    }];
    
    [self.selectIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backView.mas_right).mas_offset(-3);
        make.centerY.mas_equalTo(self.backView.mas_top).mas_offset(3);
        make.width.height.mas_offset(15);
    }];
    
}


#pragma mark - setter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.layer.cornerRadius= 9;
        _backView.layer.masksToBounds = YES;
    }
    return _backView;
}


- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"text tes";
        _label.font = [UIFont systemFontOfSize:11];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}


- (UIImageView *)selectIconView {
    if (!_selectIconView) {
        _selectIconView = [[UIImageView alloc] init];
        _selectIconView.contentMode = UIViewContentModeScaleAspectFit;
        _selectIconView.backgroundColor = [UIColor colorWithRed:0/255.0 green:186/255.0 blue:255/255.0 alpha:1.0];
        _selectIconView.layer.cornerRadius = 7.5f;
        _selectIconView.layer.masksToBounds = YES;
        _selectIconView.layer.shouldRasterize = YES;
        
        UIImage *selectImage = [UIImage imageNamed:@"player_bgmode_popups_ic_selcted"];
        _selectIconView.image = selectImage;
    }
    return _selectIconView;
}


- (void)setOptionType:(KGPlayViewOptionType)optionType {
    _optionType = optionType;
    
    NSString *iconName = [KGPlayViewOptionPageConfig optionPageIconNameWithType:_optionType];
    NSString *pageName = [KGPlayViewOptionPageConfig optionPageTitleWithType:_optionType];
    self.iconView.image = [[UIImage imageNamed:iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.label.text = pageName;
    
    [self refreshUIState];
    
}

// 刷新UI展示
- (void)refreshUIState {
    BOOL selected = [KGPlayViewOptionPageConfig shareManager].currentType == _optionType;
    
    self.selectIconView.alpha = selected ? 1 : 0;
      
    // 底景
    UIColor *backColor = selected ? [UIColor colorWithRed:0/255.0 green:186/255.0 blue:255/255.0 alpha:0.12] : [UIColor colorWithWhite:1 alpha:0.08f];
    self.backView.backgroundColor = backColor;
    
    UIColor *tintColor = selected ? [UIColor colorWithRed:0/255.0 green:186/255.0 blue:255/255.0 alpha:1.0] :[UIColor colorWithWhite:1 alpha:0.8f];
    
    self.iconView.tintColor = tintColor;
    
    UIColor *textColor = selected ? [UIColor colorWithRed:0/255.0 green:186/255.0 blue:255/255.0 alpha:1.0] :[UIColor colorWithWhite:1 alpha:0.9f];
    self.label.textColor = textColor;
}


#warning lius 需要注意使用[UIView animation] 这种label.text是不会进行动画，对于这种需要整体进行调整的动画可以使用转场动画更方便实现，使用渐隐溶解的方式
- (void)updateStateWithAnimation:(BOOL)animate {
    __weak typeof(self) weakSelf = self;
    [UIView transitionWithView:self.contentView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [weakSelf refreshUIState];
    } completion:^(BOOL finished) {
    }];
    
}

@end
