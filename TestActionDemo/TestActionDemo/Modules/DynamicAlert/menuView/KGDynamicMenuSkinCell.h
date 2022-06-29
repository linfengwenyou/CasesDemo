//
//  DynamicMenuEffectCell.h
//  DynamicDemo
//
//  Created by rayor on 2020/10/10.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGDynamicMenuSkinCellMode : NSObject
@property(nonatomic, copy) NSString *skinId;
// 效果名称
@property(nonatomic, copy) NSString *name;
// 效果图片
@property (nonatomic, copy) NSString *icon;
// 是否需要收费，即代表svip可以使用
@property (nonatomic,assign) BOOL pay;


// 获取特效模型数组
+ (NSArray *)skinCellModes;

@end


@interface KGDynamicMenuSkinCell : UICollectionViewCell

// 模型
@property (nonatomic, strong) KGDynamicMenuSkinCellMode *model;

@end
