//
//  MCache.h
//  MAudioTrack
//
//  Created by apple on 2021/10/24.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MCache [缓存]
(1) 缓存URL对应的资源信息
 
History:
 
21/10/24: Created by CreaterOS.
 
*/

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, kCacheClearMode) {
    kCacheClearAuto, /** 自动清理*/
    kCacheClearMax /** 溢出清理*/
};

NS_ASSUME_NONNULL_BEGIN

@interface MCache : NSObject

@property (nonatomic, assign) NSInteger countLimit; /** 缓存上限*/
@property (nonatomic, assign) NSInteger totalCostLimit; /** 清理上限*/

@property (nonatomic) kCacheClearMode clearMode; /** 清理模式*/

/**
 * 单例加载
 *
 * @return MCache
 */
+ (instancetype)shared;

/**
 * 存储缓存模型
 *
 * @param model 模型
 * @param key 关键字
 */
- (void)storeCacheModel:(id)model key:(NSString *__nonnull)key;

/**
 * 更新缓存模型
 *
 * @param model 模型
 * @param key 关键字
 */
- (void)updateCacheModel:(id)model key:(NSString *__nonnull)key;

/**
 * 缓存取模型
 *
 * @return id 模型
*/
- (id)modelOfCacheForKey:(NSString *__nonnull)key;

@end

NS_ASSUME_NONNULL_END
