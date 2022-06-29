//
//  UIView+Frame.m
//  DynamicDemo
//
//  Created by rayor on 2020/10/30.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

#pragma mark - public
CGPoint centerFromFrame(CGRect frame) {
    return CGPointMake(frame.origin.x + frame.size.width/2.0f, frame.origin.y + frame.size.height/2.0f);
}


CGRect frameFromCenterSize(CGPoint center, CGSize size) {
    return CGRectMake(center.x - size.width/2.0f, center.y - size.height/2.0f, size.width, size.height);
}


- (CGFloat)x {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)y {
    return CGRectGetMinY(self.frame);
}

- (CGFloat)width {
    return self.frame.size.width;
}

-  (CGFloat)height {
    return self.frame.size.height;
}

@end
