//
//  SPPlayerManager.h
//  cacheMusic
//
//  Created by Anton Minin on 25.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVFoundation/AVAudioPlayer.h"
#import "AVFoundation/AVAudioSession.h"

@interface SPPlayerManager : NSObject

+ (SPPlayerManager*) sharedManager;

- (void)playItems:(NSArray *)array atIndex:(NSUInteger)index;

- (void)play;
- (void)pause;
- (void)next;
- (void)previous;
- (void)stop;

@end
