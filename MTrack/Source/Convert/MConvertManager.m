//
//  MConvertManager.m
//  MTrack
//
//  Created by Mac on 2021/11/5.
//

#import "MConvertManager.h"
#import "MTypeCheck.h"
#import "CommandHeader.h"

#define TIME(num) [self frameRate:_frameRate] * num;

@implementation MConvertManager

#pragma mark - 单例模式
static MConvertManager *_instance = nil;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[MConvertManager alloc] init];
    });
    
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.frameRate = kFrameRatePreset30; /** 帧率*/
        self.time = 3; /** 时间*/
    }
    
    return self;
}

#pragma mark - 转换
- (void)convertPhotoToVideo:(UIImage *)image completeHandler:(void (^ _Nullable)(NSString *))completeHandler{
    NSParameterAssert(image != nil);
    
    /** 临时目录*/
    NSString *temporaryDir = NSTemporaryDirectory();
    NSString *path = [temporaryDir stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",[NSUUID UUID].UUIDString]];
        
    [self convertPhotoToVideo:image outputPath:path completeHandler:completeHandler];
}

- (void)convertPhotoToVideo:(UIImage *)image outputPath:(NSString *)outputPath completeHandler:(void(^ _Nullable)(NSString *))completeHandler {
    NSParameterAssert(image != nil);
    NSAssert(outputPath.length != 0, @"The incoming audio resource cannot be empty");
    
    NSUInteger multiple = 16;
    CGSize size = CGSizeMake((CGImageGetWidth([image CGImage]) / multiple) * multiple, (CGImageGetHeight([image CGImage]) / multiple) * multiple);

    NSString *path = outputPath;
    if (![self typeCheck:path type:kTypeMOV] || ![self typeCheck:path type:kTypeQT]) { /** 类型转换*/
        if ([path containsString:DOT]) { /** 是否包含点*/
            path = [[path componentsSeparatedByString:DOT].firstObject stringByAppendingString:[NSString stringWithFormat:@"%@%@",DOT,kTypeMOV]];
        }
    }
    
    /** 删除已存在文件*/
    [self removeExistsFile:path];

    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:url fileType:AVFileTypeQuickTimeMovie error:&error];
    if (error != nil) {
        NSLog(@"%@",error.localizedDescription);
        return ;
    }
    
    NSDictionary<NSString *,id> *outputSettings = @{
        AVVideoCodecKey : AVVideoCodecTypeH264,
        AVVideoWidthKey : [NSNumber numberWithInt:(int)size.width],
        AVVideoHeightKey : [NSNumber numberWithInt:(int)size.height]
    };
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:outputSettings];
    NSDictionary *sourcePixelBufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:assetWriterInput sourcePixelBufferAttributes:sourcePixelBufferAttributes];
    
    if (![videoWriter canAddInput:assetWriterInput]) {
        return ;
    }
    
    [videoWriter addInput:assetWriterInput];
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    

    __block int i = 0;

    NSUInteger time = TIME(self.time);
    
    [assetWriterInput requestMediaDataWhenReadyOnQueue:dispatch_queue_create("mediaInputQueue", NULL) usingBlock:^{
        while ([assetWriterInput isReadyForMoreMediaData]) {
            if (++i > time) {
                [assetWriterInput markAsFinished]; /** 必须调用*/
                [videoWriter finishWritingWithCompletionHandler:^{
                    /** 合并视频成功*/
                    if (completeHandler != nil) {
                        completeHandler(outputPath);
                    }
                }];
            }
            
            break;
        }
        
        CVPixelBufferRef buffer = NULL;
    
        buffer = (CVPixelBufferRef)[self pixelBufferFromCGImage:[image CGImage] size:size];
        
        if (buffer) {
            int32_t timescale = [self frameRate:self.frameRate];
            if (![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(i, timescale)]) {
                
            } else {
                NSLog(@"合成中");
            }
            
            CFRelease(buffer);
        }
        
    }];
}

- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size {
    CVPixelBufferRef pixelBuffer = NULL;
    NSDictionary *options = nil;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge  CFDictionaryRef)options, &pixelBuffer);
    NSParameterAssert(status == kCVReturnSuccess && pixelBuffer != NULL);
    CVPixelBufferLockBaseAddress(pixelBuffer, 0); /** 锁定pixelBuffer*/
    
    void *pixelData = CVPixelBufferGetBaseAddress(pixelBuffer);
    NSParameterAssert(pixelData != NULL);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    size_t bitsPerComponent = 8;
    size_t bytesPerRow = size.width * 4;
    uint32_t bitmapInfo = kCGImageAlphaPremultipliedFirst;
    CGContextRef context = CGBitmapContextCreate(pixelData, size.width, size.height, bitsPerComponent, bytesPerRow, colorSpaceRef, bitmapInfo);
    NSParameterAssert(context);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    
    CGColorSpaceRelease(colorSpaceRef);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pixelBuffer,0); /** 解锁pixelBuffer*/
    
    return pixelBuffer;
}

- (int32_t)frameRate:(kFrameRatePreset)preset {
    switch (preset) {
        case kFrameRatePreset30:
            return 30;
            break;
        case kFrameRatePreset60:
            return 60;
            break;
            
        default:
            return 30;
            break;
    }
}

- (BOOL)typeCheck:(NSString *__nonnull)path type:(NSString *__nonnull)type { /** 类型校验*/
    BOOL flag = false;
    
    if ([path containsString:DOT]) { /** 是否包含点*/
        NSString *typeName = [path componentsSeparatedByString:DOT].lastObject;
        /** 判断类型*/
        flag = [MTypeCheck isType:type typeName:[typeName lowercaseString]];
    }
    
    return flag;
}

- (BOOL)removeExistsFile:(NSString *__nonnull)outputPath {
    BOOL flag = false;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:outputPath]) {
        NSError *error = nil;
        BOOL isRemove = [fileManager removeItemAtPath:outputPath error:&error];
        if (!isRemove) { /** 删除失败*/
            if (error != nil) {
                NSLog(@"%@",error.localizedDescription);
            }
        }
        
        flag = isRemove;
    }
    
    return flag;
}

@end
