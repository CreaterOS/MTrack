//
//  MCache.m
//  MAudioTrack
//
//  Created by apple on 2021/10/24.
//

#import "MCache.h"
#import "MAssetModel.h"
#import "CommandHeader.h"

typedef NS_ENUM(NSUInteger, kClearMethod) {
    kClearWithLRUTime, /** 根据时间清理*/
    kClearWithLRU, /** 根据更新顺序清理*/
    kClearWithAll /** 清理全部*/
};

@interface MCache()
@property (nonatomic, strong) NSCache *cache; /** 缓存*/

@property (nonatomic, assign) NSUInteger cacheCount; /** 缓存数目*/

@property (nonatomic, strong) NSMutableArray<NSString *> *keys; /** 缓存key集合*/
@end

@implementation MCache

static MCache *_instance = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MCache alloc] init];
    });
    
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        /** 配置缓存*/
        [self configCache];
        
        /** 监听内存*/
        WEAK(self);
        [[NSNotificationCenter defaultCenter] addObserverForName:@"UIApplicationDidReceiveMemoryWarningNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
            STRONG(weakself);
            /** LRU*/
            NSMutableArray<NSString *> *removeKeys;
            removeKeys = [self addRemoveKeysMethod:kClearWithLRUTime];
            for (NSString *key in removeKeys) {
                [self.cache removeObjectForKey:key];
            }
        }];
    }
    return self;
}

#pragma mark - 配置
- (void)configCache { /** 配置缓存*/
    self.cache = [[NSCache alloc] init];
    self.keys = [NSMutableArray array];
    
    self.clearMode = kCacheClearAuto; /** 缓存自动清理*/
}

#pragma mark - 缓存操作
- (void)storeCacheModel:(id)model key:(NSString *__nonnull)key { /** 存储模型*/
    if (_cache == nil) {
        return ;
    }
    
    if (_totalCostLimit < _countLimit) {
        if (_clearMode == kCacheClearAuto && _cacheCount >= _totalCostLimit) { /** 清理上限*/
            [self clearCacheMethod:kClearWithLRUTime]; /** 缓存时间清理*/
        } else if (_clearMode == kCacheClearMax && _cacheCount == _countLimit) { /** 缓存上限*/
            [self clearCacheMethod:kClearWithAll]; /** 清理全部*/
        }
        
        /** 缓存*/
        [_cache setObject:model forKey:key];
        
        /** 记录key*/
        [_keys addObject:key];
    
        self.cacheCount++;
    }
}

- (void)updateCacheModel:(id)model key:(NSString *)key {
    if ([[_cache objectForKey:key] isEqual:model]) {
        [_cache setObject:model forKey:key];
    }
}

- (id)modelOfCacheForKey:(NSString *__nonnull)key { /** 获取模型*/
    if (_cache == nil) {
        return nil;
    }
    
    id value = [_cache objectForKey:key];
    return value;
}

- (void)clearCacheMethod:(kClearMethod)method { /** 清理缓存模型*/
    NSMutableArray<NSString *> *removeKeys;
    
    removeKeys = [self addRemoveKeysMethod:method];
    
    for (NSString *key in removeKeys) {
        [_cache removeObjectForKey:key];
    }
    
    if (_cacheCount >= _totalCostLimit) {
        /** 清除全部*/
        [self clearCacheMethod:kClearWithAll];
    }
}

- (NSMutableArray<NSString *> *)addRemoveKeysMethod:(kClearMethod)method {
    /**
     1. 根据缓存时间清理
     2. 根据缓存大小判断是否删除
     */
    NSMutableArray<NSString *> *removeKeys = [NSMutableArray array];
    for (NSString *key in _keys) { /** 遍历存储缓存模型*/
        id model = [_cache objectForKey:key];
        if ([model isKindOfClass:[MAssetModel class]]) {
            MAssetModel *assetModel = (MAssetModel *)model;
            
            if (method == kClearWithLRUTime) { /** LRU 时间清理*/
                NSDate *date = assetModel.date; /** 缓存时间*/
                NSTimeInterval lastStoreTime = [date timeIntervalSince1970];
                NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
                
                if (currentTime - lastStoreTime > 50.0) {
                    [removeKeys addObject:key]; /** 添加删除key*/
                }
            } else if (method == kClearWithAll) { /** 清除全部*/
                [removeKeys addObjectsFromArray:_keys];
                break;
            }
        }
    }
    
    return removeKeys;
}

#pragma mark - 清理策略
/**
 先进先出策略FIFO（First In， First Out）
 最少使用策略LFU（Least Frequently Used）
 最近最少使用策略LRU（Least Recently Used）
 */
- (void)clearWithLRU { /** Least Recently Used*/
    if (_keys != nil) {
        return;
    }
    
    /** 根据传入的时间进行排序*/
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    for (NSString *key in _keys) {
        id model = [_cache objectForKey:key];
        if ([model isKindOfClass:[MAssetModel class]]) { /** 模型匹配*/
            MAssetModel *assetModel = (MAssetModel *)model;
            NSTimeInterval timeInterval = [assetModel.date timeIntervalSince1970];
            [dict setValue:@(timeInterval) forKey:key];
        }
    }
    
    /** 排序*/
    NSArray *timeIntervalArr = [dict allValues];
    [timeIntervalArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if ([obj1 doubleValue] >= [obj2 doubleValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    
    /** 删除一半*/
    NSInteger removeCount = _countLimit / 2;
    for (NSInteger i = 0; i < removeCount; i++) {
        NSInteger valueIndex = [[dict allValues] indexOfObject:timeIntervalArr[i]];
        NSString *key = [[dict allKeys] objectAtIndex:valueIndex];
        [_cache removeObjectForKey:key];
    }
}

- (void)clearWithFIFO { /** First In， First Out*/
    if (_keys != nil) {
        return;
    }
    
    NSInteger removeCount = _countLimit / 2;
    
    for (NSInteger i = 0; i < removeCount; i++) {
        NSString *key = [_keys objectAtIndex:i];
        [_cache removeObjectForKey:key];
    }
}

#pragma mark - Setter
- (void)setCountLimit:(NSInteger)countLimit {
    _countLimit = countLimit;
}

- (void)setTotalCostLimit:(NSInteger)totalCostLimit {
    _totalCostLimit = totalCostLimit;
}

@end
