//
//  MPhotoTrackPhotoManager.m
//  MTrack
//
//  Created by Mac on 2021/11/5.
//

#import "MPhotoTrackPhotoManager.h"
#import "MVideoTrackVideoManager.h"
#import "MConvertManager.h"

@interface MPhotoTrackPhotoManager()
@property (nonatomic, strong) AVMutableComposition *composition;
@property (nonatomic, assign) NSUInteger waitTime;
@end

@implementation MPhotoTrackPhotoManager

#pragma mark - 单例模式
static MPhotoTrackPhotoManager *_instance = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MPhotoTrackPhotoManager alloc] init];
    });
    
    return _instance;
}

#pragma mark - 导出操作
- (BOOL)trackPhotos:(NSArray<UIImage *> *)photos duration:(NSUInteger)duration {
    __block BOOL flag = false;
    
    __block NSMutableArray<AVURLAsset *> *assets = [NSMutableArray array];

    @synchronized (self) {
        /** 图片转视频*/
        MConvertManager *convertManager = [MConvertManager shared];
        [convertManager setTime:duration];
        
        for (UIImage *photo in photos) {
            [convertManager convertPhotoToVideo:photo completeHandler:^(NSString * _Nonnull path) {
                NSLog(@"转换完成了！！！");
                if (![self typeCheck:@[path] type:kTypeMP4]) { /** 类型转换*/
                    if ([path containsString:DOT]) { /** 是否包含点*/
                        NSString *newPath = [[path componentsSeparatedByString:DOT].firstObject stringByAppendingString:[NSString stringWithFormat:@"%@%@",DOT,kTypeMP4]];
                        /** 替换视频格式*/
                        NSError *error = nil;
                        [[NSFileManager defaultManager] moveItemAtPath:path toPath:newPath error:&error];
                        if (error != nil) {
                            NSLog(@"%@",error.localizedDescription);
                        }
                        path = newPath;
                    }
                }
                
                AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
                NSParameterAssert(asset);
                [assets addObject:asset];
            }];
        }
    }
    
    _waitTime = photos.count;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_waitTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self trackWithAssets:assets spaceTimes:nil completeHandler:nil];
    });
    
    return flag;
}

- (BOOL)trackWithAssets:(NSArray<AVURLAsset *> *)assets spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^)(BOOL))completeHandler {
    BOOL flag = false;
    
    /** 视频合并*/
    AVMutableComposition *composition = [AVMutableComposition composition];
    self.composition = composition;
    
    BOOL isCompositionFlag = [self compositionTracks:composition assets:assets spaceTimes:nil];
    if (!isCompositionFlag) {
        NSLog(@"视频合并失败");
        return false;
    }

    NSLog(@"合并完成");
    
    flag = YES;
    
    return flag;
}

- (BOOL)compositionTracks:(AVMutableComposition *)composition assets:(NSArray<AVURLAsset *> *)assets spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [super compositionTracks:composition assets:assets spaceTimes:spaceTimes completeHandler:^BOOL(NSMutableArray<NSValue *> * _Nonnull newSpaceTimes) {
        __block BOOL flag = false;
       
        runSynchronouslyOnTrackQueue(^{
            AVURLAsset *preAsset; /** 上一个Asset*/
            CMTime kCMTimeCurrent = kCMTimeZero; /** 当前总时间戳*/
            NSInteger index = 0;
            
            AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            for (AVURLAsset *asset in assets) { /** AVURLAsset*/
                AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
                
                /** 视频合并*/
                NSError *error = nil;

                if (preAsset != nil) {
                    CMTime atTime = CMTimeAdd(kCMTimeCurrent, preAsset.duration);
                    if (newSpaceTimes.count != 0) {
                        NSValue *spaceTime = newSpaceTimes[index];
                        atTime = CMTimeAdd(atTime, spaceTime.CMTimeValue);
                    }
                    flag = [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetTrack atTime:atTime error:&error];
                    kCMTimeCurrent = atTime;
                } else {
                    flag = [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetTrack atTime:kCMTimeZero error:&error];
                }

                if (error != nil) {
                    NSLog(@"插入错误: %@",error.localizedDescription);
                }

                preAsset = asset;

                index++;
            }
        });
        
        return flag;
    }];
}

#pragma mark - 导出
- (BOOL)exportWithPath:(NSString *__nonnull)outputPath {
    return [self exportWithPath:outputPath completeHandler:nil];
}

- (BOOL)exportWithPath:(NSString *__nonnull)outputPath completeHandler:(void (^)(void))completeHandler {
    __block BOOL flag = false;
    WEAK(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_waitTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STRONG(weakself);
        flag = [self exportWithPath:outputPath composition:self.composition presetName:AVAssetExportPresetHighestQuality outputFileType:AVFileTypeMPEG4 completeHandler:completeHandler];
    });
    
    return flag;
}

@end
