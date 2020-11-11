//
//  AnimationQueueManager.h
//  TestImageSwitch
//
//  Created by rayor on 2020/11/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimationQueueManager : NSObject
+ (instancetype)shareInstance;


/// 添加动画，其中包含动画需要执行的时间
/// @param duration 动画需要执行的时间
/// @param animateBlock 动画block信息
- (void)addAnimationDuration:(float)duration withBlock:(void(^)(void))animateBlock;

@end

NS_ASSUME_NONNULL_END
