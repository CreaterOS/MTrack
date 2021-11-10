//
//  MVideoTrackVideoManager.m
//  MTrack
//
//  Created by Mac on 2021/10/27.
//

#import "MVideoTrackVideoManager.h"

@interface MVideoTrackVideoManager()
@property (nonatomic, strong) AVMutableComposition *composition;
@end

@implementation MVideoTrackVideoManager

#pragma mark - 单例模式
static MVideoTrackVideoManager *_instance = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MVideoTrackVideoManager alloc] init];
    });
    
    return _instance;
}

#pragma mark - Bundle Name
- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *)videoResList {
    return [self trackVideoWithBundleForNames:videoResList completeHandler:nil];
}

- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *)videoResList completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithNames:videoResList spaceTimes:nil nameMethod:kTrackNameMethodWithBundle completeHandler:completeHandler];
}

- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *)videoResList spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [self trackVideoWithBundleForNames:videoResList spaceTimes:spaceTimes completeHandler:nil];
}

- (BOOL)trackVideoWithBundleForNames:(NSArray<NSString *> *)videoResList spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^) (BOOL))completeHandler {
    return [self trackWithNames:videoResList spaceTimes:spaceTimes nameMethod:kTrackNameMethodWithBundle completeHandler:completeHandler];
}

#pragma mark - Path
- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *)videoResList {
    return [self trackVideoWithPathForNames:videoResList completeHandler:nil];
}

- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *)videoResList completeHandler:(void (^) (BOOL))completeHandler {
    return [self trackWithNames:videoResList spaceTimes:nil nameMethod:kTrackNameMethodWithPath completeHandler:completeHandler];
}

- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *)videoResList spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [self trackVideoWithPathForNames:videoResList spaceTimes:spaceTimes completeHandler:nil];
}

- (BOOL)trackVideoWithPathForNames:(NSArray<NSString *> *)videoResList spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^) (BOOL))completeHandler {
    return [self trackWithNames:videoResList spaceTimes:spaceTimes nameMethod:kTrackNameMethodWithPath completeHandler:completeHandler];
}

#pragma mark - URL
- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *)videoResList {
    return [self trackVideoWithURLForNames:videoResList completeHandler:nil];
}

- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *)videoResList completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithNames:videoResList spaceTimes:nil nameMethod:kTrackNameMethodWithURL completeHandler:completeHandler];
}

- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *)videoResList spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [self trackVideoWithURLForNames:videoResList spaceTimes:spaceTimes completeHandler:nil];
}

- (BOOL)trackVideoWithURLForNames:(NSArray<NSString *> *)videoResList spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithNames:videoResList spaceTimes:spaceTimes nameMethod:kTrackNameMethodWithURL completeHandler:completeHandler];
}

#pragma mark - 合并操作
- (BOOL)trackWithNames:(NSArray<NSString *> *)resList spaceTimes:(NSArray<NSValue *> *)spaceTimes nameMethod:(kTrackNameMethod)nameMethod completeHandler:(nonnull void (^)(BOOL))completeHandler{
    NSAssert(resList.count != 0, @"The incoming video resource cannot be empty");
    
    __block BOOL flag = false;
    
    /** 类型校验*/
    BOOL isType = [self typeCheck:resList type:kTypeVideo];

    if (!isType) { /** 类型不匹配*/
        NSLog(@"传入类型不是视频类型");
        return flag;
    }

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    WEAK(self);
    runAsynchronouslyOnTrackQueue(^{
        STRONG(weakself);
        
        /** 获得绑定资源路径*/
        NSArray<NSURL *> *urls = [self paths:resList nameMethod:nameMethod];

        /** 根据资源数目对应的Asset*/
        NSArray<AVURLAsset *> *assets = [self urlAssets:urls nameMethod:nameMethod];

        /** 视频合并*/
        AVMutableComposition *composition = [AVMutableComposition composition];
        self.composition = composition;
        
        BOOL isCompositionFlag = [self compositionTracks:composition assets:assets spaceTimes:spaceTimes];
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

- (BOOL)compositionTracks:(AVMutableComposition *)composition assets:(NSArray<AVURLAsset *> *)assets spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [super compositionTracks:composition assets:assets spaceTimes:spaceTimes completeHandler:^BOOL(NSMutableArray<NSValue *> * _Nonnull newSpaceTimes) {
        __block BOOL flag = false;
       
        WEAK(self);
        runSynchronouslyOnTrackQueue(^{
            STRONG(weakself);
            
            AVURLAsset *preAsset; /** 上一个Asset*/
            CMTime kCMTimeCurrent = kCMTimeZero; /** 当前总时间戳*/
            NSInteger index = 0;
            
            AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
            AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            for (AVURLAsset *asset in assets) { /** AVURLAsset*/
                AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
                AVAssetTrack *audioTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
                
                /** 视频合并*/
                NSError *error = nil;

                if (preAsset != nil) {
                    CMTime atTime = CMTimeAdd(kCMTimeCurrent, preAsset.duration);
                    if (newSpaceTimes.count != 0) {
                        NSValue *spaceTime = newSpaceTimes[index];
                        atTime = CMTimeAdd(atTime, spaceTime.CMTimeValue);
                    }
                    flag = [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetTrack atTime:atTime error:&error] && [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioTrack atTime:atTime error:&error];
                    kCMTimeCurrent = atTime;
                } else {
                    flag = [compositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:assetTrack atTime:kCMTimeZero error:&error] && [audioCompositionTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration) ofTrack:audioTrack atTime:kCMTimeZero error:&error];
                }

                if (error != nil) {
                    NSLog(@"插入错误: %@",error.localizedDescription);
                }

                preAsset = asset;

                index++;
            }
            
            self.videoAsset = (AVURLAsset *)compositionTrack.asset;
            self.audioAsset = (AVURLAsset *)audioCompositionTrack.asset;
        });
        
        return flag;
    }];
}

#pragma mark - 导出
- (BOOL)exportWithPath:(NSString *__nonnull)outputPath {
    return [self exportWithPath:outputPath completeHandler:nil];
}

- (BOOL)exportWithPath:(NSString *__nonnull)outputPath completeHandler:(void (^)(void))completeHandler {
    return [self exportWithPath:outputPath composition:_composition presetName:AVAssetExportPresetHighestQuality outputFileType:AVFileTypeMPEG4 completeHandler:completeHandler];
}

@end
