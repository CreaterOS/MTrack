//
//  MAudioBarView.m
//  MTrack
//
//  Created by Mac on 2021/11/4.
//

#import "MAudioBarView.h"

@implementation MAudioBarView

- (instancetype)initWithFrame:(CGRect)frame path:(NSString *)path {
    if (self = [super initWithFrame:frame]) {
        [self showWithFile:path];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame url:(NSURL *)url {
    if (self = [super initWithFrame:frame]) {
        [self showWithURL:url];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame asset:(AVURLAsset *)asset {
    if (self = [super initWithFrame:frame]) {
        [self showWithAsset:asset];
    }
    
    return self;
}

- (void)showWithFile:(NSString *)path {
    NSAssert(path.length != 0, @"The file path cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    [self showWithAsset:asset];
}

- (void)showWithURL:(NSURL *)url {
    NSAssert(url.absoluteString.length != 0, @"The url path cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    [self showWithAsset:asset];
}

- (void)showWithAsset:(AVURLAsset *)asset {
    [self config];
    
    ///
    MAudioIntensityView *intensityView = [[MAudioIntensityView alloc] init];
    intensityView.backgroundColor = UIColor.blackColor;
    intensityView.frame = CGRectMake(0, 0, 1000, CGRectGetHeight(self.bounds));
    [intensityView intensityWithAsset:asset];
    [self addSubview:intensityView];
}

- (void)config {
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.alwaysBounceVertical = NO;
    self.bounces = NO;
    
    self.contentSize = CGSizeMake(1000.0, CGRectGetHeight(self.bounds));
}

@end
