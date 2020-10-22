//
//  MyCoverView.m
//  TestActionDemo
//
//  Created by rayor on 2020/7/9.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "MyCoverView.h"

@implementation MyCoverView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    // 判断是否存在子视图，无子视图则不相应任何事件
    BOOL isSubViewCanResponder = NO;
    for (UIView *subView in self.subviews) {
        if (CGRectContainsPoint(subView.frame, point)) {
            isSubViewCanResponder = YES;
        }
    }
    
    if (isSubViewCanResponder) {
        return [super hitTest:point withEvent:event];
    }
    return nil;
}
@end
