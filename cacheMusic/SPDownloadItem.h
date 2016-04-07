//
//  SPDownloadItem.h
//  cacheMusic
//
//  Created by Anton Minin on 12.10.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SPMediaItem;

@interface SPDownloadItem : NSObject

@property (nonatomic, strong) NSString *remoteUrl;
@property (nonatomic, assign) NSInteger status;

- (void)setData:(SPMediaItem *)mediaItem;

@end
