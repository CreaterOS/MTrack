//
//  MTailManager.h
//  MTrack
//
//  Created by Mac on 2021/11/3.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MTailManager [裁剪]
 
History:
 
21/11/03: Created by CreaterOS.
 
*/

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSUInteger, kMediaType) {
    kMediaTypeAudio,
    kMediaTypeVideo,
};

NS_ASSUME_NONNULL_BEGIN

@interface MTailManager : NSObject

/**
 * 单例加载
 *
 * @return MTailManager
 */
+ (instancetype)shared;

/**
 * 裁剪
 *
 * @param path 路径
 * @param start 开始时间
 * @param end 结束时间
 *
 * @return 状态
 */
- (AVURLAsset *)tailWithFile:(NSString *__nonnull)path start:(CMTime)start end:(CMTime)end type:(kMediaType)type;

/**
 * 裁剪
 *
 * @param url 地址
 * @param start 开始时间
 * @param end 结束时间
 *
 * @return 状态
 */
- (AVURLAsset *)tailWithURL:(NSURL *__nonnull)url start:(CMTime)start end:(CMTime)end type:(kMediaType)type;


/**
 * 裁剪
 *
 * @param asset 资源
 * @param start 开始时间
 * @param end 结束时间
 *
 * @return 状态
 */
- (AVURLAsset *)tailWithAsset:(AVURLAsset *__nonnull)asset start:(CMTime)start end:(CMTime)end type:(kMediaType)type;

/**
 * 导出操作
 *
 * @param outputPath 保存路径
 *
 * @return 状态
 */
- (BOOL)exportWithPath:(NSString *__nonnull)outputPath;

/**
 * 导出操作
 *
 * @param outputPath 保存路径
 * @param completeHandler 完成回调
 *
 * @return 状态
 */
- (BOOL)exportWithPath:(NSString *__nonnull)outputPath completeHandler:(void (^ _Nullable)(void))completeHandler;

@end

NS_ASSUME_NONNULL_END
