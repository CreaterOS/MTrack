//
//  MConvertManager.h
//  MTrack
//
//  Created by Mac on 2021/11/5.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MConvertManager [图片转换视频]
 
History:
 
21/11/05: Created by CreaterOS.
 
*/

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, kFrameRatePreset) { /** 帧率*/
    kFrameRatePreset30,
    kFrameRatePreset60
};

NS_ASSUME_NONNULL_BEGIN

@interface MConvertManager : NSObject

@property (nonatomic) kFrameRatePreset frameRate; /** 帧率*/
@property (nonatomic, assign) NSUInteger time; /** 时间*/

/**
 * 单例加载
 *
 * @return MConvertManager
 */
+ (instancetype)shared;

/**
 * 视频转换
 *
 * @param image 图片
 */
- (void)convertPhotoToVideo:(UIImage *)image completeHandler:(void(^ _Nullable)(NSString *))completeHandler;

/**
 * 视频转换 [保存]
 *
 * @param image 图片
 * @param outputPath 输出路径
 */
- (void)convertPhotoToVideo:(UIImage *)image outputPath:(NSString *)outputPath completeHandler:(void(^ _Nullable)(NSString *))completeHandler;

@end

NS_ASSUME_NONNULL_END
