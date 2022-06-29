//
//  HollowButton.m
//  TestActionDemo
//
//  Created by rayor on 2021/3/23.
//  Copyright © 2021 rayor. All rights reserved.
//

#import "HollowButton.h"

@interface HollowButton ()
/*背景颜色*/
@property (nonatomic, strong) UIColor *backRectColor;
@end

@implementation HollowButton

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (void)setBackgroundColor:(UIColor *)backgroundColor {
    
    [super setBackgroundColor:[UIColor clearColor]];
    self.backRectColor = backgroundColor;
    // 注意，此处需要拦截方法，不能让其生效，只能让其存储下来在绘制时使用， 真实背景需要清屏
}


- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    [self setNeedsDisplay];
}

- (void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    [super setImageEdgeInsets:imageEdgeInsets];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    [self clearContextInRect:rect];
    
    if (self.backRectColor == [UIColor clearColor]) {  // 会清屏，导致看不到数据，尽量不要这样做
        // 清理原来屏幕数据
        self.imageView.hidden = NO;
        self.titleLabel.hidden = NO;
        NSLog(@"设置背景颜色为原有颜色，不做任何操作");
        [super drawRect:rect];
        return;
    }
    
    //    NSLog(@"使用镂空效果");
    // 设置背景效果
    [self.backRectColor setFill];
    UIRectFill(rect);
    
    // 获取上下文设置
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 先保存当前上下文，因为自己之后要改写上下文信息了，等改写使用 后要还原
    CGContextSaveGState(context);
    
    
    /*自己可以随意操作了*/
    
    NSString *title = self.currentTitle;
    UIImage *image = self.currentImage;
    
    CGContextSetBlendMode(context, kCGBlendModeDestinationOut);
    [title drawInRect:self.titleLabel.frame withAttributes:@{NSFontAttributeName:self.titleLabel.font, NSForegroundColorAttributeName:self.currentTitleColor}];
    //    [self setTitleColor:UIColor.clearColor forState:UIControlStateNormal];  // 隐藏原有的数据新
    
    CGContextDrawImage(context, self.imageView.frame, image.CGImage);

    self.titleLabel.hidden = YES;
    self.imageView.hidden = YES;
    
    // 还原上下文
    CGContextRestoreGState(context);
    
}

- (void)clearContextInRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
}
@end
