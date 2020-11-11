//
//  RASwitchImageView.m
//  TestImageSwitch
//
//  Created by rayor on 2020/11/11.
//

#import "RASwitchImageView.h"

@interface RASwitchImageView ()
/*图片信息*/
@property (nonatomic, strong) UIImageView *contentImageView;

/*图片信息*/
@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) NSOperationQueue *animationQueue;
// 构建一个队列，用来存储动画信息
@property (nonatomic, assign) CGFloat animationDuration;
@end

@implementation RASwitchImageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.animationDuration = 1;
        [self createSubViews];
    }
    return self;
}

- (void)createSubViews {
    [self addSubview:self.contentImageView];
    [self addSubview:self.coverImageView];
}


- (void)updateContentImageWithImage:(UIImage *)image {

    // 1. 构建一个图片浮层信息
    self.coverImageView.hidden = NO;
    
    self.contentImageView.image = image;
    
    self.coverImageView.alpha = 1;
    
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.coverImageView.alpha = 0;
    } completion:^(BOOL finished) {
        self.coverImageView.image = image;
    }];
}


#pragma mark - setter & getter

- (void)setImage:(UIImage *)image {
    _image = image;

    __weak typeof(self) weakSelf = self;
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf updateContentImageWithImage:image];
        });
        [NSThread sleepForTimeInterval:self.animationDuration]; // 通过队列的方式进行操作
    }];
    
    [self.animationQueue addOperation:op];
}


- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImageView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        _coverImageView.alpha = 0;
    }
    return _coverImageView;
}

- (NSOperationQueue *)animationQueue {
    if (!_animationQueue) {
        _animationQueue = [[NSOperationQueue alloc] init];
        _animationQueue.maxConcurrentOperationCount = 1;
    }
    return _animationQueue;
}
@end
