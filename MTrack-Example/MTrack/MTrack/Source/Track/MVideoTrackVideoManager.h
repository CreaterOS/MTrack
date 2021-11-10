//
//  MVideoTrackVideoManager.h
//  MTrack
//
//  Created by Mac on 2021/10/27.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MVideoTrackVideoManager [视频合并视频]
(1) 多视频串轨
 
History:
 
21/10/21: Created by CreaterOS.
 
*/

#import <Foundation/Foundation.h>
#import "MTrackManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MVideoTrackVideoManager : MTrackManager

/**
 * 单例加载
 *
 * @return MAudioTrackAudioManager
 */
+ (instancetype)shared;

#pragma mark - Bundle Name
/**
 * 视频尾部追加
 * @param videoResList 视频资源列表（名称）
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *__nonnull)videoResList;

/**
 * 视频尾部追加
 * @param videoResList 视频资源列表（名称）
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *__nonnull)videoResList completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

/**
 * 视频尾部追加 -- 时间间隙
 * @param videoResList 视频资源列表（名称）
 * @param spaceTimes 间隙数组
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *__nonnull)videoResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes;

/**
 * 视频尾部追加 -- 时间间隙
 * @param videoResList 视频资源列表（名称）
 * @param spaceTimes 间隙数组
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *__nonnull)videoResList spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

#pragma mark - Path
/**
 * 视频尾部追加
 * @param videoResList 视频资源列表（名称）
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *__nonnull)videoResList;

/**
 * 视频尾部追加
 * @param videoResList 视频资源列表（名称）
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *__nonnull)videoResList completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

/**
 * 视频尾部追加 -- 时间间隙
 * @param videoResList 视频资源列表（名称）
 * @param spaceTimes 间隙数组
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *__nonnull)videoResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes;

/**
 * 视频尾部追加 -- 时间间隙
 * @param videoResList 视频资源列表（名称）
 * @param spaceTimes 间隙数组
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *__nonnull)videoResList spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

#pragma mark - URL
/**
 * 视频尾部追加
 * @param videoResList 视频资源列表（名称）
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *__nonnull)videoResList;

/**
 * 视频尾部追加
 * @param videoResList 视频资源列表（名称）
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *__nonnull)videoResList completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

/**
 * 视频尾部追加 -- 时间间隙
 * @param videoResList 视频资源列表（名称）
 * @param spaceTimes 间隙数组
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *__nonnull)videoResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes;

/**
 * 视频尾部追加 -- 时间间隙
 * @param videoResList 视频资源列表（名称）
 * @param spaceTimes 间隙数组
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *__nonnull)videoResList spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

@end

NS_ASSUME_NONNULL_END
