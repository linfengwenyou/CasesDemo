//
//  GradientImageController.m
//  TestActionDemo
//
//  Created by rayor on 2020/9/3.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "GradientImageController.h"
#import "GradientImage.h"

@interface GradientImageController ()
@property (weak, nonatomic) IBOutlet UIButton *mybutton;
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@end

@implementation GradientImageController

- (void)viewDidLoad {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.view.backgroundColor = [UIColor blueColor];
}


- (IBAction)didClickAction:(id)sender {
    
    NSLog(@"点击测试按钮");
    
    UIView *view = [self.view viewWithTag:200];
    if (view) {
        [view removeFromSuperview];
    }
    
    
    CGFloat red = arc4random() % 255 / 255.0f;
    CGFloat green = arc4random() % 255 / 255.0f;
    CGFloat blue = arc4random() % 255 / 255.0f;
    
    NSArray *colors = @[(id)[UIColor colorWithRed:red  green:green  blue:blue alpha:0.85].CGColor,
                        (id)[UIColor colorWithRed:red  green:green  blue:blue alpha:0.6].CGColor,
                        (id)[UIColor colorWithRed:red  green:green  blue:blue alpha:0.0].CGColor];

    UIColor *randColor = [UIColor colorWithRed:arc4random()%255 / 255.0f green:arc4random()%255 / 255.0f blue:arc4random()%255 / 255.0f alpha:1];

    UIImageView *imgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    imgView.tag = 200;
    [self.view insertSubview:imgView aboveSubview:self.picView];
    
    
    UIImage *image1 = [GradientImage imageWithFrame:[UIScreen mainScreen].bounds locations:@[@0.3f,@0.6f,@1.0f] colors:colors];
    imgView.image = image1;
    
    
    UIImage *image2 = [GradientImage imageWithFrame:[UIScreen mainScreen].bounds locations:@[@0.3f,@0.6f,@1.0f] backColor:randColor opaqueValues:@[@0.5,@0.6,@0]];
    imgView.image = image2;
    
    
    UIImage *image = [GradientImage imageWithImage:[UIImage imageNamed:@"2.png"] locations:@[@0,@0.3,@1.0f] opaqueValues:@[@1,@1,@0]];
    imgView.image = image;
    
    
}

@end
