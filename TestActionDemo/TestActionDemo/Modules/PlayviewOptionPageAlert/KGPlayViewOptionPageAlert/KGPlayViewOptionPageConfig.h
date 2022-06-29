//
//  KGPlayviewOptionPageConfig.h
//  ContactBookDemo
//
//  Created by rayor on 2022/2/24.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, KGPlayViewOptionType) {
    KGPlayViewOptionType_None = 0,          // 无
    KGPlayViewOptionType_MV,                // 竖屏MV / 剧场
    KGPlayViewOptionType_Heartbeat,         // 心动模式
    KGPlayViewOptionType_Trumpet,           // 律动模式
    KGPlayViewOptionType_Spectrum,          // 频谱
    KGPlayViewOptionType_Dynamic,           // 动感写真
};



NS_ASSUME_NONNULL_BEGIN

@interface KGPlayViewOptionPageConfig : NSObject

// 单例读取
+ (instancetype)shareManager;

// 当前选中的类型
@property (nonatomic, assign, readonly) KGPlayViewOptionType currentType;

/*更新方法*/
- (void)updateCurrentType:(KGPlayViewOptionType)currentType;

#pragma mark - public


/*获取所有类型信息*/
+ (NSArray *)optionPageList;

/*获取类型名*/
+ (NSString *)optionPageTitleWithType:(KGPlayViewOptionType)type;

/*获取图片名称*/
+ (NSString *)optionPageIconNameWithType:(KGPlayViewOptionType)type;




@end

NS_ASSUME_NONNULL_END
