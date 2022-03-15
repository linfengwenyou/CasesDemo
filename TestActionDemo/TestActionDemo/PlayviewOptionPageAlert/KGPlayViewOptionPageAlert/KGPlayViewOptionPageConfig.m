//
//  KGPlayviewOptionPageConfig.m
//  ContactBookDemo
//
//  Created by rayor on 2022/2/24.
//

#import "KGPlayViewOptionPageConfig.h"

@interface KGPlayViewOptionPageConfig ()
// 当前选中的类型
@property (nonatomic, assign, readwrite) KGPlayViewOptionType currentType;
@end

@implementation KGPlayViewOptionPageConfig


+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    static KGPlayViewOptionPageConfig *instance;
    dispatch_once(&onceToken, ^{
        instance = [[KGPlayViewOptionPageConfig alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [self launchConfigCurrentType];
    }
    return self;
}


- (void)updateCurrentType:(KGPlayViewOptionType)currentType {
    _currentType = currentType;
    [[NSUserDefaults standardUserDefaults] setObject:@(currentType) forKey:@"kSavedCurrentKey"];
}

- (void)launchConfigCurrentType {
    NSNumber *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"kSavedCurrentKey"];
    if (value == nil) {
        _currentType = KGPlayViewOptionType_MV;
        [self updateCurrentType:_currentType];
    }
    _currentType = [value integerValue];
}

#pragma mark - public

+ (NSArray *)optionPageList {
    return @[
        @(KGPlayViewOptionType_MV),             // MV
        @(KGPlayViewOptionType_Trumpet),        // 律动
        @(KGPlayViewOptionType_Spectrum),       // 频谱
        @(KGPlayViewOptionType_Dynamic),        // 动感
        @(KGPlayViewOptionType_Heartbeat)       // 心跳
    ];
}


/*获取类型名*/
+ (NSString *)optionPageTitleWithType:(KGPlayViewOptionType)type {
    
    NSString *name = nil;
    
    switch (type) {
        case KGPlayViewOptionType_MV:
            name = @"MV";
            break;
        case KGPlayViewOptionType_Heartbeat:
            name = @"心动";
            break;
            
        case KGPlayViewOptionType_Trumpet:
            name = @"律动";
            break;
            
        case KGPlayViewOptionType_Spectrum:
            name = @"频谱";
            break;
            
        case KGPlayViewOptionType_Dynamic:
            name = @"动感";
            break;
            
        default:
            break;
    }
    
    return name;
}

/*获取图片名称*/
+ (NSString *)optionPageIconNameWithType:(KGPlayViewOptionType)type {
    NSString *name = nil;
    
    switch (type) {
        case KGPlayViewOptionType_MV:
            name = @"player_bgmode_popups_ic_mv";
            break;
        case KGPlayViewOptionType_Heartbeat:
            name = @"player_bgmode_popups_ic_heartbeat";
            break;
            
        case KGPlayViewOptionType_Trumpet:
            name = @"player_bgmode_popups_ic_trumpet";
            break;
            
        case KGPlayViewOptionType_Spectrum:
            name = @"player_bgmode_popups_ic_spectrum";
            break;
            
        case KGPlayViewOptionType_Dynamic:
            name = @"player_bgmode_popups_ic_dynamic";
            break;
            
        default:
            break;
    }
    
    return name;
}



@end
