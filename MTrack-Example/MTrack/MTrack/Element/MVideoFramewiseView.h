//
//  MVideoFramewiseView.h
//  MTrack
//
//  Created by Mac on 2021/11/4.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MVideoFramewiseView : UIView

/**
 * 初始化
 *
 * @param frame 位置
 *
 * @return MVideoFramewiseView
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 * 初始化
 *
 * @param frame 位置
 * @param filePath 文件路径
 *
 * @return MVideoFramewiseView
 */
- (instancetype)initWithFrame:(CGRect)frame filePath:(NSString *__nonnull)filePath;

/**
 * 初始化
 *
 * @param frame 位置
 * @param url 地址
 *
 * @return MVideoFramewiseView
 */
- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *__nonnull)url;

/**
 * 初始化
 *
 * @param frame 位置
 * @param asset 资源
 *
 * @return MVideoFramewiseView
 */
- (instancetype)initWithFrame:(CGRect)frame asset:(AVURLAsset *)asset;

/**
 * 显示逐帧
 *
 * @param filePath 文件路径
 */
- (void)spliteImagesViewWithFile:(NSString *__nonnull)filePath;

/**
 * 显示逐帧
 *
 * @param url 地址
 */
- (void)spliteImagesViewWithURL:(NSURL *__nonnull)url;

/**
 * 显示逐帧
 *
 * @param asset 资源
 */
- (void)spliteImagesViewWithAsset:(AVURLAsset *)asset;

@end

NS_ASSUME_NONNULL_END
