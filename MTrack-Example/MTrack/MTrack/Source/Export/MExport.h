//
//  MExport.h
//  MTrack
//
//  Created by Mac on 2021/11/3.
//

/*
 
Copyright (C) 2021 Eorient Inc. All Rights Reserved.
 
Description:
 
 MExport [导出操作]
 
History:
 
21/11/03: Created by CreaterOS.
 
*/

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MExport : NSObject

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

@end

NS_ASSUME_NONNULL_END
