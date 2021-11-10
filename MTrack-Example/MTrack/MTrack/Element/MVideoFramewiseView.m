//
//  MVideoFramewiseView.m
//  MTrack
//
//  Created by Mac on 2021/11/4.
//

#import "MVideoFramewiseView.h"
#import "MMetaInfo.h"
#import "CommandHeader.h"

@interface MVideoFramewiseView()
@property (nonatomic, strong) UIScrollView *splitImagesBar;
@end

@implementation MVideoFramewiseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame filePath:(NSString *)filePath {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
        [self spliteImagesViewWithFile:filePath];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup:frame];
        [self spliteImagesViewWithURL:url];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame asset:(AVURLAsset *)asset {
    if (self = [super initWithFrame:frame]) {
        [self setup:frame];
        [self spliteImagesViewWithAsset:asset];
    }
    
    return self;
}

- (void)setup:(CGRect)frame { /** 配置UI*/
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    UIScrollView *splitImagesBar = [[UIScrollView alloc] initWithFrame:rect];
    [splitImagesBar setBackgroundColor:UIColor.systemBlueColor];
    splitImagesBar.showsVerticalScrollIndicator = NO;
    splitImagesBar.showsHorizontalScrollIndicator = NO;
    splitImagesBar.backgroundColor = UIColor.clearColor;
    splitImagesBar.alwaysBounceHorizontal = YES;
    splitImagesBar.bounces = NO;
    [self addSubview:splitImagesBar];
    self.splitImagesBar = splitImagesBar;
}

- (void)show:(NSArray<UIImage *> *)spliteImages {
    CGFloat width = CGRectGetHeight(self.frame) + 15.0;
    CGFloat height = width;
    NSUInteger total = spliteImages.count;
    self.splitImagesBar.contentSize = CGSizeMake(total * width, height);
    for (NSInteger i = 0; i < total; i++) {
        CGRect rect = CGRectMake(i*width, 0, width, height);
        UIImageView *splitImageView = [[UIImageView alloc] initWithFrame:rect];
        UIImage *splitImage = spliteImages[i];
        splitImageView.image = splitImage;
        [splitImageView setContentMode:UIViewContentModeScaleToFill];
        [self.splitImagesBar addSubview:splitImageView];
    }
}

#pragma mark - 逐帧操作
- (void)spliteImagesViewWithFile:(NSString *)filePath {
    NSAssert(filePath.length != 0, @"The file path cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:filePath]];
    [self spliteImagesViewWithAsset:asset];
}

- (void)spliteImagesViewWithURL:(NSURL *)url {
    NSAssert(url.absoluteString.length != 0, @"The url path cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    [self spliteImagesViewWithAsset:asset];
}

- (void)spliteImagesViewWithAsset:(AVURLAsset *)asset {
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];

    MMetaInfo *info = [[MMetaInfo alloc] init];
    NSDictionary *infoDict = [info metaInfoWithAsset:asset];
    NSValue *durationValue = infoDict[kMetaInfoKeyWithDuration];
    CMTime duration = [durationValue CMTimeValue];

    int64_t value = duration.value;
    int32_t timescale = duration.timescale;

    __block NSMutableArray<NSValue *> *requestedTimes = [NSMutableArray array];
    for (int64_t i = 1; i*timescale <= value; i++) { /** 添加关键帧*/
        @autoreleasepool {
            NSValue *requestedTimeValue = [NSValue valueWithCMTime:CMTimeMake(i * timescale, timescale)];
            [requestedTimes addObject:requestedTimeValue];
        }
    }

    __block NSMutableArray<UIImage *> *splitImages = [NSMutableArray array];
    [generator generateCGImagesAsynchronouslyForTimes:requestedTimes completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"获取关键帧视图失败");
            NSLog(@"%@",error.localizedDescription);
        }

        /// 存储帧图
        if (image != nil) {
            UIImage *splitImage = [UIImage imageWithCGImage:image scale:UIScreen.mainScreen.scale orientation:UIImageOrientationUp];
            [splitImages addObject:splitImage];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:splitImages];
        });
    }];
}

@end
