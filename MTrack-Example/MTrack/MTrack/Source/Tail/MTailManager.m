//
//  MTailManager.m
//  MTrack
//
//  Created by Mac on 2021/11/3.
//

#import "MTailManager.h"
#import "MExport.h"

@interface MTailManager()
@property (nonatomic, strong) AVMutableComposition *composition;
@property (nonatomic) kMediaType type;
@end

@implementation MTailManager

#pragma mark - 单例模式
static MTailManager *_instance = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MTailManager alloc] init];
    });
    
    return _instance;
}

#pragma mark - 裁剪
- (AVURLAsset *)tailWithFile:(NSString *)path start:(CMTime)start end:(CMTime)end type:(kMediaType)type {
    NSAssert(path.length != 0, @"The file path cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    return [self tailWithAsset:asset start:start end:end type:type];
}

- (AVURLAsset *)tailWithURL:(NSURL *)url start:(CMTime)start end:(CMTime)end type:(kMediaType)type {
    NSAssert(url.absoluteString.length != 0, @"The url cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    return [self tailWithAsset:asset start:start end:end type:type];
}

- (AVURLAsset *)tailWithAsset:(AVURLAsset *)asset start:(CMTime)start end:(CMTime)end type:(kMediaType)type {
    self.type = type;
    
    AVURLAsset *resAsset = nil;
    
    if (CMTimeCompare(start, end) > 0) {
        NSLog(@"结束时间不能小于开始时间");
        return resAsset;
    }
    
    CMTime duration = CMTimeSubtract(end, start);
    CMTime time = CMTimeAdd(start, duration); /** 总长度*/
    if (CMTimeCompare(time, asset.duration) > 0) {
        NSLog(@"时长超过音频长度");
        return resAsset;
    }
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    self.composition = composition;
    
    if (type == kMediaTypeAudio) { /** 裁剪音频*/
        resAsset = [self tailAudio:composition asset:asset start:start end:end];
    } else if (type == kMediaTypeVideo) { /** 裁剪视频*/
        resAsset = [self tailVideo:composition asset:asset start:start end:end];
    }
    
    return resAsset;
}

- (AVURLAsset *)tailAudio:(AVMutableComposition *)composition asset:(AVURLAsset *__nonnull)asset start:(CMTime)start end:(CMTime)end {
    AVURLAsset *resAsset = nil;
    
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    
    NSError *error = nil;
    BOOL flag = [compositionTrack insertTimeRange:CMTimeRangeMake(start, CMTimeSubtract(end, start)) ofTrack:assetTrack atTime:kCMTimeZero error:&error];
    
    if (flag) {
        /** 输出AVURLAsset*/
        resAsset = (AVURLAsset *)[compositionTrack asset];
    } else {
        if (error != nil) {
            NSLog(@"%@",error.localizedDescription);
        }
    }
    
    return resAsset;
}

- (AVURLAsset *)tailVideo:(AVMutableComposition *)composition asset:(AVURLAsset *__nonnull)asset start:(CMTime)start end:(CMTime)end {
    AVURLAsset *resAsset = nil;
    
    /** 视频轨道*/
    AVMutableCompositionTrack *compositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    /** 音频轨道*/
    AVMutableCompositionTrack *audioCompositionTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *assetTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    
    NSError *error = nil;
    BOOL flag = [compositionTrack insertTimeRange:CMTimeRangeMake(start, CMTimeSubtract(end, start)) ofTrack:assetTrack atTime:kCMTimeZero error:&error] && [audioCompositionTrack insertTimeRange:CMTimeRangeMake(start, CMTimeSubtract(end, start)) ofTrack:assetTrack atTime:kCMTimeZero error:&error];
    
    if (flag) {
        /** 输出AVURLAsset*/
        resAsset = (AVURLAsset *)[compositionTrack asset];
    } else {
        if (error != nil) {
            NSLog(@"%@",error.localizedDescription);
        }
    }
    
    return resAsset;
}


#pragma mark - 导出
- (BOOL)exportWithPath:(NSString *__nonnull)outputPath composition:(AVMutableComposition *__nonnull)composition presetName:(NSString *const)presetName outputFileType:(NSString *const)outputFileType completeHandler:(void(^ _Nullable)(void))completeHandler { /** 导出操作*/
    MExport *export = [[MExport alloc] init];
    return [export exportWithPath:outputPath composition:composition presetName:presetName outputFileType:outputFileType completeHandler:completeHandler];
}

- (BOOL)exportWithPath:(NSString *__nonnull)outputPath {
    return [self exportWithPath:outputPath completeHandler:nil];
}

- (BOOL)exportWithPath:(NSString *__nonnull)outputPath completeHandler:(void (^)(void))completeHandler {
    if (_type == kMediaTypeAudio) {
        return [self exportWithPath:outputPath composition:_composition presetName:AVAssetExportPresetAppleM4A outputFileType:AVFileTypeAppleM4A completeHandler:completeHandler];
    } else if (_type == kMediaTypeVideo) {
        return [self exportWithPath:outputPath composition:_composition presetName:AVAssetExportPresetHighestQuality outputFileType:AVFileTypeMPEG4 completeHandler:completeHandler];
    }
    
    return false;
}

@end
