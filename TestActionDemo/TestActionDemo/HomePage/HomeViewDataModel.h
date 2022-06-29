//
//  HomeViewDataModel.h
//  TestActionDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewDataModel : NSObject
/// 标题
@property (nonatomic, copy) NSString *title;
/// nib name 用来生成xib文件进行数据展示的, nib需要与classname保持一样，方便转换
@property (nonatomic, copy) NSString *className;

+ (instancetype)dataModelWithTitle:(NSString *)title className:(NSString *)className;
@end

NS_ASSUME_NONNULL_END
