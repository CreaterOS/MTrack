//
//  MPhotoTrackPhotoManager.h
//  MTrack
//
//  Created by Mac on 2021/11/5.
//

#import <Foundation/Foundation.h>
#import "MTrackManager.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPhotoTrackPhotoManager : MTrackManager

/**
 * 单例加载
 *
 * @return MAudioTrackAudioManager
 */
+ (instancetype)shared;

/**
 * 视频音频合并
 *
 * @param photos 图片集合
 * 
 * @return BOOL 状态
 */
- (BOOL)trackPhotos:(NSArray<UIImage *> *)photos duration:(NSUInteger)duration;

@end

NS_ASSUME_NONNULL_END
