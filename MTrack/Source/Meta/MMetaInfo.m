//
//  MMetaInfo.m
//  MTrack
//
//  Created by Mac on 2021/11/3.
//

#import "MMetaInfo.h"
#import "CommandHeader.h"

@implementation MMetaInfo

- (NSDictionary *)metaInfoWithFile:(NSString *)path {
    NSAssert(path.length != 0, @"The file path cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    return [self metaInfoWithAsset:asset];
}

- (NSDictionary *)metaInfoWithURL:(NSURL *)url {
    NSAssert(url.absoluteString.length != 0, @"The url cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    return [self metaInfoWithAsset:asset];
}

- (NSDictionary *)metaInfoWithAsset:(AVURLAsset *)asset {
    __block NSMutableDictionary *metaInfo = [NSMutableDictionary dictionary];
    
    NSArray<AVMetadataFormat> *formats = [asset availableMetadataFormats];
    for (AVMetadataFormat format in formats) {
        NSArray<AVMetadataItem *> *metadataItem = [asset metadataForFormat:format];
        
        [metadataItem enumerateObjectsUsingBlock:^(AVMetadataItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) { /** 获得元信息*/
            NSString *commonKey = obj.commonKey;
            id value = obj.value;
            
            if (commonKey != nil && value != nil) {
                [metaInfo setValue:value forKey:commonKey];
            }
        }];
    }
    
    NSString *key = kMetaInfoKeyWithDuration;
    if (![metaInfo.allKeys containsObject:key]) { /** 添加时长*/
        [metaInfo setValue:[NSValue valueWithCMTime:asset.duration] forKey:key];
    }
    
    return metaInfo;
}

@end
