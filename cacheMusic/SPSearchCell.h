//
//  SPSearchCell.h
//  cacheMusic
//
//  Created by Anton Minin on 31.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPMediaItem;

@interface SPSearchCell : UITableViewCell

- (void)setData:(SPMediaItem *)mediaItem;
- (void)setStatus:(SPMediaItemStatus)status;
- (void)setDownloadProgress:(SPMediaItem *)mediaItem;
- (void)downloadDidFinish;

@end
