//
//  RASwitchImageController.m
//  TestActionDemo
//
//  Created by rayor on 2020/11/11.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "RASwitchImageController.h"
#import "RASwitchImageView.h"

@interface RASwitchImageController ()

@property (nonatomic, strong) RASwitchImageView *imageView;

@property (nonatomic, strong) UILabel *label;

@end

@implementation RASwitchImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.label];
}

static int indexValue = 1;

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches
              withEvent:event];
    indexValue ++;
    if (indexValue > 5) {
        indexValue = 1;
    }
    NSString *imageName = [NSString stringWithFormat:@"%d.jpg",indexValue];
    self.imageView.image = [UIImage imageNamed:imageName];
    // 动态刷新图片
    self.label.text = imageName;
}


#pragma mark - setter
- (RASwitchImageView *)imageView {
    if (!_imageView) {
        _imageView = [[RASwitchImageView alloc] initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"1.jpg"];
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 60, self.view.bounds.size.width, 44)];
        _label.textColor = UIColor.redColor;
        _label.font = [UIFont systemFontOfSize:17];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
