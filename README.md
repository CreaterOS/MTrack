# MTrack

​	This framework allows developers to quickly manipulate audio and video splicing operations.We welcome your feedback in [issues](https://github.com/CreaterOS/MTrack/issues) and [pull requests](https://github.com/CreaterOS/MTrack/pulls). 

​	Thanks to all of [our contributors](https://twitter.com/bryant_reyn).

## Introduction

​	In audio and video development, developers often splice audio and video. In the process of splicing often encounter some universal problems, MTrack provides a convenient splicing audio and video operation interface, will be public error processing package. Easy for developers to splice in the project.

- Audio tail track
- Audio tail gap track
- ReVideo tail track
- Video tail gap track
- Image tail track

### Install

```
# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MyApp' do
    use_frameworks!

    pod'Paintinglite', :git =>'https://github.com/CreaterOS/MTrack.git'#, :tag => '2.1.3'
end
```

```
pod install
```

### Usage

#### 1. Audio

1. **Bundle Name**

   ​	Use the NSBundle load audio resources,need to enter an audio name with a type suffix. The audio type support MP3, WAV, or CAF. You can perform required operations in the callback.
   ​	Export video resources by passing the export path.Export type is M4A.

   ```objective-c
   MAudioTrackAudioManager *trackAudioManager = [MAudioTrackAudioManager shared];
   [trackAudioManager trackAudiosWithBundleForNames:@[@"1638.mp3",@"11582.mp3"] completeHandler:^(BOOL flag) {
     if (flag) {
       // Finish
     }
   }];
   [trackAudioManager exportWithPath:path completeHandler:nil];
   ```

   ​	If you want to add a space time to the concatenation process, you can pass in CMTime through the array, and MAudioTrackAudioManager will automatically add a space time between the two sounds directly for you.

   ```objective-c
   MAudioTrackAudioManager *trackAudioManager = [MAudioTrackAudioManager shared];
   [trackAudioManager trackAudiosWithBundleForNames:@[@"1638.mp3",@"11582.mp3"] spaceTimes:@[[NSValue valueWithCMTime:CMTimeMake(5.0, 1.0)]] completeHandler:^(BOOL flag) {
   if (flag) {
   // Finish
   }
   }];
   [trackAudioManager exportWithPath:path completeHandler:nil];
   ```

   

2. **Path**

   Use the absolute path load audio resources,need to enter an audio name with a type suffix. 

   ```objective-c
   MAudioTrackAudioManager *trackAudioManager = [MAudioTrackAudioManager shared];
   [trackAudioManager trackAudiosWithPathForNames:(NSArray<NSString *> * _Nonnull) completeHandler:^(BOOL flag) {
   }];
   [trackAudioManager exportWithPath:path completeHandler:nil];
   ```

   ```objective-c
   MAudioTrackAudioManager *trackAudioManager = [MAudioTrackAudioManager shared];
   [trackAudioManager trackAudiosWithPathForNames:(NSArray<NSString *> * _Nonnull) spaceTimes:(NSArray<NSValue *> * _Nullable) completeHandler:^(BOOL flag) {
   }];
   [trackAudioManager exportWithPath:path completeHandler:nil];
   ```

3. **URL**

   Use the url load audio resources,need to enter an audio name with a type suffix. 

   ```objective-c
   MAudioTrackAudioManager *trackAudioManager = [MAudioTrackAudioManager shared];
   [trackAudioManager trackAudiosWithURLForNames:(NSArray<NSString *> * _Nonnull) completeHandler:^(BOOL flag) {
   }];
   [trackAudioManager exportWithPath:path completeHandler:nil];
   ```

   ```objective-c
   MAudioTrackAudioManager *trackAudioManager = [MAudioTrackAudioManager shared];
   [trackAudioManager trackAudiosWithURLForNames:(NSArray<NSString *> * _Nonnull) spaceTimes:(NSArray<NSValue *> * _Nullable) completeHandler:^(BOOL flag) {
   }];
   [trackAudioManager exportWithPath:path completeHandler:nil]
   ```

#### 2. Video

1. **Bundle Name**

   ​	Use the NSBundle load video resources,need to enter an video name with a type suffix. The video type support MP4. You can perform required operations in the callback.
   ​	Export video resources by passing the export path.Export type is MP4.

   ```objective-c
   MVideoTrackVideoManager *videoTrackVideoManager = [MVideoTrackVideoManager shared];
   [videoTrackVideoManager trackVideoWithBundleForNames:@[@"01.mp4",@"02.mp4"] completeHandler:^(BOOL flag) {
   if (flag) {
   // Finish
   }
   }];
   [videoTrackVideoManager exportWithPath:path completeHandler:nil];
   ```

2. **Path**

   Use the absolute path load video resources,need to enter an video name with a type suffix. 

   ```objective-c
   MVideoTrackVideoManager *videoTrackVideoManager = [MVideoTrackVideoManager shared];
   [videoTrackVideoManager trackVideoWithPathForNames:(NSArray<NSString *> * _Nonnull) completeHandler:^(BOOL flag) {
   }];
   [videoTrackVideoManager exportWithPath:path completeHandler:nil];
   ```

3. **URL**

   Use the url load video resources,need to enter an video name with a type suffix.

   ```objective-c
   MVideoTrackVideoManager *videoTrackVideoManager = [MVideoTrackVideoManager shared];
   [videoTrackVideoManager trackVideoWithURLForNames:(NSArray<NSString *> * _Nonnull) completeHandler:^(BOOL flag) {
   }];
   [videoTrackVideoManager exportWithPath:path completeHandler:nil];
   ```

#### 3.VideoTrackAudio

##### Sets the audio scope

​	Use setMode: method to set duration baseline with Audio or Video.

> kDurationBaselineModeWithAudio
>
> ​	The duration of the spliced audio depends on the audio length
>
> kDurationBaselineModeWithVideo	
>
> ​	The duration of the spliced audio depends on the video length
>
> Use kDurationBaselineModeWithVideo and set setIsClipDuration is YES equals to kDurationBaselineModeWithAudio.

1. **Bundle Name**

   ​	Use the NSBundle load video resources and audio resources,need to enter an video name with a type suffix and audio name with a type suffix. The video type support MP4,audio type support MP3,WAV,M4A etc. You can perform required operations in the callback.
   ​	Export video resources by passing the export path.Export type is MP4.

   ```objective-c
   MVideoTrackAudioManager *videoTrackAudioManager = [MVideoTrackAudioManager shared];
   [videoTrackAudioManager trackVideoWithBundleForNames:@[@"01.mp4",@"02.mp4"] audioWithBundleNames:@[@"audio.mp3"] completeHandler:^(BOOL flag) {
   if (flag) {
   // Finish
   }
   }];
   [videoTrackAudioManager exportWithPath:path completeHandler:nil];
   ```

2. **Path**

   ​	Use the absolute path load video resources and audio resources,need to enter an video name with a type suffix and audio name with a type suffix. 

   ```objective-c
   MVideoTrackAudioManager *videoTrackAudioManager = [MVideoTrackAudioManager shared];
   [videoTrackAudioManager trackVideoWithPathForNames:(NSArray<NSString *> * _Nonnull) audioWithPathNames:(NSArray<NSString *> * _Nonnull) completeHandler:^(BOOL flag) {
   }];
   [videoTrackAudioManager exportWithPath:path completeHandler:nil];
   ```

3. **URL**

   ​	Use the url load video resources and audio resources,need to enter an video name with a type suffix and audio name with a type suffix. 

   ```objective-c
   MVideoTrackAudioManager *videoTrackAudioManager = [MVideoTrackAudioManager shared];
   [videoTrackAudioManager trackVideoWithURLForNames:(NSArray<NSString *> * _Nonnull) audioWithURLNames:(NSArray<NSString *> * _Nonnull) completeHandler:^(BOOL flag) {
   }];
   [videoTrackAudioManager exportWithPath:path completeHandler:nil];
   ```

#### 4. Photo

​	Use MPhotoTrackPhotoManager pass in multiple pictures to be combined and set the display time of each picture. Here, the time is applied to the display length of all pictures.

```objective-c
MPhotoTrackPhotoManager *photoTrackPhotoManager = [MPhotoTrackPhotoManager shared];
[photoTrackPhotoManager trackPhotos:(nonnull NSArray<UIImage *> *) duration:(NSUInteger)duration];
[photoTrackPhotoManager exportWithPath:path completeHandler:nil];
```

### Maintainers

[@CreaterOS](https://github.com/CreaterOS)

### License
MIT License

### Contribute to this project

If you have a feature request or bug report, please feel free to send [863713745@qq.com](mailto:863713745@qq.com) to upload the problem, and we will provide you with revisions and help as soon as possible. Thank you very much for your support.

### Security Disclosure

If you have found the MTrack security vulnerabilities and vulnerabilities that need to be modified, you should email them to [863713745@qq.com](mailto:863713745@qq.com) as soon as possible. thank you for your support.
