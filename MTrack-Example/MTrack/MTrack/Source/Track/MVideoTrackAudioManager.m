//
//  MVideoTrackAudioManager.m
//  MTrack
//
//  Created by Mac on 2021/11/1.
//

#import "MVideoTrackAudioManager.h"

@interface MVideoTrackAudioManager()
@property (nonatomic, strong) AVMutableComposition *composition;
@end

@implementation MVideoTrackAudioManager

#pragma mark - 单例模式
static MVideoTrackAudioManager *_instance = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MVideoTrackAudioManager alloc] init];
    });
    
    return _instance;
}

#pragma mark - Bundle Name
- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *)videoResList audioWithBundleNames:(NSArray<NSString *> *)audioResList {
    return [self trackVideoWithBundleForNames:videoResList audioWithBundleNames:audioResList completeHandler:nil];
}

- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *)videoResList audioWithBundleNames:(NSArray<NSString *> *)audioResList completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithVideoNames:videoResList audioNames:audioResList spaceTimes:nil nameMethod:kTrackNameMethodWithBundle completeHandler:completeHandler];
}

- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *)videoResList audioWithBundleNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [self trackVideoWithBundleForNames:videoResList audioWithBundleNames:audioResList spaceTimes:spaceTimes completeHandler:nil];
}

- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *)videoResList audioWithBundleNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithVideoNames:videoResList audioNames:audioResList spaceTimes:spaceTimes nameMethod:kTrackNameMethodWithBundle completeHandler:completeHandler];
}

#pragma mark - Path
- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *)videoResList audioWithPathNames:(NSArray<NSString *> *)audioResList {
    return [self trackVideoWithPathForNames:videoResList audioWithPathNames:audioResList completeHandler:nil];
}

- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *)videoResList audioWithPathNames:(NSArray<NSString *> *)audioResList completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithVideoNames:videoResList audioNames:audioResList spaceTimes:nil nameMethod:kTrackNameMethodWithPath completeHandler:completeHandler];
}

- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *)videoResList audioWithPathNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [self trackVideoWithPathForNames:videoResList audioWithPathNames:audioResList spaceTimes:spaceTimes completeHandler:nil];
}

- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *)videoResList audioWithPathNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithVideoNames:videoResList audioNames:audioResList spaceTimes:spaceTimes nameMethod:kTrackNameMethodWithPath completeHandler:completeHandler];
}

#pragma mark - URL
- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *)videoResList audioWithURLNames:(NSArray<NSString *> *)audioResList {
    return [self trackVideoWithURLForNames:videoResList audioWithURLNames:audioResList completeHandler:nil];
}

- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *)videoResList audioWithURLNames:(NSArray<NSString *> *)audioResList completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithVideoNames:videoResList audioNames:audioResList spaceTimes:nil nameMethod:kTrackNameMethodWithURL completeHandler:completeHandler];
}

- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *)videoResList audioWithURLNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [self trackVideoWithURLForNames:videoResList audioWithURLNames:audioResList spaceTimes:spaceTimes completeHandler:nil];
}

- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *)videoResList audioWithURLNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithVideoNames:videoResList audioNames:audioResList spaceTimes:spaceTimes nameMethod:kTrackNameMethodWithURL completeHandler:completeHandler];
}

#pragma mark - 合并操作
- (BOOL)trackWithVideoNames:(NSArray<NSString *> *)videoResList audioNames:(NSArray<NSString *> *)audioNames spaceTimes:(NSArray<NSValue *> *)spaceTimes nameMethod:(kTrackNameMethod)nameMethod completeHandler:(void (^)(BOOL))completeHandler {
    __block BOOL flag = false;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    WEAK(self);
    runAsynchronouslyOnTrackQueue(^{
        STRONG(weakself);
        
        /** 获得绑定资源路径*/
        NSArray<NSURL *> *videoURLs = [self paths:videoResList nameMethod:nameMethod];
        NSArray<NSURL *> *audioURLs = [self paths:audioNames nameMethod:nameMethod];
        
        /** 根据资源数目对应的Asset*/
        NSArray<AVURLAsset *> *videoAssets = [self urlAssets:videoURLs nameMethod:nameMethod];
        NSArray<AVURLAsset *> *audioAssets = [self urlAssets:audioURLs nameMethod:nameMethod];
        
        /** 合并*/
        AVMutableComposition *composition = [AVMutableComposition composition];
        self.composition = composition;
        
        /** 视频合并*/
        BOOL isCompositionFlag = [self compositionTracks:composition videoAssets:videoAssets audioAssets:audioAssets spaceTimes:spaceTimes];
        if (!isCompositionFlag) {
            NSLog(@"视频合并失败");
            return ;
        }
        
        NSLog(@"合并完成");
        
        flag = YES;
        
        if (completeHandler != nil) {
            completeHandler(flag);
        }
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
   
    return flag;
}

- (BOOL)compositionTracks:(AVMutableComposition *)composition videoAssets:(NSArray<AVURLAsset *> *)videoAssets audioAssets:(NSArray<AVURLAsset *> *)audioAssets spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    __block BOOL flag = false;
    
    WEAK(self);
    runSynchronouslyOnTrackQueue(^{
        STRONG(weakself);
        
        /** 视频和音频总数*/
        NSInteger videoAssetsTotal = videoAssets.count;
        NSInteger audioAssetsTotal = audioAssets.count;
        
        __block NSMutableArray<NSValue *> *newSpaceTimes;
        if (spaceTimes.count != 0) {
            newSpaceTimes = [NSMutableArray arrayWithArray:spaceTimes];
            NSInteger spaceTimesTotal = spaceTimes.count;
            NSInteger assetsTotal = videoAssetsTotal;
            /** 取差值*/
            NSInteger differentialNum = labs(assetsTotal - spaceTimesTotal);
            if (differentialNum > 0) { /** 需要补充spaceTimes*/
                for (NSInteger i = 0; i < differentialNum; i++) {
                    [newSpaceTimes addObject:spaceTimes.lastObject];
                }
            }
        }
        
        __block AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid]; /** 视频轨道*/
        __block AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid]; /** 音频轨道*/
        
        __block AVURLAsset *preAsset; /** 上一个Asset*/
        __block CMTime kCMTimeCurrent = kCMTimeZero; /** 当前总时间戳*/
        __block CMTimeRange timeRange;
        
        [videoAssets enumerateObjectsUsingBlock:^(AVURLAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) { /** 遍历视频资源*/
            AVURLAsset *videoAsset = obj;
            AVURLAsset *audioAsset = nil;
            if (idx < audioAssetsTotal) {
                audioAsset = audioAssets[idx];
            }
            
            if (audioAsset != nil) { /** 视频合并音频*/
                AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject]; /** 视频轨*/
                AVAssetTrack *videoAudioAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject]; /** 视频音轨*/
                AVAssetTrack *audioAssetTrack = [[audioAsset tracksWithMediaType:AVMediaTypeAudio] firstObject]; /** 音频轨*/
                
                NSError *error = nil;
                
                BOOL videoGTAudioDurFlag = (CMTimeCompare(videoAsset.duration, audioAsset.duration) > 0); /** 视频音轨时长大于自定义音轨时长*/
                
                if (preAsset != nil) {
                    CMTime atTime = CMTimeAdd(kCMTimeCurrent, preAsset.duration);
                    if (newSpaceTimes.count != 0) {
                        NSValue *spaceTime = newSpaceTimes[idx];
                        atTime = CMTimeAdd(atTime, spaceTime.CMTimeValue);
                    }
                    
                    BOOL isTrackVideo = [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoAssetTrack atTime:atTime error:&error];
                    
                    CMTime duration = kCMTimeZero;
                    if (self.mode == kDurationBaselineModeWithVideo) {
                        duration = videoAsset.duration;
                    } else {
                        if (self.isClipDuration) { /** 根据视频长度裁剪音频长度*/
                            duration = videoAsset.duration;
                        } else {
                            duration = audioAsset.duration;
                        }
                    }
                    
                    timeRange = CMTimeRangeMake(kCMTimeZero, duration);
                    BOOL isTrackAudio = [audioCompositionTrack insertTimeRange:timeRange ofTrack:audioAssetTrack atTime:atTime error:&error];
                    BOOL isTrackVideoAudio = YES;
                    if (videoGTAudioDurFlag) {
                        isTrackVideoAudio = [audioCompositionTrack insertTimeRange:CMTimeRangeMake(audioAsset.duration, CMTimeSubtract(videoAsset.duration, audioAsset.duration)) ofTrack:videoAudioAssetTrack atTime:CMTimeAdd(atTime, audioAsset.duration) error:&error];
                    }
                   
                    flag = isTrackVideo && isTrackVideoAudio && isTrackAudio;
                    
                    kCMTimeCurrent = atTime;
                } else {
                    BOOL isTrackVideo = [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:&error];
                    
                    CMTime duration = kCMTimeZero;
                    if (self.mode == kDurationBaselineModeWithVideo) {
                        duration = videoAsset.duration;
                    } else {
                        if (self.isClipDuration) { /** 根据视频长度裁剪音频长度*/
                            duration = videoAsset.duration;
                        } else {
                            duration = audioAsset.duration;
                        }
                    }
                    
                    timeRange = CMTimeRangeMake(kCMTimeZero, duration);
                    BOOL isTrackAudio = [audioCompositionTrack insertTimeRange:timeRange ofTrack:audioAssetTrack atTime:kCMTimeZero error:&error];
                    BOOL isTrackVideoAudio = YES;
                    if (videoGTAudioDurFlag) {
                        isTrackVideoAudio = [audioCompositionTrack insertTimeRange:CMTimeRangeMake(audioAsset.duration, CMTimeSubtract(videoAsset.duration, audioAsset.duration)) ofTrack:videoAudioAssetTrack atTime:CMTimeAdd(kCMTimeZero, audioAsset.duration) error:&error];
                    }
                    
                    flag = isTrackVideo && isTrackVideoAudio && isTrackAudio;
                }
                
                if (self.mode == kDurationBaselineModeWithVideo) {
                    preAsset = videoAsset;
                } else {
                    if (self.isClipDuration) { /** 根据视频长度裁剪音频长度*/
                        preAsset = videoAsset;
                    } else {
                        preAsset = audioAsset;
                    }
                }
            } else { /** 视频原声*/
                AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
                AVAssetTrack *audioAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] firstObject];
                
                NSError *error = nil;
                
                if (preAsset != nil) {
                    CMTime atTime = CMTimeAdd(kCMTimeCurrent, preAsset.duration);
                    if (newSpaceTimes.count != 0) {
                        NSValue *spaceTime = newSpaceTimes[idx];
                        atTime = CMTimeAdd(atTime, spaceTime.CMTimeValue);
                    }
                    flag = [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoAssetTrack atTime:atTime error:&error] && [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:audioAssetTrack atTime:atTime error:&error];
                    kCMTimeCurrent = atTime;
                } else {
                    flag = [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:videoAssetTrack atTime:kCMTimeZero error:&error] && [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:audioAssetTrack atTime:kCMTimeZero error:&error];
                }
                
                preAsset = videoAsset;
            }
        }];
        
        self.videoAsset = (AVURLAsset *)compositionTrack.asset;
        self.audioAsset = (AVURLAsset *)audioCompositionTrack.asset;
    });
   
    return flag;
}

#pragma mark - 导出
- (BOOL)exportWithPath:(NSString *__nonnull)outputPath {
    return [self exportWithPath:outputPath completeHandler:nil];
}

- (BOOL)exportWithPath:(NSString *__nonnull)outputPath completeHandler:(void (^)(void))completeHandler {
    return [self exportWithPath:outputPath composition:_composition presetName:AVAssetExportPresetHighestQuality outputFileType:AVFileTypeMPEG4 completeHandler:completeHandler];
}


#pragma mark - Setter
- (void)setMode:(kDurationBaselineMode)mode {
    _mode = mode;
}

- (void)setIsClipDuration:(BOOL)isClipDuration {
    _isClipDuration = isClipDuration;
}

@end
