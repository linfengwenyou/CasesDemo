//
//  KGPlayVIewVIdeoEntranceCell.m
//  ContactBookDemo
//
//  Created by rayor on 2021/8/4.
//

#import "KGPlayViewVideoEntranceListCell.h"

@interface KGPlayViewVideoEntranceListCell ()
/*小说容器*/
@property (nonatomic, strong) UIView *novelContainer;


/*mv容器*/
@property (nonatomic, strong) UIView *mvContainer;


@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation KGPlayViewVideoEntranceListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}


- (void)createSubViews {
    
    self.layer.cornerRadius = 6.0f;
    self.layer.masksToBounds = YES;
    
    
    [self.contentView addSubview:self.novelContainer];
    [self.contentView addSubview:self.mvContainer];
    
    [self.contentView addSubview:self.imageView];
    
#warning lius 测试
    UIColor *randomColor = [[UIColor alloc] initWithRed:arc4random() %255/255.0 green:arc4random() %255/255.0 blue:arc4random() %255/255.0 alpha:1];
    self.backgroundColor = randomColor;
}

- (void)refresh {
    [self setNeedsUpdateConstraints];
}


- (void)updateConstraints {
    
    [self.novelContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.mvContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    
    // call super
    [super updateConstraints];
}


#pragma mark - getter
- (UIView *)novelContainer {
    if (!_novelContainer) {
        _novelContainer = [[UIView alloc] init];
    }
    return _novelContainer;
}


- (UIView *)mvContainer {
    if (!_mvContainer) {
        _mvContainer = [[UIView alloc] init];
    }
    return _mvContainer;
}


- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.image = [UIImage imageNamed:@"2.jpg"];
    }
    return _imageView;
}

@end
