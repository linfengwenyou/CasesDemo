//
//  UIView+Frame.h
//  DynamicDemo
//
//  Created by rayor on 2020/10/30.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Frame)
CGPoint centerFromFrame(CGRect frame);
CGRect frameFromCenterSize(CGPoint center, CGSize size);
@end

NS_ASSUME_NONNULL_END
