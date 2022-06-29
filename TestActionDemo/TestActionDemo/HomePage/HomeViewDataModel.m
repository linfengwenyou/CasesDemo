//
//  HomeViewDataModel.m
//  TestActionDemo
//
//  Created by rayor on 2022/6/29.
//  Copyright © 2022 rayor. All rights reserved.
//

#import "HomeViewDataModel.h"

@implementation HomeViewDataModel

- (instancetype)initWithTitle:(NSString *)title className:(NSString *)className {
    if (self = [super init]) {
        _title = title;
        _className = className;
    }
    return self;
}


+ (instancetype)dataModelWithTitle:(NSString *)title className:(NSString *)className {
    return [[self alloc] initWithTitle:title className:className];
}
@end
