//
//  CommandHeader.h
//  MAudioTrack
//
//  Created by Mac on 2021/10/21.
//

#ifndef CommandHeader_h
#define CommandHeader_h

#define DOT @"." /** 点*/
#define HTTP @"http"
#define HTTPS @"https"

/** 音频*/
#define kTypeAudio @"audio"
#define kTypeMP3 @"mp3"
#define kTypePCM @"pcm"
#define kTypeWAV @"wav"
#define kTypeAMR @"amr"
#define kTypeAAC @"aac"
#define kTypeCAF @"caf"

/** 视频*/
#define kTypeVideo @"video"
#define kTypeMP4 @"mp4"
#define kTypeMOV @"mov"
#define kTypeM4A @"m4a"
#define kTypeQT @"qt"

#define kMetaInfoKeyWithDuration @"duration"

#define WEAK(self) __weak typeof(self) weakself = self
#define STRONG(weakself) __strong typeof(weakself) self = weakself

#endif /* CommandHeader_h */
