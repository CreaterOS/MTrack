//
//  MTypeCheck.h
//  MAudioTrack
//
//  Created by Mac on 2021/10/21.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MTypeCheck [类型校验]
(1) 后缀类型校验
 
History:
 
21/10/21: Created by CreaterOS.
 
*/

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MTypeCheck : NSObject

/**
 * 判断后缀类型
 *
 * @return BOOL
 */
+ (BOOL)isType:(NSString *__nonnull)type typeName:(NSString *__nonnull)typeName;

/**
 * 判断网络地址前缀（http/https）
 *
 * @return BOOL
 */
+ (BOOL)isHttps:(NSString *__nonnull)urlStr;


@end

NS_ASSUME_NONNULL_END
