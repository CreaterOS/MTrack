//
//  MURLCache.h
//  MAudioTrack
//
//  Created by apple on 2021/10/23.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MURLCache [缓存]
(1) 缓存URL
 
History:
 
21/10/23: Created by CreaterOS.
 
*/

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MURLCache : NSObject

@property (nonatomic, assign) NSUInteger memoryCapacity; /** 内存缓存上限*/
@property (nonatomic, assign) NSUInteger diskCapacity; /** 磁盘缓存上限制*/

/**
 * 单例加载
 *
 * @return MURLCache
 */
+ (instancetype)sharedURLCache;

/**
 * 缓存URL
 *
 * @param urlStr 地址字符串
 * @param completeHandler 完成回调
 */
- (void)storeURLCache:(NSString *__nonnull)urlStr completeHandler:(void(^)(AVAsset *__nullable asset))completeHandler;

@end

NS_ASSUME_NONNULL_END
