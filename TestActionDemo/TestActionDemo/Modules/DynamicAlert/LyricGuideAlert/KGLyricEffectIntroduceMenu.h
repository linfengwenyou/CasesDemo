//
//  KGLyricEffectIntroduceMenu.h
//  DynamicDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 选中的颜色
#define kLyricSelectedColor [UIColor colorWithRed:0/255.0 green:186/255.0 blue:255/255.0 alpha:1.0]

@interface KGLyricEffectIntroduceMenu : UIView
@property(nonatomic, copy) NSString *title;
/* 设置是否选中 */
@property (nonatomic,assign) BOOL selected;

// 是否正在显示，与selected共同决定是否要播放视频
@property (nonatomic, assign) BOOL isAppear;


@property (nonatomic, copy) void(^didTapViewAction)(void);

/* 蛇者图片url，及MV展示 */
- (void)setupImageUrl:(NSString *)url isMV:(BOOL)isMV;
@end

NS_ASSUME_NONNULL_END
