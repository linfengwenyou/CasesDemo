//
//  KGPLayViewVideoEntranceMainView.m
//  ContactBookDemo
//
//  Created by rayor on 2021/8/6.
//

#import "KGPLayViewVideoEntranceMainView.h"
#import "KGPlayViewVideoEntranceView.h"
#import "KGPlayViewVideoEntranceListView.h"

@interface KGPLayViewVideoEntranceMainView ()
/*入口视图*/
@property (nonatomic, strong) KGPlayViewVideoEntranceView *entranceView;
/*列表容器视图*/
@property (nonatomic, strong) KGPlayViewVideoEntranceListView *videoListView;
/*是否展开*/
@property (nonatomic, assign) BOOL isUnfold;
@end


@implementation KGPLayViewVideoEntranceMainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createSubViews];
    }
    return self;
}


- (void)createSubViews {
    
    [self addSubview:self.videoListView];
    [self addSubview:self.entranceView];
    
    self.entranceView.badgeValue = 5 + arc4random() % 200;
    
}


- (void)updateConstraints {
    
    [self.videoListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(200);
    }];
    
    [self.entranceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(60);
    }];
    
    [super updateConstraints];
}

#pragma mark - public
- (void)refreshWithData:(NSDictionary *)data {
    CGPoint center = [self convertPoint:self.entranceView.center toView:self.videoListView];
    self.videoListView.fromPoint = center;
}


#pragma mark - event

- (void)didClickEntranceAction:(UIButton *)sender {
    if (self.isUnfold == NO) {
        [self.videoListView showContainer];
    } else {
        [self.videoListView hideContainer];
    }
    self.isUnfold = !self.isUnfold;
    [self.entranceView updateEntransViewWithIsUnfold:self.isUnfold];
}

#pragma mark - getter
- (KGPlayViewVideoEntranceView *)entranceView {
    if (!_entranceView) {
        _entranceView = [[KGPlayViewVideoEntranceView alloc] init];
        [_entranceView.coverButton addTarget:self action:@selector(didClickEntranceAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _entranceView;
}

- (KGPlayViewVideoEntranceListView *)videoListView {
    if (!_videoListView) {
        _videoListView = [[KGPlayViewVideoEntranceListView alloc] init];
    }
    return _videoListView;
}


@end
