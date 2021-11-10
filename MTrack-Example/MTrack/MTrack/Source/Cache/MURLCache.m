//
//  MURLCache.m
//  MAudioTrack
//
//  Created by apple on 2021/10/23.
//

#import "MURLCache.h"
#import "MCache.h"
#import "MAssetModel.h"
#import "CommandHeader.h"

@interface MURLCache()
@property (nonatomic, copy) NSString *localLastModified;

@property (nonatomic, strong) MCache *cache;
@end

#define MEMORYCAPACITY(memoryCapacity) memoryCapacity * 1024 * 1024
#define DISKCAPACITY(diskCapacity) diskCapacity * 1024 * 1024

@implementation MURLCache

#pragma mark - LazyInit
- (MCache *)cache {
    if (!_cache) {
        _cache = [MCache shared];
        
        /** 配置*/
        [_cache setCountLimit:10];
        [_cache setTotalCostLimit:7];
    }
    
    return _cache;
}

static MURLCache *_instance = nil;
+ (instancetype)sharedURLCache {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MURLCache alloc] init];
    });
    
    return _instance;
}

- (void)storeURLCache:(NSString *__nonnull)urlStr completeHandler:(void(^)(AVAsset *))completeHandler {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:MEMORYCAPACITY(_memoryCapacity) diskCapacity:DISKCAPACITY(_diskCapacity) directoryURL:nil];
    [NSURLCache setSharedURLCache:URLCache]; /** 设置为全局访问*/
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
    
    /** 忽略缓存设置，通过服务器进行判断*/
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    
    /** 发送LastModified*/
    if (self.localLastModified.length > 0) {
        [request setValue:self.localLastModified forHTTPHeaderField:@"If-Modified-Since"];
    }

    __block AVAsset *asset = nil;
    WEAK(self);
    dispatch_semaphore_t single = dispatch_semaphore_create(0); /** 创建信号量*/
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        STRONG(weakself);
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSInteger statusCode = httpResponse.statusCode; /** 请求状态码*/
        
        if (statusCode == 304) { /** Not Modified*/
            /** 使用本地缓存*/
            MAssetModel *model = (MAssetModel *)[self.cache modelOfCacheForKey:urlStr];
            if (model != nil) {
                model.date = [NSDate date]; /** 更新缓存时间*/
                asset = model.asset;
                
                /** 更新缓存*/
                [self.cache updateCacheModel:model key:model.urlStr];
            } else {
                [self addCache:urlStr];
            }
           
        } else {
            /** 添加缓存*/
            [self addCache:urlStr];
        }
        
        self.localLastModified = httpResponse.allHeaderFields[@"Last-Modified"];
        
        if (completeHandler != nil) {
            completeHandler(asset);
        }
        
        dispatch_semaphore_signal(single); /** 注册信号量*/
    }] resume];
    
    dispatch_semaphore_wait(single, DISPATCH_TIME_FOREVER); /** 等待信号量*/
}

- (void)addCache:(NSString *__nonnull)urlStr {
    MAssetModel *assetModel = [[MAssetModel alloc] init];
    assetModel.urlStr = urlStr;
    assetModel.asset = [AVAsset assetWithURL:[NSURL URLWithString:urlStr]];
    assetModel.date = [NSDate date];
    [self.cache storeCacheModel:assetModel key:assetModel.urlStr];
}

@end
