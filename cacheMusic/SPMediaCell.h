//
//  SPMediaTableViewCell.h
//  cacheMusic
//
//  Created by Anton Minin on 03.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPMediaItem;

@interface SPMediaCell : UITableViewCell

//- (void)setData:(NSDictionary *)dict;
- (void)setData:(SPMediaItem *)mediaItem;

- (void)setHidden:(BOOL)hidden;
- (void)setComplete;
- (void)setFailure;
- (void)setNeedDownload:(BOOL)download;

@end
