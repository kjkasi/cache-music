//
//  SPMediaItem+setData.h
//  cacheMusic
//
//  Created by Anton Minin on 24.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPMediaItem.h"

@interface SPMediaItem (setData)

- (void) setData:(NSDictionary *)data;
- (void) setLocalPath:(NSURL *)path;
- (void) setSts:(SPMediaItemStatus)status;

- (SPMediaItemStatus)getSts;

- (void)progressWillChange:(NSProgress *)progress;

@end
