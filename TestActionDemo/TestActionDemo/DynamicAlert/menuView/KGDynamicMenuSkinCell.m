//
//  DynamicMenuEffectCell.m
//  DynamicDemo
//
//  Created by rayor on 2020/10/10.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "KGDynamicMenuSkinCell.h"
#import <Masonry.h>

@implementation KGDynamicMenuSkinCellMode
- (instancetype)initWithName:(NSString *)name imageName:(NSString *)imageName isSvip:(BOOL)svip {
    if (self = [super init]) {
        _name = name;
        _icon = imageName;
        _pay = svip;
    }
    return self;
}


+ (NSArray *)skinCellModes {
    NSMutableArray *tmpArr = @[].mutableCopy;
    
    // 快速抖动
    for (int i = 0; i<10; i++) {
        KGDynamicMenuSkinCellMode *mode = [[KGDynamicMenuSkinCellMode alloc] initWithName:@"快速抖动" imageName:@"largeShake@3x" isSvip:YES];
        [tmpArr addObject:mode];
    }
    
    // 通过接口获取：https://webfile.yun.kugou.com/soclip_skin_v5.json
    // 连续闪动
    
    // 偏移闪动
    
    // 放大抖动
    
    // 缩小抖动
    
    // 曝光偏移
    
    return tmpArr;
}

@end

@interface KGDynamicMenuSkinCell ()
// 底图，图片，标题
@property (nonatomic, strong) UIView *picBackView;

@property (nonatomic, strong) UIImageView *picView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *svipView;
@end

@implementation KGDynamicMenuSkinCell

- (instancetype)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
   
    // 构建一个装图片的容器
    [self.contentView addSubview:self.picBackView];
    [self.picBackView addSubview:self.picView];
    [self.contentView addSubview:self.svipView];
    [self.contentView addSubview:self.nameLabel];
    
    [self.picBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(7);
        make.width.height.mas_equalTo(58);
    }];
    
    
    [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.picBackView);
    }];
    
    [self.svipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.picBackView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.picBackView.mas_bottom).offset(6.5);
        make.centerX.mas_equalTo(self.picBackView);
    }];
    
}



#pragma mark - setter & getter

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    UIColor *tintColor = selected ? [UIColor redColor] : [UIColor clearColor];
    UIColor *textColor = selected ? tintColor : [UIColor colorWithWhite:1 alpha:0.5];
    
    self.picBackView.layer.borderColor = tintColor.CGColor;
    self.picView.tintColor = tintColor;
    self.nameLabel.textColor = textColor;
}

- (void)setModel:(KGDynamicMenuSkinCellMode *)model {
    _model = model;
    self.picView.image = [UIImage imageNamed:model.icon];
    self.nameLabel.text = model.name;
    self.svipView.hidden = !model.pay;
}


- (UIView *)picBackView {
    if (!_picBackView) {
        _picBackView = [UIView new];
        _picBackView.layer.borderWidth = 1.5f;
        _picBackView.layer.cornerRadius = 6;
        _picBackView.layer.borderColor = [UIColor redColor].CGColor;
        _picBackView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.08];
        _picBackView.layer.masksToBounds = YES;
        
    }
    return _picBackView;
}

- (UIImageView *)picView {
    if (!_picView) {
        _picView = [UIImageView new];
        _picView.contentMode = UIViewContentModeCenter;
    }
    return _picView;
}


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        _nameLabel.font = [UIFont systemFontOfSize:10];
        _nameLabel.text = @"";
    }
    return _nameLabel;
}

- (UIImageView *)svipView {
    if (!_svipView) {
        _svipView = [UIImageView new];
        _svipView.image = [UIImage imageNamed:@"svip_tag"];
    }
    return _svipView;
}

@end
