//
//  KGPlayViewBackModeCell.h
//  DynamicDemo
//
//  Created by rayor on 2021/9/29.
//  Copyright © 2021 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGPlayViewBackModel.h"

@interface KGPlayViewBackModeCell : UITableViewCell
@property (nonatomic, strong) KGPlayViewBackModel *model;

@property (nonatomic, assign) BOOL currentSelect;

/*cell高度*/
+ (CGFloat)cellHeight;
@end

