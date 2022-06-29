//
//  KGPlayViewVideoEntranceView.h
//  ContactBookDemo
//
//  Created by rayor on 2021/8/4.
//

#import <UIKit/UIKit.h>

// 1. 两个视图层叠
// 2. 有点击事件
// 3. 存在浮标标识当前有多少个数据

@interface KGPlayViewVideoEntranceView : UIView

/*点击按钮，用来处理事件*/
@property (nonatomic, strong, readonly) UIButton *coverButton;

/*标记数量*/
@property (nonatomic, assign) NSInteger badgeValue;

/*显示两个图片数组，如果没有值，可以使用默认占位图处理*/
@property (nonatomic, strong) NSArray *imageUrls;

/*更新当前状态,是否为折叠状态*/
- (void)updateEntransViewWithIsUnfold:(BOOL)unfold;

@end
