//
//  KGPlayQueueTabCell.m
//  KGAreaSelectDemo
//
//  Created by rayor on 2022/6/9.
//

#import "KGPlayQueueTabCell.h"

@interface KGPlayQueueTabCell ()

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *leftLine;
@end

@implementation KGPlayQueueTabCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    // 处理一个label, 一个标签位置
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.leftLine];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(13);
    }];

}


#pragma mark - setter & getter
- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = _name;
}

- (void)setShowLine:(BOOL)showLine {
    _showLine = showLine;
    self.leftLine.hidden = !showLine;
}

- (void)setCurrentSelect:(BOOL)currentSelect {
    _currentSelect = currentSelect;
    self.nameLabel.textColor = currentSelect ? UIColor.blackColor : [UIColor.blackColor colorWithAlphaComponent:0.7];
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:15];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _nameLabel;
}

- (UIView *)leftLine {
    if (!_leftLine) {
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = [UIColor redColor];
        _leftLine.hidden = YES;
    }
    return _leftLine;
}

@end
