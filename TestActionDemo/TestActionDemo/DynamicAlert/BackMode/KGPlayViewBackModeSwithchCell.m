//
//  KGPlayViewBackModeSwithchCell.m
//  DynamicDemo
//
//  Created by rayor on 2021/9/29.
//  Copyright © 2021 rayor. All rights reserved.
//

#import "KGPlayViewBackModeSwithchCell.h"
#import <Masonry/Masonry.h>

@interface KGPlayViewBackModeSwithchCell ()
@property (nonatomic, strong) UISwitch *onSwitch;
@property (nonatomic, strong) UILabel *titleLabel;      // 主标   ， 副标通过属性字符串来展示
@end

@implementation KGPlayViewBackModeSwithchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubViews];
    }
    return self;
}


- (void)createSubViews {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    self.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:self.onSwitch];
    [self.contentView addSubview:self.titleLabel];
    
    
    // 添加约束信息
    [self.onSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(31);
        make.height.mas_equalTo(18);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.onSwitch.mas_right).mas_equalTo(11);
        make.centerY.mas_equalTo(self);
        make.right.mas_equalTo(self).mas_offset(-20);
    }];
    
    [self configDefaultValue];
}

- (void)configDefaultValue {
    self.onSwitch.on = YES;
    
    NSString *title = @"开启动感效果";
    NSString *subTitle = @"封面跟随歌曲节奏抖动";
    
    NSString *total = [title stringByAppendingFormat:@"  %@",subTitle];
    
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:total attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10], NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.4]}];
    [attr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSForegroundColorAttributeName:[UIColor colorWithWhite:1 alpha:0.6]} range:[total rangeOfString:title]];
    
    self.titleLabel.attributedText = attr;
}


- (void)didChangeSwithValue:(UISwitch *)sender {
    NSLog(@"%s",__func__);
}

#pragma mark - setter & getter
- (UISwitch *)onSwitch {
    if (!_onSwitch) {
        _onSwitch = [[UISwitch alloc] init];
        [_onSwitch addTarget:self action:@selector(didChangeSwithValue:) forControlEvents:UIControlEventValueChanged];
        _onSwitch.onImage = [UIImage imageNamed:@"svg_kg_common_ic_player_mode_dynamic@3x"];
        _onSwitch.onTintColor = UIColor.blueColor;
    }
    return _onSwitch;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.textColor = [UIColor colorWithWhite:1 alpha:0.6f];
    }
    return _titleLabel;
}

@end
