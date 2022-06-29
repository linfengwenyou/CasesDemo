//
//  KGPlayViewBackModel.m
//  DynamicDemo
//
//  Created by rayor on 2021/9/29.
//  Copyright © 2021 rayor. All rights reserved.
//

#import "KGPlayViewBackModel.h"

@implementation KGPlayViewBackModel

+ (NSString *)iconNameWithType:(KGPlayViewBackModelType)type {
    NSString *iconName = nil;
    
    switch (type) {
        case KGPlayViewBackModelType_Rotate:
            iconName = @"kg_icon_player_menu_mode_cd2_spin";
            break;
        case KGPlayViewBackModelType_Singer:
            iconName = @"kg_icon_player_menu_mode_cd2_photo";
            break;
        case KGPlayViewBackModelType_fullAlbum:
            iconName = @"kg_icon_player_menu_mode_cd2_default";
            break;
        case KGPlayViewBackModelType_rectAlbum:
            iconName = @"kg_icon_player_menu_mode_cd2_square";
            break;
    }
    return iconName;
}

+ (NSString *)titleWithType:(KGPlayViewBackModelType)type {
    NSString *name = nil;
    
    switch (type) {
        case KGPlayViewBackModelType_Rotate:
            name = @"旋转封面";
            break;
        case KGPlayViewBackModelType_Singer:
            name = @"歌手写真";
            break;
        case KGPlayViewBackModelType_fullAlbum:
            name = @"全屏封面";
            break;
        case KGPlayViewBackModelType_rectAlbum:
            name = @"方形封面";
            break;
    }
    return name;
}



+ (KGPlayViewBackModel *)backModelWithType:(KGPlayViewBackModelType)type {
    KGPlayViewBackModel *model = [[KGPlayViewBackModel alloc] init];
    model.tye = type;
    model.iconName = [self iconNameWithType:type];
    model.titleName = [self titleWithType:type];
    return model;
}

+ (NSArray *)getAllModeModels {
    NSMutableArray *tmp = @[].mutableCopy;
    for (int i = KGPlayViewBackModelType_Rotate; i<=KGPlayViewBackModelType_rectAlbum; i++) {
        @autoreleasepool {
            KGPlayViewBackModel *model = [self backModelWithType:i];
            [tmp addObject:model];
#warning lius 此处记得处理走查问题
        }
    }
    return tmp;
}

@end
