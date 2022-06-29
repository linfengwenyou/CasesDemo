//
//  KGPlayViewVideoEntransListView.h
//  ContactBookDemo
//
//  Created by rayor on 2021/8/4.
//

#import <UIKit/UIKit.h>

typedef void(^didClickItemAction)(id model, NSInteger row);

@interface KGPlayViewVideoEntranceListView : UIView
/*初始位置点*/
@property (nonatomic, assign) CGPoint fromPoint;


/*显示容器*/
- (void)showContainer;
/*隐藏容器展示*/
- (void)hideContainer;

@end
