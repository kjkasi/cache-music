//
//  SPAPIManager.h
//  cacheMusic
//
//  Created by Anton Minin on 03.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKSdk.h"
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioSession.h"

@class SPMediaCell;
@class SPMediaItem;

typedef NS_ENUM(NSUInteger, SPCacheMusicType) {
    SPCacheMusicTypeNeedDownload,
    SPCacheMusicTypeCanPlay,
    SPCacheMusicTypeNowPlaying,
};

@interface SPVKManager : NSObject <VKSdkDelegate, AVAudioPlayerDelegate>

+ (SPVKManager *) sharedManager;

@property (nonatomic, weak) id delegate;

- (BOOL)isAuthorized;
//- (void)getPlaylist:(void(^)(NSDictionary *dict))audio;
- (void)getPlaylist:(void(^)(BOOL success))success;
- (void)Autorize:(void(^)(void))onSuccess onFailure:(void(^)(void))onFailure;

//- (void)didSelect:(NSDictionary *)data; DEPRECATED_ATTRIBUTE;
- (void)didSelectCell:(SPMediaCell *)cell data:(NSDictionary *)data;
- (void)didSelect:(SPMediaItem *)mediaItem;
- (void)didSelect:(SPMediaItem *)mediaItem onSuccess:(void(^)(void))onSuccess;

@end
