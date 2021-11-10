//
//  MTrackManager.m
//  MTrack
//
//  Created by Mac on 2021/10/27.
//

#import "MTrackManager.h"
#import "MURLCache.h"
#import "MExport.h"

static void *trackQueueKey;

void runSynchronouslyOnTrackQueue(void(^_Nonnull block)(void)) {
    dispatch_queue_t trackQueue = [MTrackManager shared].trackQueue;
#if !OS_OBJECT_USE_OBJC
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (dispatch_get_current_queue() == trackQueue)
#pragma clang diagnostic pop
#else
        if (dispatch_get_specific(trackQueueKey))
#endif
        {
            block();
        }else
        {
            dispatch_sync(trackQueue, block);
        }
}

void runAsynchronouslyOnTrackQueue(void(^_Nonnull block)(void)) {
    dispatch_queue_t trackQueue = [MTrackManager shared].trackQueue;
    
#if !OS_OBJECT_USE_OBJC
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (dispatch_get_current_queue() == trackQueue)
#pragma clang diagnostic pop
#else
        if (dispatch_get_specific(trackQueueKey))
#endif
        {
            block();
        } else {
            dispatch_async(trackQueue, block);
        }
}

@interface MTrackManager()
@property (nonatomic, strong) MURLCache *urlCache;
@end

@implementation MTrackManager

MTrackManager *_instance = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MTrackManager alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        trackQueueKey = &trackQueueKey;
        dispatch_queue_t trackQueue = dispatch_queue_create("com.CreaterOS.MTrack.trackQueue", NULL);
#if OS_OBJECT_USE_OBJC
        dispatch_queue_set_specific(trackQueue, trackQueueKey, (__bridge void *)self, NULL);
#endif
        _trackQueue = trackQueue;
    }
    return self;
}

#pragma mark - LazyInit
- (MURLCache *)urlCache {
    if (!_urlCache) {
        _urlCache = [MURLCache sharedURLCache];
        
        /** 配置*/
        [_urlCache setMemoryCapacity:100];
        [_urlCache setDiskCapacity:50];
    }
    
    return _urlCache;
}

- (BOOL)typeCheck:(NSArray<NSString *> *__nonnull)resList type:(NSString *__nonnull)type { /** 类型校验*/
    BOOL flag = false;
    
    for (NSString *res in resList) {
        if ([res containsString:DOT]) { /** 是否包含点*/
            NSString *typeName = [res componentsSeparatedByString:DOT].lastObject;
            /** 判断类型*/
            flag = [MTypeCheck isType:type typeName:[typeName lowercaseString]];
        }
    }
    
    return flag;
}

- (NSArray<NSURL *> *__nonnull)paths:(NSArray<NSString *> *__nonnull)resList nameMethod:(kTrackNameMethod)nameMethod { /** 目标路径*/
    NSMutableArray<NSURL *> *urls = [NSMutableArray array];
    
    for (NSString *res in resList) {
        NSURL *url;
        if (nameMethod == kTrackNameMethodWithBundle) { /** Bundle Name*/
            NSString *name;
            if ([res containsString:DOT]) { /** 是否包含点*/
                name = [res componentsSeparatedByString:DOT].firstObject;
            }
            NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:[res componentsSeparatedByString:DOT].lastObject];
            url = [NSURL fileURLWithPath:path];
        } else if (nameMethod == kTrackNameMethodWithPath) { /** Path*/
            url = [NSURL fileURLWithPath:res];
        } else if (nameMethod == kTrackNameMethodWithURL) { /** URL*/
            BOOL isHttps = [MTypeCheck isHttps:res];
            NSString *newRes = res;
            if (!isHttps) { /** 替换为https*/
                newRes = [res stringByReplacingOccurrencesOfString:HTTP withString:HTTPS];
            }
            
            url = [NSURL URLWithString:newRes];
        }
        
        if (url != nil) {
            [urls addObject:url];
        }
    }
    
    return (NSArray<NSURL *> *)urls;
}

- (NSArray<AVURLAsset *> *__nonnull)urlAssets:(NSArray<NSURL *> *)urls nameMethod:(kTrackNameMethod)nameMethod {
    __block NSMutableArray<AVURLAsset *> *urlAssets = [NSMutableArray array];
    if (nameMethod == kTrackNameMethodWithURL) { /** 网络请求访问*/
        for (NSURL *url in urls) { /** 创建AVURLAsset*/
            [self.urlCache storeURLCache:[url.absoluteURL relativeString] completeHandler:^(AVAsset * _Nullable asset) {
                if (asset != nil) { /** 有缓存*/
                    [urlAssets addObject:(AVURLAsset *)asset];
                } else {
                    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
                    [urlAssets addObject:asset];
                }
            }];
        }
    } else {
        for (NSURL *url in urls) { /** 创建AVURLAsset*/
            AVURLAsset *asset = [AVURLAsset assetWithURL:url];
            [urlAssets addObject:asset];
        }
    }
    
    return (NSArray<AVURLAsset *> *)urlAssets;
}

#pragma mark - 合并
- (BOOL)trackWithNames:(NSArray<NSString *> *)resList spaceTimes:(NSArray<NSValue *> *)spaceTimes nameMethod:(kTrackNameMethod)nameMethod completeHandler:(void (^)(BOOL))completeHandler {
    BOOL flag = false;
    
    return flag;
}

- (BOOL)trackWithVideoNames:(NSArray<NSString *> *)videoResList audioNames:(NSArray<NSString *> *)audioNames spaceTimes:(NSArray<NSValue *> *)spaceTimes nameMethod:(kTrackNameMethod)nameMethod completeHandler:(void (^)(BOOL))completeHandler {
    BOOL flag = false;
    
    return flag;
}

- (BOOL)trackWithAssets:(NSArray<AVURLAsset *> *)assets spaceTimes:(NSArray<NSValue *> *)spaceTimes completeHandler:(void (^)(BOOL))completeHandler {
    BOOL flag = false;
    
    return flag;
}

- (BOOL)compositionTracks:(AVMutableComposition* __nonnull)composition assets:(NSArray<AVURLAsset *> *__nonnull)assets spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes completeHandler:(nonnull BOOL (^)(NSMutableArray<NSValue *> * _Nonnull))completeHandler {
    /** 判断spaceTimes和assets个数问题*/
    NSMutableArray<NSValue *> *newSpaceTimes;
    if (spaceTimes.count != 0) {
        newSpaceTimes = [NSMutableArray arrayWithArray:spaceTimes];
        NSInteger spaceTimesTotal = spaceTimes.count;
        NSInteger assetsTotal = assets.count;
        /** 取差值*/
        NSInteger differentialNum = labs(assetsTotal - spaceTimesTotal);
        if (differentialNum > 0) { /** 需要补充spaceTimes*/
            for (NSInteger i = 0; i < differentialNum; i++) {
                [newSpaceTimes addObject:spaceTimes.lastObject];
            }
        }
    }
    
    return completeHandler(newSpaceTimes);
}

- (BOOL)exportWithPath:(NSString *__nonnull)outputPath composition:(AVMutableComposition *__nonnull)composition presetName:(NSString *const)presetName outputFileType:(NSString *const)outputFileType completeHandler:(void(^ _Nullable)(void))completeHandler { /** 导出操作*/
    MExport *export = [[MExport alloc] init];
    return [export exportWithPath:outputPath composition:composition presetName:presetName outputFileType:outputFileType completeHandler:completeHandler];
}

- (BOOL)exportWithPath:(NSString *)outputPath {
    return false;
}

- (BOOL)exportWithPath:(NSString *)outputPath completeHandler:(void (^)(void))completeHandler {
    return false;
}


@end
