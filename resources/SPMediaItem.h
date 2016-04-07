//
//  SPMediaItem.h
//  cacheMusic
//
//  Created by Anton Minin on 14.10.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SPMediaItem : NSManagedObject

@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSNumber * audioId;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * progress;
@property (nonatomic, retain) NSString * remoteUrl;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;

@end
