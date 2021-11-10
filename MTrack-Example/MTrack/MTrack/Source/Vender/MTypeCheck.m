//
//  MTypeCheck.m
//  MAudioTrack
//
//  Created by Mac on 2021/10/21.
//

#import "MTypeCheck.h"
#import "CommandHeader.h"

@implementation MTypeCheck

#pragma mark - 类型判断
+ (BOOL)isType:(NSString *__nonnull)type typeName:(NSString *__nonnull)typeName {
    BOOL flag = false;
    
    if ([type isEqualToString:kTypeAudio]) { /** 音频*/
        if ([typeName isEqualToString:kTypeMP3] || [typeName isEqualToString:kTypePCM] ||
            [typeName isEqualToString:kTypeWAV] || [typeName isEqualToString:kTypeAMR] ||
            [typeName isEqualToString:kTypeAAC] || [typeName isEqualToString:kTypeCAF]) {
            flag = true;
        }
    } else if ([type isEqualToString:kTypeVideo]) { /** 视频*/
        if ([typeName isEqualToString:kTypeMP4] || [typeName isEqualToString:kTypeMOV] || [typeName isEqualToString:kTypeM4A]) {
            flag = true;
        }
    }
   
    return flag;
}

#pragma mark - 网络地址判断
+ (BOOL)isHttps:(NSString *__nonnull)urlStr {
    if ([urlStr containsString:HTTP]) {
        return [urlStr containsString:HTTPS];
    }
    
    return false;
}

@end
