//
//  MVideoTrackAudioManager.h
//  MTrack
//
//  Created by Mac on 2021/11/1.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MVideoTrackAudioManager [视频音频合并]
(1) 多视频多音频串轨
 
History:
 
21/10/21: Created by CreaterOS.
 
*/

#import "MTrackManager.h"

typedef NS_ENUM(NSUInteger, kDurationBaselineMode) {
    kDurationBaselineModeWithVideo, /** 视频基准*/
    kDurationBaselineModeWithAudio /** 音频基准*/
};

NS_ASSUME_NONNULL_BEGIN

@interface MVideoTrackAudioManager : MTrackManager

@property (nonatomic, assign) kDurationBaselineMode mode; /** 时间基准模式*/
@property (nonatomic, assign) BOOL isClipDuration; /** 裁剪时间*/

/**
 * 单例加载
 *
 * @return MAudioTrackAudioManager
 */
+ (instancetype)shared;

#pragma mark - Bundle Name
/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称）
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithBundleNames:(NSArray<NSString *> *__nonnull)audioResList;

/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称)
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithBundleNames:(NSArray<NSString *> *__nonnull)audioResList completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称）
 * @param spaceTimes 间隙数组
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithBundleNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes;

/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称)
 * @param spaceTimes 间隙数组
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithBundleNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

#pragma mark - Path
/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称）
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithPathNames:(NSArray<NSString *> *__nonnull)audioResList;

/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称)
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithPathNames:(NSArray<NSString *> *__nonnull)audioResList completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称）
 * @param spaceTimes 间隙数组
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithPathNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes;

/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称)
 * @param spaceTimes 间隙数组
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithPathNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

#pragma mark - URL
/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称）
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithURLNames:(NSArray<NSString *> *__nonnull)audioResList;

/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称)
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithURLNames:(NSArray<NSString *> *__nonnull)audioResList completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称）
 * @param spaceTimes 间隙数组
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithURLNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes;

/**
 * 视频音频合并
 * @param videoResList 视频资源列表（名称）
 * @param audioResList 音频资源列表（名称)
 * @param spaceTimes 间隙数组
 * @param completeHandler 完成回调
 *
 * @return BOOL 状态
 */
- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *__nonnull)videoResList audioWithURLNames:(NSArray<NSString *> *__nonnull)audioResList spaceTimes:(NSArray<NSValue *> *__nonnull)spaceTimes completeHandler:(void(^ __nullable)(BOOL flag))completeHandler;

@end

NS_ASSUME_NONNULL_END
