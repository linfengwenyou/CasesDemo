//
//  DynamicEffectsManager.m
//  DynamicDemo
//
//  Created by rayor on 2020/10/10.
//  Copyright © 2020 rayor. All rights reserved.
//

#import "DynamicSkinsManager.h"

@implementation DynamicSkinsManager

+ (void)loadDynamicEffectsComplete:(void (^)(NSArray<KGDynamicMenuSkinCellMode *> *))complete {
    NSArray *modes = [KGDynamicMenuSkinCellMode skinCellModes];
    !complete ?: complete(modes);
}

@end
