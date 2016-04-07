//
//  SPData.h
//  cacheMusic
//
//  Created by Anton Minin on 24.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPData : NSObject

+ (NSNumber *)getAudioId:(NSDictionary *)data;
+ (double)getOwnerId:(NSDictionary *)data;
+ (NSString *)getArtist:(NSDictionary *)data;
+ (NSString *)getTitle:(NSDictionary *)data;
+ (NSNumber *)getDuration:(NSDictionary *)data;
+ (NSURL *)getUrl:(NSDictionary *)data;
+ (NSString *)getStringURL:(NSDictionary *)data;
+ (double)getLyricsId:(NSDictionary *)data;
+ (double)getAlbumId:(NSDictionary *)data;
+ (double)getGenreId:(NSDictionary *)data;


@end
