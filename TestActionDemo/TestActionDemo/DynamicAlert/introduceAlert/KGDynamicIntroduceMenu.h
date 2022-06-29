//
//  KGDynamicIntroduceMenu.h
//  DynamicDemo
//
//  Created by rayor on 2020/10/30.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGDynamicIntroduceMenu : UIView

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subTitle;
/* 设置是否选中 */
@property (nonatomic,assign) BOOL selected;

/* 是否为新特性 */
@property (nonatomic,assign) BOOL newFeature;

@property (nonatomic, copy) void(^didTapViewAction)(void);

/* 蛇者图片url，及MV展示 */
- (void)setupImageUrl:(NSString *)url isMV:(BOOL)isMV;
@end

NS_ASSUME_NONNULL_END
