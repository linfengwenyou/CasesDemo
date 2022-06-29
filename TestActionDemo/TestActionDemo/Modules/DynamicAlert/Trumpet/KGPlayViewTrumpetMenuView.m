//
//  KGPlayViewTrumpetMenuView.m
//  DynamicDemo
//
//  Created by rayor on 2022/4/1.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "KGPlayViewTrumpetMenuView.h"
#import <Masonry/Masonry.h>

@interface KGPlayViewTrumpetMenuView ()
/* containerView */
@property (nonatomic, strong) UIView *picContainerView;

@property (nonatomic, strong, readwrite) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UIImageView *picImageView;
@end

@implementation KGPlayViewTrumpetMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.picContainerView];
    [self.picContainerView addSubview:self.picImageView];
 
    [self addSubview:self.titleLabel];
    [self addSubview:self.selectedImageView];
    
    [self.picContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(140);
    }];
    
    [self.picImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.picContainerView).mas_offset(5);
        make.right.mas_equalTo(self.picContainerView).mas_offset(-5);
        make.top.mas_equalTo(self.picContainerView).mas_offset(5);
        make.bottom.mas_equalTo(self.picContainerView).mas_offset(-5);
    }];
    
  
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.picContainerView.mas_bottom).offset(9);
        make.height.mas_equalTo(20);
    }];
    
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.picImageView);
        make.height.width.mas_equalTo(27);
    }];
    
    [self updateState:NO];  // 初始设置为NO
}

#pragma mark - action

- (void)updateState:(BOOL)selected {
    self.picContainerView.layer.borderWidth = selected ? 3 : 0;
    self.titleLabel.textColor = selected ? UIColor.blueColor : [UIColor colorWithWhite:1 alpha:0.7f];
    self.selectedImageView.hidden = !selected;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    !self.didTapViewAction ?: self.didTapViewAction();
}



#pragma mark - setter & getter
- (UIView *)picContainerView {
    if (!_picContainerView) {
        _picContainerView = [[UIView alloc] init];
        _picContainerView.layer.cornerRadius = 18.0f;
        _picContainerView.layer.borderWidth = 1.5;
        _picContainerView.layer.borderColor = [UIColor blueColor].CGColor;
    }
    return _picContainerView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}

- (void)setPicImage:(UIImage *)picImage {
    _picImage = picImage;
    self.picImageView.image = _picImage;
}

- (void)setSelected:(BOOL)selected {
    if (selected == _selected) {
        return;
    }
    _selected = selected;
    [self updateState:_selected];
}

- (UIImageView *)selectedImageView {
    if (!_selectedImageView) {
        _selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_mode_selected"]];
        _selectedImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _selectedImageView;
}

- (UIImageView *)picImageView {
    if (!_picImageView) {
        _picImageView = [[UIImageView alloc] init];
        _picImageView.contentMode = UIViewContentModeScaleAspectFill;
        _picImageView.layer.cornerRadius = 15;
        _picImageView.layer.masksToBounds = YES;
    }
    return _picImageView;
}

@end
