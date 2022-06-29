//
//  KGDynamicIntroduceAlert.h
//  DynamicDemo
//
//  Created by rayor on 2020/10/30.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KGDynamicIntroduceType) {
    KGDynamicIntroduceType_SingerPhoto = 0,             // 普通写真
    KGDynamicIntroduceType_DynamicSingerPhoto,          // 动感写真
};

@interface KGDynamicIntroduceAlert : UIView

- (void)showWithShrinkedFrame:(CGRect)shrinkedFrame;

/* 选中模式的回调*/
@property (nonatomic, copy) void(^didSelectSingerMode)(KGDynamicIntroduceType singerMode);

@end
