//
//  BannersView.h
//  TestActionDemo
//
//  Created by Buck on 2025/6/2.
//  Copyright © 2025 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didClickItemAction)(id model, NSInteger row);
NS_ASSUME_NONNULL_BEGIN

@interface BannersView : UIView

@property(nonatomic, assign) NSInteger defaultIndex;
/*显示容器*/
- (void)showContainer;
@end

NS_ASSUME_NONNULL_END
