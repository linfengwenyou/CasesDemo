//
//  DynamicEffectsManager.h
//  DynamicDemo
//
//  Created by rayor on 2020/10/10.
//  Copyright © 2020 rayor. All rights reserved.
//
// 单例，管理模型信息
#import <Foundation/Foundation.h>
#import "KGDynamicMenuSkinCell.h"

@interface DynamicSkinsManager : NSObject

+ (void)loadDynamicEffectsComplete:(void(^)(NSArray <KGDynamicMenuSkinCellMode *> *skins))complete;

@end
