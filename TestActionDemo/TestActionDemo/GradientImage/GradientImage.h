//
//  GradientImage.h
//  DemoTest
//
//  Created by rayor on 2020/8/31.
//  Copyright © 2020 rayor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GradientImage : NSObject

/* 初始化一个渐变图层展示, 注意颜色为CGColor类型
 * 当颜色可以设置透明度时使用此效果来操作
 * 渐变方向：从上到下
 */
+ (UIImage *)imageWithFrame:(CGRect)frame locations:(NSArray *)locations colors:(NSArray *)colors;

/* 初始化一个渐变层，颜色值固定为背景颜色，通过遮罩的方式
 * opaques为每个位置的不透明度
 * 渐变方向：从上到下
 */
+ (UIImage *)imageWithFrame:(CGRect)frame locations:(NSArray *)locations backColor:(UIColor *)backColor opaqueValues:(NSArray *)opaques;

/* 获取一个渐变图片信息，location为渐变位置，opaques为每个位置的不透明度
 * 渐变方向：从上到下
 */
+ (UIImage *)imageWithImage:(UIImage *)image locations:(NSArray *)locations opaqueValues:(NSArray *)opaques;

@end

NS_ASSUME_NONNULL_END
