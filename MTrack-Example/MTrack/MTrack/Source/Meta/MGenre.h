//
//  MGenre.h
//  MTrack
//
//  Created by Mac on 2021/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MGenre : NSObject <NSCopying>

@property (nonatomic, readonly) NSUInteger index;
@property (nonatomic, copy, readonly) NSString *name;

+ (NSArray *)musicGenres;

+ (NSArray *)videoGenres;

+ (MGenre *)id3GenreWithIndex:(NSUInteger)index;

+ (MGenre *)id3GenreWithName:(NSString *)name;

+ (MGenre *)iTunesGenreWithIndex:(NSUInteger)index;

+ (MGenre *)videoGenreWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
