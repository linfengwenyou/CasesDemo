//
//  AnimationQueueManager.m
//  TestImageSwitch
//
//  Created by rayor on 2020/11/11.
//

#import "AnimationQueueManager.h"

@interface AnimationQueueManager ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation AnimationQueueManager

+ (instancetype)shareInstance {
    static AnimationQueueManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AnimationQueueManager alloc] init];
    });
    return instance;
}


- (void)addAnimationDuration:(float)duration withBlock:(void(^)(void))animateBlock {
    [self.queue addOperationWithBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
           animateBlock();
        });
        [NSThread sleepForTimeInterval:duration];
    }];
}


#pragma mark - setter
- (NSOperationQueue *)queue {
    if (!_queue) {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 1;
    }
    return _queue;
}


@end
