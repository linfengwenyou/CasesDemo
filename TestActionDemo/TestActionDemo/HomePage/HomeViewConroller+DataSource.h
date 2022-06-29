//
//  HomeViewConroller+DataSource.h
//  TestActionDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "HomeViewConroller.h"
#import "HomeViewDataModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeViewConroller (DataSource)

/// 返回首页所需要的数组
+ (NSArray <HomeViewDataModel *> *)homeViewModelArray;

@end

NS_ASSUME_NONNULL_END
