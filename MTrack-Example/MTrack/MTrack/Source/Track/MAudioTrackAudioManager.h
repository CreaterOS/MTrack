//
//  MAudioTrackAudioManager.h
//  MAudioTrack
//
//  Created by Mac on 2021/10/21.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MAudioTrackAudioManager [音频合并音频]
(1) 多音轨串轨
(2) 多音轨间隙串轨
 
History:
 
21/10/21: Created by CreaterOS.
 
*/

#import <Foundation/Foundation.h>
#import "MTrackManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAudioTrackAudioManager : MTrackManager

/**
 * 单例加载
 *
 * @return MAudioTrackAudioManager
 */
+ (instancetype)shared;

#pragma mark - Bundle Name

/**
 * 音轨尾部追加
 * @param audioResList 音频资源列表（名称）
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithBundleForNames:(NSArray<NSString *> *__nonnull)audioResList;

/**
 * 音轨尾部追加
 * @param audioResList 音频资源列表（名称）
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithBundleForNames:(NSArray<NSString *> *__nonnull)audioResList completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

/**
 * 音轨尾部追加 -- 时间间隙
 * @param audioResList 音频资源列表（名称）
 * @param spaceTimes 间隙数组
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithBundleForNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes;

/**
 * 音轨尾部追加 -- 时间间隙
 * @param audioResList 音频资源列表（名称）
 * @param spaceTimes 间隙数组
 * @param completeHandler 完成回调
 * 
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithBundleForNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

#pragma mark - Path

/**
 * 音轨尾部追加
 * @param audioResList 音频资源列表（绝对路径）
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithPathForNames:(NSArray<NSString *> *__nonnull)audioResList;

/**
 * 音轨尾部追加
 * @param audioResList 音频资源列表（绝对路径）
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithPathForNames:(NSArray<NSString *> *__nonnull)audioResList completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

/**
 * 音轨尾部追加 -- 时间间隙
 * @param audioResList 音频资源列表（绝对路径）
 * @param spaceTimes 间隙数组
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithPathForNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes;

/**
 * 音轨尾部追加 -- 时间间隙
 * @param audioResList 音频资源列表（绝对路径）
 * @param spaceTimes 间隙数组
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithPathForNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

#pragma mark - URL

/**
 * 音轨尾部追加
 * @param audioResList 音频资源列表（URL）
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithURLForNames:(NSArray<NSString *> *__nonnull)audioResList;

/**
 * 音轨尾部追加
 * @param audioResList 音频资源列表（URL）
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithURLForNames:(NSArray<NSString *> *__nonnull)audioResList completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

/**
 * 音轨尾部追加 -- 时间间隙
 * @param audioResList 音频资源列表（URL）
 * @param spaceTimes 间隙数组
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithURLForNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes;

/**
 * 音轨尾部追加 -- 时间间隙
 * @param audioResList 音频资源列表（URL）
 * @param spaceTimes 间隙数组
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackAudiosWithURLForNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

@end

NS_ASSUME_NONNULL_END
