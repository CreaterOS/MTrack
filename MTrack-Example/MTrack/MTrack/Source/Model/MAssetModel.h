//
//  MAssetModel.h
//  MAudioTrack
//
//  Created by Mac on 2021/10/25.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MAssetModel : NSObject
@property (nonatomic, copy) NSString *urlStr; /** URL路径*/
@property (nonatomic, strong) AVAsset *asset;
@property (nonatomic, strong) NSDate *date; /** 保存时间*/
@end

NS_ASSUME_NONNULL_END
