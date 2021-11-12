//
//  MGenre.m
//  MTrack
//
//  Created by Mac on 2021/11/12.
//

#import "MGenre.h"

@implementation MGenre

+ (NSArray *)videoGenres {
    static dispatch_once_t predicate;
    static NSArray *videoGenres = nil;
    dispatch_once(&predicate, ^{
        videoGenres = @[[[MGenre alloc] initWithIndex:4000 name:@"Comedy"],
            [[MGenre alloc] initWithIndex:4001 name:@"Drama"],
            [[MGenre alloc] initWithIndex:4002 name:@"Animation"],
            [[MGenre alloc] initWithIndex:4003 name:@"Action & Adventure"],
            [[MGenre alloc] initWithIndex:4004 name:@"Classic"],
            [[MGenre alloc] initWithIndex:4005 name:@"Kids"],
            [[MGenre alloc] initWithIndex:4006 name:@"Nonfiction"],
            [[MGenre alloc] initWithIndex:4007 name:@"Reality TV"],
            [[MGenre alloc] initWithIndex:4008 name:@"Sci-Fi & Fantasy"],
            [[MGenre alloc] initWithIndex:4009 name:@"Sports"],
            [[MGenre alloc] initWithIndex:4010 name:@"Teens"],
            [[MGenre alloc] initWithIndex:4011 name:@"Latino TV"]];
    });
    return videoGenres;
}

+ (NSArray *)musicGenres {
    static dispatch_once_t predicate;
    static NSArray *musicGenres = nil;
    dispatch_once(&predicate, ^{
        musicGenres = @[[[MGenre alloc] initWithIndex:0 name:@"Blues"],
            [[MGenre alloc] initWithIndex:1 name:@"Classic Rock"],
            [[MGenre alloc] initWithIndex:2 name:@"Country"],
            [[MGenre alloc] initWithIndex:3 name:@"Dance"],
            [[MGenre alloc] initWithIndex:4 name:@"Disco"],
            [[MGenre alloc] initWithIndex:5 name:@"Funk"],
            [[MGenre alloc] initWithIndex:6 name:@"Grunge"],
            [[MGenre alloc] initWithIndex:7 name:@"Hip-Hop"],
            [[MGenre alloc] initWithIndex:8 name:@"Jazz"],
            [[MGenre alloc] initWithIndex:9 name:@"Metal"],
            [[MGenre alloc] initWithIndex:10 name:@"New Age"],
            [[MGenre alloc] initWithIndex:11 name:@"Oldies"],
            [[MGenre alloc] initWithIndex:12 name:@"Other"],
            [[MGenre alloc] initWithIndex:13 name:@"Pop"],
            [[MGenre alloc] initWithIndex:14 name:@"R&B"],
            [[MGenre alloc] initWithIndex:15 name:@"Rap"],
            [[MGenre alloc] initWithIndex:16 name:@"Reggae"],
            [[MGenre alloc] initWithIndex:17 name:@"Rock"],
            [[MGenre alloc] initWithIndex:18 name:@"Techno"],
            [[MGenre alloc] initWithIndex:19 name:@"Industrial"],
            [[MGenre alloc] initWithIndex:20 name:@"Alternative"],
            [[MGenre alloc] initWithIndex:21 name:@"Ska"],
            [[MGenre alloc] initWithIndex:22 name:@"Death Metal"],
            [[MGenre alloc] initWithIndex:23 name:@"Pranks"],
            [[MGenre alloc] initWithIndex:24 name:@"Soundtrack"],
            [[MGenre alloc] initWithIndex:25 name:@"Euro-Techno"],
            [[MGenre alloc] initWithIndex:26 name:@"Ambient"],
            [[MGenre alloc] initWithIndex:27 name:@"Trip-Hop"],
            [[MGenre alloc] initWithIndex:28 name:@"Vocal"],
            [[MGenre alloc] initWithIndex:29 name:@"Jazz+Funk"],
            [[MGenre alloc] initWithIndex:30 name:@"Fusion"],
            [[MGenre alloc] initWithIndex:31 name:@"Trance"],
            [[MGenre alloc] initWithIndex:32 name:@"Classical"],
            [[MGenre alloc] initWithIndex:33 name:@"Instrumental"],
            [[MGenre alloc] initWithIndex:34 name:@"Acid"],
            [[MGenre alloc] initWithIndex:35 name:@"House"],
            [[MGenre alloc] initWithIndex:36 name:@"Game"],
            [[MGenre alloc] initWithIndex:37 name:@"Sound Clip"],
            [[MGenre alloc] initWithIndex:38 name:@"Gospel"],
            [[MGenre alloc] initWithIndex:39 name:@"Noise"],
            [[MGenre alloc] initWithIndex:40 name:@"AlternRock"],
            [[MGenre alloc] initWithIndex:41 name:@"Bass"],
            [[MGenre alloc] initWithIndex:42 name:@"Soul"],
            [[MGenre alloc] initWithIndex:43 name:@"Punk"],
            [[MGenre alloc] initWithIndex:44 name:@"Space"],
            [[MGenre alloc] initWithIndex:45 name:@"Meditative"],
            [[MGenre alloc] initWithIndex:46 name:@"Instrumental Pop"],
            [[MGenre alloc] initWithIndex:47 name:@"Instrumental Rock"],
            [[MGenre alloc] initWithIndex:48 name:@"Ethnic"],
            [[MGenre alloc] initWithIndex:49 name:@"Gothic"],
            [[MGenre alloc] initWithIndex:50 name:@"Darkwave"],
            [[MGenre alloc] initWithIndex:51 name:@"Techno-Industrial"],
            [[MGenre alloc] initWithIndex:52 name:@"Electronic"],
            [[MGenre alloc] initWithIndex:53 name:@"Pop-Folk"],
            [[MGenre alloc] initWithIndex:54 name:@"Eurodance"],
            [[MGenre alloc] initWithIndex:55 name:@"Dream"],
            [[MGenre alloc] initWithIndex:56 name:@"Southern Rock"],
            [[MGenre alloc] initWithIndex:57 name:@"Comedy"],
            [[MGenre alloc] initWithIndex:58 name:@"Cult"],
            [[MGenre alloc] initWithIndex:59 name:@"Gangsta"],
            [[MGenre alloc] initWithIndex:60 name:@"Top 40"],
            [[MGenre alloc] initWithIndex:61 name:@"Christian Rap"],
            [[MGenre alloc] initWithIndex:62 name:@"Pop/Funk"],
            [[MGenre alloc] initWithIndex:63 name:@"Jungle"],
            [[MGenre alloc] initWithIndex:64 name:@"Native American"],
            [[MGenre alloc] initWithIndex:65 name:@"Cabaret"],
            [[MGenre alloc] initWithIndex:66 name:@"New Wave"],
            [[MGenre alloc] initWithIndex:67 name:@"Psychedelic"],
            [[MGenre alloc] initWithIndex:68 name:@"Rave"],
            [[MGenre alloc] initWithIndex:69 name:@"Showtunes"],
            [[MGenre alloc] initWithIndex:70 name:@"Trailer"],
            [[MGenre alloc] initWithIndex:71 name:@"Lo-Fi"],
            [[MGenre alloc] initWithIndex:72 name:@"Tribal"],
            [[MGenre alloc] initWithIndex:73 name:@"Acid Punk"],
            [[MGenre alloc] initWithIndex:74 name:@"Acid Jazz"],
            [[MGenre alloc] initWithIndex:75 name:@"Polka"],
            [[MGenre alloc] initWithIndex:76 name:@"Retro"],
            [[MGenre alloc] initWithIndex:77 name:@"Musical"],
            [[MGenre alloc] initWithIndex:78 name:@"Rock & Roll"],
            [[MGenre alloc] initWithIndex:79 name:@"Hard Rock"],
            [[MGenre alloc] initWithIndex:80 name:@"Folk"],
            [[MGenre alloc] initWithIndex:81 name:@"Folk-Rock"],
            [[MGenre alloc] initWithIndex:82 name:@"National Folk"],
            [[MGenre alloc] initWithIndex:83 name:@"Swing"],
            [[MGenre alloc] initWithIndex:84 name:@"Fast Fusion"],
            [[MGenre alloc] initWithIndex:85 name:@"Bebob"],
            [[MGenre alloc] initWithIndex:86 name:@"Latin"],
            [[MGenre alloc] initWithIndex:87 name:@"Revival"],
            [[MGenre alloc] initWithIndex:88 name:@"Celtic"],
            [[MGenre alloc] initWithIndex:89 name:@"Bluegrass"],
            [[MGenre alloc] initWithIndex:90 name:@"Avantgarde"],
            [[MGenre alloc] initWithIndex:91 name:@"Gothic Rock"],
            [[MGenre alloc] initWithIndex:92 name:@"Progressive Rock"],
            [[MGenre alloc] initWithIndex:93 name:@"Psychedelic Rock"],
            [[MGenre alloc] initWithIndex:94 name:@"Symphonic Rock"],
            [[MGenre alloc] initWithIndex:95 name:@"Slow Rock"],
            [[MGenre alloc] initWithIndex:96 name:@"Big Band"],
            [[MGenre alloc] initWithIndex:97 name:@"Chorus"],
            [[MGenre alloc] initWithIndex:98 name:@"Easy Listening"],
            [[MGenre alloc] initWithIndex:99 name:@"Acoustic"],
            [[MGenre alloc] initWithIndex:100 name:@"Humour"],
            [[MGenre alloc] initWithIndex:101 name:@"Speech"],
            [[MGenre alloc] initWithIndex:102 name:@"Chanson"],
            [[MGenre alloc] initWithIndex:103 name:@"Opera"],
            [[MGenre alloc] initWithIndex:104 name:@"Chamber Music"],
            [[MGenre alloc] initWithIndex:105 name:@"Sonata"],
            [[MGenre alloc] initWithIndex:106 name:@"Symphony"],
            [[MGenre alloc] initWithIndex:107 name:@"Booty Bass"],
            [[MGenre alloc] initWithIndex:108 name:@"Primus"],
            [[MGenre alloc] initWithIndex:109 name:@"Porn Groove"],
            [[MGenre alloc] initWithIndex:110 name:@"Satire"],
            [[MGenre alloc] initWithIndex:111 name:@"Slow Jam"],
            [[MGenre alloc] initWithIndex:112 name:@"Club"],
            [[MGenre alloc] initWithIndex:113 name:@"Tango"],
            [[MGenre alloc] initWithIndex:114 name:@"Samba"],
            [[MGenre alloc] initWithIndex:115 name:@"Folklore"],
            [[MGenre alloc] initWithIndex:116 name:@"Ballad"],
            [[MGenre alloc] initWithIndex:117 name:@"Power Ballad"],
            [[MGenre alloc] initWithIndex:118 name:@"Rhythmic Soul"],
            [[MGenre alloc] initWithIndex:119 name:@"Freestyle"],
            [[MGenre alloc] initWithIndex:120 name:@"Duet"],
            [[MGenre alloc] initWithIndex:121 name:@"Punk Rock"],
            [[MGenre alloc] initWithIndex:122 name:@"Drum Solo"],
            [[MGenre alloc] initWithIndex:123 name:@"A Capella"],
            [[MGenre alloc] initWithIndex:124 name:@"Euro-House"],
            [[MGenre alloc] initWithIndex:125 name:@"Dance Hall"]];
    });
    return musicGenres;
}

+ (MGenre *)id3GenreWithName:(NSString *)name {
    for (MGenre *genre in [self musicGenres]) {
        if ([genre.name isEqualToString:name]) {
            return genre;
        }
    }
    return [[MGenre alloc] initWithIndex:255 name:name];
}

+ (MGenre *)id3GenreWithIndex:(NSUInteger)genreIndex {
    for (MGenre *genre in [self musicGenres]) {
        if (genre.index == genreIndex) {
            return genre;
        }
    }
    return [[MGenre alloc] initWithIndex:255 name:@"Custom"];
}

+ (MGenre *)iTunesGenreWithIndex:(NSUInteger)genreIndex {
    return [self id3GenreWithIndex:genreIndex - 1];
}

+ (MGenre *)videoGenreWithName:(NSString *)name {
    for (MGenre *genre in [self videoGenres]) {
        if ([genre.name isEqualToString:name]) {
            return genre;
        }
    }
    return nil;
}

- (instancetype)initWithIndex:(NSUInteger)genreIndex name:(NSString *)name {
    self = [super init];
    if (self) {
        _index = genreIndex;
        _name = [name copy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[MGenre alloc] initWithIndex:_index name:_name];
}

- (NSString *)description {
    return self.name;
}

- (BOOL)isEqual:(id)other {
    if (self == other) {
        return YES;
    }
    if (!other || ![other isMemberOfClass:[self class]]) {
        return NO;
    }
    return self.index == [other index] && [self.name isEqual:[other name]];
}

- (NSUInteger)hash {
    NSUInteger prime = 37;
    NSUInteger hash = 0;
    hash += (_index + 1) * prime;
    hash += [self.name hash] * prime;
    return hash;
}

@end
