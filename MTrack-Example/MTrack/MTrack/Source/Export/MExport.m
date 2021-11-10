//
//  MExport.m
//  MTrack
//
//  Created by Mac on 2021/11/3.
//

#import "MExport.h"

@implementation MExport

- (BOOL)exportWithPath:(NSString *)outputPath composition:(id)composition presetName:(NSString *const)presetName outputFileType:(NSString *const)outputFileType completeHandler:(void (^)(void))completeHandler {
    __block BOOL flag = false;

    /** 文件存在则删除*/
    BOOL isRemoved = [self removeExistsFile:outputPath];
    if (isRemoved) {
        NSLog(@"删除成功");
    }
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:composition presetName:presetName];
    session.outputURL = [NSURL fileURLWithPath:outputPath];
    session.outputFileType = outputFileType;
    session.shouldOptimizeForNetworkUse = YES; /** 优化网络*/

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [session exportAsynchronouslyWithCompletionHandler:^{
        if (session.status == AVAssetExportSessionStatusCompleted) { /** 导出成功*/
            flag = true;
            
            if (completeHandler != nil) {
                completeHandler();
            }
        } else {
            /** AVAssetExportSessionStatus*/
            flag = false;
            NSLog(@"session.status = %@",@(session.status));
        }
        
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
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
