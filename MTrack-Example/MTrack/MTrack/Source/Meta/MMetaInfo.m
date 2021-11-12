//
//  MMetaInfo.m
//  MTrack
//
//  Created by Mac on 2021/11/3.
//

#import "MMetaInfo.h"
#import "CommandHeader.h"
#import "MGenre.h"
#import "MTypeCheck.h"
#import <UIKit/UIKit.h>

#define METADATAFORMATS @"availableMetadataFormats"
#define UNKNOWN @"<<unknown>>"
#define DATA @"data"
#define IDENTIFIER @"identifier"
#define TEXT @"text"

@implementation MMetaInfo

- (NSDictionary *)metaInfoWithFile:(NSString *)path {
    NSAssert(path.length != 0, @"The file path cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    return [self metaInfoWithAsset:asset];
}

- (NSDictionary *)metaInfoWithURL:(NSURL *)url {
    NSAssert(url.absoluteString.length != 0, @"The url cannot be empty");
    BOOL isHttps = [MTypeCheck isHttps:url.absoluteString];
    NSString *newURL = url.absoluteString;
    if (!isHttps) { /** 替换为https*/
        newURL = [newURL stringByReplacingOccurrencesOfString:HTTP withString:HTTPS];
    }
    url = [NSURL URLWithString:newURL];
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    return [self metaInfoWithAsset:asset];
}

- (NSDictionary *)metaInfoWithAsset:(AVURLAsset *)asset {
    __block NSMutableDictionary *metaInfo = [NSMutableDictionary dictionary];
    
    __block NSMutableArray *genreArr = [NSMutableArray array];
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [asset loadValuesAsynchronouslyForKeys:@[METADATAFORMATS] completionHandler:^{
        NSArray<AVMetadataFormat> *formats = [asset availableMetadataFormats];
        for (AVMetadataFormat format in formats) {
            NSArray<AVMetadataItem *> *metadataItem = [asset metadataForFormat:format];
            
            [metadataItem enumerateObjectsUsingBlock:^(AVMetadataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) { /** 获得元信息*/
                NSString *key = [self correctionkeyStringFromMetadataItem:obj];
                
                id value = [self displayValueFromMetadataItem:obj];
                
                if (key != nil && value != nil) {
                    [metaInfo setValue:value forKey:key];
                }
                
                MGenre *genre = [self displayGenreFromMetadataItem:obj];
                if (genre != nil) {
                    [genreArr addObject:genre.name];
                }
            }];
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    /** 记录风格*/
    NSString *key = kMetaInfoKeyWithGenre;
    if (genreArr.count != 0) {
        [metaInfo setValue:genreArr forKey:key];
    }
    
    /** 添加附加信息*/
    [self addAdditional:metaInfo asset:asset];

    /** 剔除COMM*/
    NSString *COMM = @"COMM";
    if ([[metaInfo allKeys] containsObject:COMM]) {
        [metaInfo removeObjectForKey:COMM];
    }
    
    return metaInfo;
}

#pragma mark - 转换
- (NSString *__nonnull)correctionkeyStringFromMetadataItem:(AVMetadataItem *)item {
    id key = item.key;
    id commandKey = item.commonKey;
    
    if ([key isKindOfClass:[NSString class]]) { /** 字符类型*/
        if ([commandKey isKindOfClass:[NSString class]]) {
            return (NSString *)commandKey;
        }
        
        return (NSString *)key;
    } else if ([key isKindOfClass:[NSNumber class]]) { /** 数值类型*/
        /** 无整型转换*/
        UInt32 keyValue = [(NSNumber *)key unsignedIntValue];
        
        /** 长度裁剪*/
        size_t length = sizeof(UInt32);
        if ((keyValue >> 24) == 0) --length;
        if ((keyValue >> 16) == 0) --length;
        if ((keyValue >> 8) == 0) --length;
        if ((keyValue >> 0) == 0) --length;
        
        long address = (unsigned long)&keyValue;
        address += (sizeof(UInt32) - length);
        
        keyValue = CFSwapInt32BigToHost(keyValue);
        
        char cstring[length];
        strncpy(cstring, (char *)address, length);
        cstring[length] = '\0';
        
        if (cstring[0] == '\xA9') {
            cstring[0] = '@';
        }
        
        return [NSString stringWithCString:cstring encoding:NSUTF8StringEncoding];
    } else {
        return UNKNOWN;
    }
}

- (id)displayValueFromMetadataItem:(AVMetadataItem *)item {
    id value = item.value;
    
    UIImage *image = nil;
    if ([value isKindOfClass:[NSData class]]) {
        NSData *data = (NSData *)value;
        image = [[UIImage alloc] initWithData:data];
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)value;
        image = [UIImage imageWithData:dict[DATA]];
    } else if ([value isKindOfClass:[NSString class]]) {
        return item.stringValue;
    } else if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)value;
        if ([dict[IDENTIFIER] isEqualToString:@""]) {
            value = dict[TEXT];
        }
        return value;
    }
     
    return image;
}

- (MGenre *)displayGenreFromMetadataItem:(AVMetadataItem *)item {
    MGenre *genre = nil;
    
    if ([item.value isKindOfClass:[NSString class]]) {
        if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
            /** ID3 stores the genre as an index value*/
            if (item.numberValue) {
                NSUInteger genreIndex = [item.numberValue unsignedIntValue];
                genre = [MGenre id3GenreWithIndex:genreIndex];
            }
        }
    } else if ([item.value isKindOfClass:[NSData class]]) {
        NSData *data = item.dataValue;
        if (data.length == 2) {
            uint16_t *values = (uint16_t *)[data bytes];
            uint16_t genreIndex = CFSwapInt16LittleToHost(values[0]);
            genre = [MGenre iTunesGenreWithIndex:genreIndex];
        }
    }
    
    return genre;
}

#pragma mark - 附加信息
- (void)addAdditional:(NSMutableDictionary *__nonnull)metaInfo asset:(AVAsset *)asset {
    /** 时长,速率,音量,大小,创建时间,音频类型*/
    NSDictionary<NSString *, id> *infos = @{
        kMetaInfoKeyWithDuration : [NSValue valueWithCMTime:asset.duration],
        kMetaInfoKeyWithRate : @(asset.preferredRate),
        kMetaInfoKeyWithVolume : @(asset.preferredVolume)
    };
    
    for (NSString *key in [infos allKeys]) {
        if (![metaInfo.allKeys containsObject:key]) {
            [metaInfo setValue:infos[key] forKey:key];
        }
    }
}

@end
