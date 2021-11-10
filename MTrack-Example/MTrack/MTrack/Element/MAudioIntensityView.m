//
//  MAudioIntensityView.m
//  MTrack
//
//  Created by Mac on 2021/11/4.
//

#import "MAudioIntensityView.h"

@interface MAudioIntensityView()
@property (nonatomic, strong) NSMutableData *data;
@end

@implementation MAudioIntensityView

- (void)intensityWithFile:(NSString *)path {
    NSAssert(path.length != 0, @"The file path cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:path]];
    [self intensityWithAsset:asset];
}

- (void)intensityWithURL:(NSURL *)url {
    NSAssert(url.absoluteString.length != 0, @"The url path cannot be empty");
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    [self intensityWithAsset:asset];
}

- (void)intensityWithAsset:(AVURLAsset *__nonnull)asset {
    NSMutableData *data = [[NSMutableData alloc] init];

    NSError *error = nil;
    
    /// Reader
    AVAssetReader *reader = [AVAssetReader assetReaderWithAsset:asset error:&error];
    if (error != nil) {
        NSLog(@"%@",error.localizedDescription);
        return ;
    }
    
    /// Track
    AVAssetTrack *track = [[asset tracksWithMediaType:AVMediaTypeAudio] firstObject];
    if (!track) {
        return ;
    }
    
    NSDictionary *outputSettings = @{AVFormatIDKey:@(kAudioFormatLinearPCM), AVLinearPCMIsBigEndianKey:@NO, AVLinearPCMIsFloatKey:@NO, AVLinearPCMBitDepthKey:@(16)};
    AVAssetReaderTrackOutput *trackOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:track outputSettings:outputSettings];
    BOOL isCan = [reader canAddOutput:trackOutput];
    if (!isCan) {
        return ;
    }
    
    [reader addOutput:trackOutput];
    BOOL isStarted = [reader startReading];
    if (!isStarted) {
        return ;
    }
    
    /// Start Reading
    while (reader.status == AVAssetReaderStatusReading) {
        CMSampleBufferRef sampleBuffer = [trackOutput copyNextSampleBuffer];
        if (sampleBuffer) {
            CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer);
            size_t length = CMBlockBufferGetDataLength(blockBuffer);
            SInt16 sampleBytes[length];
            CMBlockBufferCopyDataBytes(blockBuffer, 0, length, sampleBytes);
            [data appendBytes:sampleBytes length:length];
            
            CMSampleBufferInvalidate(sampleBuffer); /// Invalidate
            CFRelease(sampleBuffer); /// Release
        }
    }
    
    self.data = data;
    
    [self setNeedsDisplay];
}

- (NSArray *)samplesForSize:(CGSize)size {
    NSMutableArray *filterSamples = [NSMutableArray array];
    
    NSUInteger sampleCount = self.data.length / sizeof(SInt16);
    NSUInteger binSize = sampleCount / size.width;
    SInt16 *bytes = (SInt16 *)self.data.bytes;
    SInt16 maxSample = 0;
    
    for (NSUInteger i = 0; i < sampleCount; i+=binSize) {
        SInt16 sampleBin[binSize];
        
        for (NSUInteger j = 0; j < binSize; j++) {
            sampleBin[j] = CFSwapInt16LittleToHost(bytes[i+j]);
        }
        
        SInt16 value = [self maxValueInArray:sampleBin ofSize:binSize];
        [filterSamples addObject:@(value)];
        
        if (value > maxSample) {
            maxSample = value;
        }
    }
        
    CGFloat scaleFactor = (size.height / 2) / maxSample;
    for (NSUInteger i = 0; i < filterSamples.count; i++) {
        filterSamples[i] = @([filterSamples[i] integerValue] * scaleFactor);
    }
    
    return filterSamples;
}

- (SInt16)maxValueInArray:(SInt16[])values ofSize:(NSUInteger)size {
    SInt16 maxvalue = 0;
    for (int i = 0; i < size; i++) {
        
        if (abs(values[i] > maxvalue)) {
            
            maxvalue = abs(values[i]);
        }
    }
    
    return maxvalue;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    ///
    [self waveformGraphic:rect];
//    [self intensityGraphic:rect];
}

#pragma mark - 绘图
- (void)waveformGraphic:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat scale = 1.0;
    CGContextScaleCTM(context, scale, scale);
    
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    CGFloat xOffset = width - width * scale;
    CGFloat yOffset = height - height * scale;
    CGContextTranslateCTM(context, xOffset/2, yOffset/2);
        
    NSArray *samples = [self samplesForSize:self.bounds.size];
    CGFloat midY = CGRectGetMidY(rect);
    
    CGMutablePathRef halfPath = CGPathCreateMutable();
    CGPathMoveToPoint(halfPath, nil, 0.0f, midY);
    
    [samples enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float sample = [obj floatValue];
        CGPathAddLineToPoint(halfPath, NULL, idx, midY - sample);
    }];
    
    CGPathAddLineToPoint(halfPath, NULL, samples.count, midY);
    
    CGMutablePathRef fullPath = CGPathCreateMutable();
    CGPathAddPath(fullPath, NULL, halfPath);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
  
    transform = CGAffineTransformTranslate(transform, 0, CGRectGetHeight(rect));
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    CGPathAddPath(fullPath, &transform, halfPath);
    
    CGContextSetFillColorWithColor(context, UIColor.orangeColor.CGColor);
    CGContextStrokePath(context);
    CGContextAddPath(context, fullPath);
    CGContextDrawPath(context, kCGPathFill);
    
    CGPathRelease(fullPath);
    CGPathRelease(halfPath);
}

- (void)intensityGraphic:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray *samples = [self samplesForSize:self.bounds.size];
    CGFloat midY = CGRectGetMidY(rect);
    
    [samples enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        float sample = [obj floatValue];
        CGFloat offsetY = midY-sample;
        CGPathRef halfPath = CGPathCreateWithRect(CGRectMake(idx*8.0, offsetY, 2.0,sample * 2.0), nil);
        CGContextSetFillColorWithColor(context, UIColor.orangeColor.CGColor);
        CGContextStrokePath(context);
        CGContextAddPath(context, halfPath);
        CGContextSetLineWidth(context, 5.0);
        CGContextDrawPath(context, kCGPathFill);
        CGPathRelease(halfPath);
    }];
}

@end
