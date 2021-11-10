//
//  MMetaInfo.h
//  MTrack
//
//  Created by Mac on 2021/11/3.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MMetaInfo [元信息]
 
History:
 
21/11/03: Created by CreaterOS.
 
*/

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MMetaInfo : NSObject

/**
 * 元信息
 * @param path 路径
 *
 * @return NSDictionary 元信息字典
 */
- (NSDictionary *)metaInfoWithFile:(NSString *__nonnull)path;

/**
 * 元信息
 * @param url 地址
 *
 * @return NSDictionary 元信息字典
 */
- (NSDictionary *)metaInfoWithURL:(NSURL *__nonnull)url;

/**
 * 元信息
 * @param asset 资源
 *
 * @return NSDictionary 元信息字典
 */
- (NSDictionary *)metaInfoWithAsset:(AVURLAsset *__nonnull)asset;

@end

NS_ASSUME_NONNULL_END
