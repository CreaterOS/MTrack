//
//  MAudioIntensityView.h
//  MTrack
//
//  Created by Mac on 2021/11/4.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MAudioIntensityView [音频波形视图]
 
History:
 
21/11/04: Created by CreaterOS.
 
*/

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAudioIntensityView : UIView

/**
 * 音频强度资源
 *
 * @param path 路径
 */
- (void)intensityWithFile:(NSString *__nonnull)path;

/**
 * 音频强度资源
 *
 * @param url 地址
 */
- (void)intensityWithURL:(NSURL *__nonnull)url;

/**
 * 音频强度资源
 *
 * @param asset 音频资源
 */
- (void)intensityWithAsset:(AVURLAsset *__nonnull)asset;

@end

NS_ASSUME_NONNULL_END
