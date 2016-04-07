//
//  SPDownloadItem.m
//  cacheMusic
//
//  Created by Anton Minin on 12.10.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPDownloadItem.h"
#import "SPMediaItem+setData.h"

@interface SPDownloadItem()

@end

@implementation SPDownloadItem

- (void)setData:(SPMediaItem *)mediaItem {
    
    self.remoteUrl = mediaItem.remoteUrl;
    self.status = [mediaItem getSts];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    
}


@end
