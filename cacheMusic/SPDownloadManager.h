//
//  SPDownloadManager.h
//  cacheMusic
//
//  Created by Anton Minin on 12.10.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPMediaItem;

@interface SPDownloadManager : NSObject

+ (SPDownloadManager *)sharedManager;

- (void)downloadItem:(SPMediaItem *)mediaItem;

@end
