//
//  KGPlayViewBackModel.h
//  DynamicDemo
//
//  Created by rayor on 2021/9/29.
//  Copyright © 2021 rayor. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KGPlayViewBackModelType) {
    KGPlayViewBackModelType_Rotate  = 1,
    KGPlayViewBackModelType_Singer,
    KGPlayViewBackModelType_fullAlbum,
    KGPlayViewBackModelType_rectAlbum,
};


@interface KGPlayViewBackModel : NSObject

@property (nonatomic, assign) KGPlayViewBackModelType tye;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *titleName;

// 不要使用selected 
+ (NSArray *)getAllModeModels;
@end
