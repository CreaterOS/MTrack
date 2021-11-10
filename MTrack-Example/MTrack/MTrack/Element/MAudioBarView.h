//
//  MAudioBarView.h
//  MTrack
//
//  Created by Mac on 2021/11/4.
//

#import <UIKit/UIKit.h>
#import "MAudioIntensityView.h"

NS_ASSUME_NONNULL_BEGIN

@interface MAudioBarView : UIScrollView

/**
 * 初始化
 *
 * @param frame 位置
 * @param path 路径
 * @return MAudioBarView
 */
- (instancetype)initWithFrame:(CGRect)frame path:(NSString *)path;

/**
 * 初始化
 *
 * @param frame 位置
 * @param url 地址
 *
 * @return MAudioBarView
 */
- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url;

/**
 * 初始化
 *
 * @param frame 位置
 * @param asset 资源
 *
 * @return MAudioBarView
 */
- (instancetype)initWithFrame:(CGRect)frame asset:(AVURLAsset *)asset;

/**
 * 配置UI
 *
 * @param path 路径
 */
- (void)showWithFile:(NSString *)path;

/**
 * 配置UI
 *
 * @param url 地址
 */
- (void)showWithURL:(NSURL *)url;

/**
 * 配置UI
 *
 * @param asset 资源
 */
- (void)showWithAsset:(AVURLAsset *)asset;

@end

NS_ASSUME_NONNULL_END
