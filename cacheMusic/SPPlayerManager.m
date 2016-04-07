//
//  SPPlayerManager.m
//  cacheMusic
//
//  Created by Anton Minin on 25.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPPlayerManager.h"
#import "SPMediaItem.h"
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

@interface SPPlayerManager() <AVAudioPlayerDelegate>

@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) NSArray *arrayMediaiItems;
@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) float volime;

@end

@implementation SPPlayerManager

+ (SPPlayerManager*) sharedManager {
    
    static SPPlayerManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SPPlayerManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        AVAudioPlayer *player = [[AVAudioPlayer alloc] init];
        //player.delegate = self;
        self.volime = 1.f;
        
        self.player = player;
        
    }
    return self;
}

- (void)playItems:(NSArray *)array atIndex:(NSUInteger)index {
    
    self.arrayMediaiItems = array;
    self.currentIndex = index;
    [self playItemAtIndex:index];
    
}

- (void)playItemAtIndex:(NSUInteger)index {
    
    NSError *errorPlayer = nil;
    NSError *errorSession = nil;
    
    SPMediaItem *mediaItem = [self.arrayMediaiItems objectAtIndex:index];
    
    NSURL *localUrl = [NSURL URLWithString:mediaItem.url];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:localUrl error:&errorPlayer];
    self.player.delegate = self;
    [self.player setVolume:self.volime];
    
    //MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:yourUIImage];
    NSNumber *durationForControlCenter = mediaItem.duration;
    NSDictionary *nowPlaying = @{MPMediaItemPropertyArtist:mediaItem.artist, MPMediaItemPropertyTitle:mediaItem.title};
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:nowPlaying];
    
    
    [[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&errorSession];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self.player prepareToPlay];
    [self.player play];
    
}

- (void)play {
    
    [self.player play];
}

- (void)pause {
    
    [self.player pause];
}

- (void)next {
    [self playNext];
}

- (void)previous {
    
    [self playPrevious];
}

- (void)stop {
    
    if (self.player.isPlaying) {
        [self.player stop];
        self.arrayMediaiItems = [NSArray array];
    }
    
}



#pragma mark - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [self playNext];
}


- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
    
    
}

#pragma mark - Support Method

- (void)playNext {
    
    NSUInteger nextIndex =  (++self.currentIndex % [self.arrayMediaiItems count]);
    
    [self playItemAtIndex:nextIndex];
}

- (void)playPrevious {
    
    NSUInteger previousIndex =  (--self.currentIndex % [self.arrayMediaiItems count]);
    
    //if (previousIndex > 0) {
        [self playItemAtIndex:previousIndex];
    //}
}

@end
