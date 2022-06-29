//
//  KGPlayViewBackModeCell.m
//  DynamicDemo
//
//  Created by rayor on 2021/9/29.
//  Copyright © 2021 rayor. All rights reserved.
//

#import "KGPlayViewBackModeCell.h"
#import <Masonry/Masonry.h>

@interface KGPlayViewBackModeCell ()
@property (nonatomic, strong) UIImageView *iconView;    // 图标名
@property (nonatomic, strong) UILabel *titleLabel;      // 主标
@property (nonatomic, strong) UIImageView *checkImageView;  // 打钩选中
@end

@implementation KGPlayViewBackModeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}


- (void)createSubViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.backgroundColor = UIColor.clearColor;
    
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.checkImageView];
    
    // 设置约束
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(17);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(24);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).mas_offset(15);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(-20);
    }];
    
    [self.checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-22);
        make.centerY.mas_equalTo(self);
        make.width.height.mas_equalTo(24);
    }];
    
}


- (void)setModel:(KGPlayViewBackModel *)model {
    _model = model;
    
    self.iconView.image = [[UIImage imageNamed:_model.iconName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.titleLabel.text = _model.titleName;
}

- (void)setCurrentSelect:(BOOL)currentSelect {
    _currentSelect = currentSelect;
    
    UIColor *color = [self tintColorForSelect:currentSelect];
    self.iconView.tintColor = color;
    self.titleLabel.textColor = color;
    self.checkImageView.hidden = !currentSelect;
}


- (UIColor *)tintColorForSelect:(BOOL)select {
    return select ? UIColor.blueColor : [UIColor colorWithWhite:1 alpha:0.6f];
}

#pragma mark - setter & getter
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
        _iconView.contentMode = UIViewContentModeCenter;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel  = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6f];
        _titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _titleLabel;
}
- (UIImageView *)checkImageView {
    if (!_checkImageView) {
        _checkImageView = [[UIImageView alloc] init];
        _checkImageView.contentMode = UIViewContentModeCenter;
        _checkImageView.image = [[UIImage imageNamed:@"svg_kg_playpage_mask_mode_ic_selcted"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _checkImageView.tintColor = [self tintColorForSelect:YES];
    }
    return _checkImageView;
}
#pragma mark - 高度配置
+ (CGFloat)cellHeight {
    return 50.0f;
}
@end
