//
// MAudioTrackAudioManager.m
// MAudioTrack
//
// Created by Mac on 2021/10/21.
//

#import "MAudioTrackAudioManager.h"

@interface MAudioTrackAudioManager()
@property (nonatomic, strong) AVMutableComposition *composition;
@end

@implementation MAudioTrackAudioManager

#pragma mark - 单例模式
static MAudioTrackAudioManager *_instance = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MAudioTrackAudioManager alloc] init];
    });
    
    return _instance;
}

#pragma mark - 合并音轨
#pragma mark - Bundle
- (BOOL)trackAudiosWithBundleForNames:(NSArray<NSString *> *)audioResList {
    return [self trackAudiosWithBundleForNames:audioResList completeHandler:nil];
}

- (BOOL)trackAudiosWithBundleForNames:(NSArray<NSString *> *__nonnull)audioResList completeHandler:(void (^ _Nullable)(BOOL))completeHandler {
    return [self trackWithNames:audioResList spaceTimes:nil nameMethod:kTrackNameMethodWithBundle completeHandler:completeHandler];
}

- (BOOL)trackAudiosWithBundleForNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [self trackAudiosWithBundleForNames:audioResList spaceTimes:spaceTimes completeHandler:nil];
}

- (BOOL)trackAudiosWithBundleForNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithNames:audioResList spaceTimes:spaceTimes nameMethod:kTrackNameMethodWithBundle completeHandler:completeHandler];
}

#pragma mark - Path
- (BOOL)trackAudiosWithPathForNames:(NSArray<NSString *> *)audioResList {
    return [self trackAudiosWithPathForNames:audioResList completeHandler:nil];
}

- (BOOL)trackAudiosWithPathForNames:(NSArray<NSString *> *__nonnull)audioResList completeHandler:(void (^ _Nullable)(BOOL))completeHandler {
    return [self trackWithNames:audioResList spaceTimes:nil nameMethod:kTrackNameMethodWithPath completeHandler:completeHandler];
}

- (BOOL)trackAudiosWithPathForNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [self trackAudiosWithPathForNames:audioResList spaceTimes:spaceTimes completeHandler:nil];
}

- (BOOL)trackAudiosWithPathForNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithNames:audioResList spaceTimes:spaceTimes nameMethod:kTrackNameMethodWithPath completeHandler:completeHandler];
}

#pragma mark - URL
- (BOOL)trackAudiosWithURLForNames:(NSArray<NSString *> *)audioResList {
    return [self trackAudiosWithURLForNames:audioResList completeHandler:nil];
}

- (BOOL)trackAudiosWithURLForNames:(NSArray<NSString *> *)audioResList completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithNames:audioResList spaceTimes:nil nameMethod:kTrackNameMethodWithURL completeHandler:completeHandler];
}

- (BOOL)trackAudiosWithURLForNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes {
    return [self trackAudiosWithURLForNames:audioResList spaceTimes:spaceTimes completeHandler:nil];
}

- (BOOL)trackAudiosWithURLForNames:(NSArray<NSString *> *)audioResList spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^)(BOOL))completeHandler {
    return [self trackWithNames:audioResList spaceTimes:spaceTimes nameMethod:kTrackNameMethodWithURL completeHandler:completeHandler];
}

#pragma mark - 合并操作
- (BOOL)trackWithNames:(NSArray<NSString *> *)resList spaceTimes:(NSArray<NSValue *> *)spaceTimes nameMethod:(kTrackNameMethod)nameMethod completeHandler:(void (^)(BOOL))completeHandler {
    NSAssert(resList.count != 0, @"The incoming audio resource cannot be empty");
    
    __block BOOL flag = false;
    
    /** 类型校验*/
    BOOL isType = [self typeCheck:resList type:kTypeAudio];
    
    if (!isType) { /** 类型不匹配*/
        NSLog(@"传入类型不是音频类型");
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
        
        /** 音轨*/
        AVMutableComposition *composition = [AVMutableComposition composition];
        self.composition = composition;
        
        /** 音频合并*/
        BOOL isCompositionFlag = [self compositionTracks:composition assets:assets spaceTimes:spaceTimes];
        if (!isCompositionFlag) {
            NSLog(@"音频合并失败");
            return ;
        }
        
        NSLog(@"合并完成");
        
        /** 导出操作 -- 音频文件目前只找到支持m4a 类型的*/
        flag = YES;
        
        if (completeHandler != nil) {
            completeHandler(flag);
        }
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return flag;
}

- (BOOL)compositionTracks:(AVMutableComposition* __nonnull)composition assets:(NSArray<AVURLAsset *> *__nonnull)assets spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes { /** 合并音轨*/
    return [super compositionTracks:composition assets:assets spaceTimes:spaceTimes completeHandler:^BOOL(NSMutableArray<NSValue *> * _Nonnull newSpaceTimes) {
        __block BOOL flag = false;
        
        WEAK(self);
        runSynchronouslyOnTrackQueue(^{
            STRONG(weakself);
            
            AVURLAsset *preAsset; /** 上一个Asset*/
            CMTime kCMTimeCurrent = kCMTimeZero; /** 当前总时间戳*/
            NSInteger index = 0;
            AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            
            for (AVURLAsset *asset in assets) { /** AVURLAsset*/
                AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
                
                /** 音频合并，插入音轨*/
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
                    NSLog(@"%@",error.localizedDescription);
                }
                
                preAsset = asset;
                
                index++;
            }
            
            self.audioAsset = (AVURLAsset *)compositionTrack.asset;
        });
        
        return flag;
    }];
}

#pragma mark - 导出
- (BOOL)exportWithPath:(NSString *__nonnull)outputPath {
    return [self exportWithPath:outputPath completeHandler:nil];
}

- (BOOL)exportWithPath:(NSString *__nonnull)outputPath completeHandler:(void (^)(void))completeHandler {
    /** 校验输出类型与AVAssetExportPresetAppleM4A匹配*/
    BOOL isM4A = [self typeCheck:@[outputPath] type:kTypeM4A];
    if (!isM4A) { /** 修正后缀*/
        NSString *lastPathComponent = [outputPath lastPathComponent];
        if ([lastPathComponent containsString:DOT]) {
            NSString *newLastPathComponent = [[[lastPathComponent componentsSeparatedByString:DOT] firstObject] stringByAppendingString:[NSString stringWithFormat:@"%@%@",DOT,kTypeM4A]];
            outputPath = [outputPath stringByReplacingOccurrencesOfString:lastPathComponent withString:newLastPathComponent];
        }
    }
    
    return [self exportWithPath:outputPath composition:_composition presetName:AVAssetExportPresetAppleM4A outputFileType:AVFileTypeAppleM4A completeHandler:completeHandler];
}

@end
