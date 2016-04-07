//
//  SPData.m
//  cacheMusic
//
//  Created by Anton Minin on 24.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPData.h"

@implementation SPData

+ (NSNumber *)getAudioId:(NSDictionary *)data {
    
    double audioId = [[data objectForKey:@"id"] doubleValue];
    
    return [NSNumber numberWithDouble:audioId];
}

+ (double)getOwnerId:(NSDictionary *)data {
    
    return [[data objectForKey:@"owner_id"] doubleValue];
}


+ (NSString *)getArtist:(NSDictionary *)data {
    
    NSString *artist =  [data objectForKey:@"artist"];
    
    return (artist) ? artist : @"nil";
}

+ (NSString *)getTitle:(NSDictionary *)data {
    
    NSString *title = [data objectForKey:@"title"];
    
    return (title) ? title : @"nil";
}

+ (NSNumber *)getDuration:(NSDictionary *)data; {
    
    double duration = [[data objectForKey:@"duration"] doubleValue];
    
    return [NSNumber numberWithDouble:duration];
}

+ (NSURL *)getUrl:(NSDictionary *)data {
    
    return [NSURL URLWithString:[data objectForKey:@"url"]];
}

+ (NSString *)getStringURL:(NSDictionary *)data {
    
     return [data objectForKey:@"url"];
}

+ (double)getLyricsId:(NSDictionary *)data {
    
    return [[data objectForKey:@"lyrics_id"] doubleValue];
}

+ (double)getAlbumId:(NSDictionary *)data {
    
    return [[data objectForKey:@"album_id"] doubleValue];
}

+ (double)getGenreId:(NSDictionary *)data {
    
    return [[data objectForKey:@"genre_id"] doubleValue];
}

@end
