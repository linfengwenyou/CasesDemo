//
//  MyDynamicSliderView.h
//  DynamicDemo
//
//  Created by rayor on 2020/10/22.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyDynamicSliderView : UIView
/* 总共的锚点数量 */
- (instancetype)initWithFrame:(CGRect)frame anchors:(NSArray *)anchors;

@property(nonatomic, copy) void (^selectIndexBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
