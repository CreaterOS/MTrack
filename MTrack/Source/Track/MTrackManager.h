//
//  MTrackManager.h
//  MTrack
//
//  Created by Mac on 2021/10/27.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "MTypeCheck.h"
#import "CommandHeader.h"

typedef NS_ENUM(NSUInteger, kTrackNameMethod) {
    kTrackNameMethodWithBundle, /** NSBundle*/
    kTrackNameMethodWithPath, /** 路径*/
    kTrackNameMethodWithURL, /** 网络路径*/
};

void runSynchronouslyOnTrackQueue(void(^_Nonnull block)(void));
void runAsynchronouslyOnTrackQueue(void(^_Nonnull block)(void));

NS_ASSUME_NONNULL_BEGIN

@interface MTrackManager : NSObject
@property (nonatomic, copy) dispatch_queue_t trackQueue;


@property (nonatomic, strong) AVURLAsset *audioAsset;
@property (nonatomic, strong) AVURLAsset *videoAsset;

/**
 * 单利模式
 *
 * @return MTrackManager
 */
+ (instancetype)shared;

/**
 * 类型校验
 *
 * @param resList 资源集合
 * @param type 类型
 *
 * @return 检验状态
 */
- (BOOL)typeCheck:(NSArray<NSString *> *__nonnull)resList type:(NSString *__nonnull)type;

/**
 * URL地址集合
 *
 * @param resList 资源集合
 * @param nameMethod 请求方式
 *
 * @return 地址集合
 */
- (NSArray<NSURL *> *__nonnull)paths:(NSArray<NSString *> *__nonnull)resList nameMethod:(kTrackNameMethod)nameMethod;

/**
 * Assets集合
 *
 * @param urls 地址集合
 * @param nameMethod 请求方式
 *
 * @return Assets集合
 */
- (NSArray<AVURLAsset *> *__nonnull)urlAssets:(NSArray<NSURL *> *)urls nameMethod:(kTrackNameMethod)nameMethod;

/**
 * 合并
 *
 * @param resList 资源集合
 * @param nameMethod 请求方式
 * @param spaceTimes 间隔时间
 * @param completeHandler 完成回调
 *
 * @return 状态
 */
- (BOOL)trackWithNames:(NSArray<NSString *> *)resList spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes nameMethod:(kTrackNameMethod)nameMethod completeHandler:(void (^)(BOOL))completeHandler;

/**
 * 合并
 *
 * @param videoResList 视频资源集合
 * @param audioNames 音频资源集合
 * @param nameMethod 请求方式
 * @param spaceTimes 间隔时间
 * @param completeHandler 完成回调
 *
 * @return 状态
 */
- (BOOL)trackWithVideoNames:(NSArray<NSString *> *)videoResList audioNames:(NSArray<NSString *> *)audioNames spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes nameMethod:(kTrackNameMethod)nameMethod completeHandler:(void (^)(BOOL))completeHandler;

/**
 * 合并
 *
 * @param assets 资源
 * @param spaceTimes 间隔时间
 * @param completeHandler 完成回调
 *
 * @return 状态
 */
- (BOOL)trackWithAssets:(NSArray<AVURLAsset *> *)assets spaceTimes:(NSArray<NSValue *> *_Nullable)spaceTimes completeHandler:(void (^ _Nullable)(BOOL))completeHandler;

/**
 * 合并操作
 *
 * @param composition AVMutableComposition
 * @param assets 资源集合
 * @param spaceTimes 间隔时间
 * @param completeHandler 完成回调
 * @return 状态
 */
- (BOOL)compositionTracks:(AVMutableComposition* __nonnull)composition assets:(NSArray<AVURLAsset *> *__nonnull)assets spaceTimes:(NSArray<NSValue *> *__nullable)spaceTimes completeHandler:(BOOL (^)(NSMutableArray<NSValue *> *))completeHandler;

/**
 * 导出操作
 *
 * @param outputPath 保存路径
 * @param composition AVMutableComposition
 * @param presetName 导出配置
 * @param outputFileType 输出文件类型
 * @param completeHandler 完成回调
 *
 * @return 状态
 */
- (BOOL)exportWithPath:(NSString *__nonnull)outputPath composition:(AVMutableComposition *__nonnull)composition presetName:(NSString *const)presetName outputFileType:(NSString *const)outputFileType completeHandler:(void(^ _Nullable)(void))completeHandler;

/**
 * 导出操作
 *
 * @param outputPath 保存路径
 *
 * @return 状态
 */
- (BOOL)exportWithPath:(NSString *__nonnull)outputPath;

/**
 * 导出操作
 *
 * @param outputPath 保存路径
 * @param completeHandler 完成回调
 *
 * @return 状态
 */
- (BOOL)exportWithPath:(NSString *__nonnull)outputPath completeHandler:(void (^ _Nullable)(void))completeHandler;

@end

NS_ASSUME_NONNULL_END
