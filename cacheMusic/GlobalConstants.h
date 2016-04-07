//
//  GlobalConstants.h
//  cacheMusic
//
//  Created by Anton Minin on 03.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_ID (@"4489910")

typedef NS_OPTIONS(NSUInteger, SPMediaItemStatus) {
    SPMediaItemStatusNone           = 1 << 0,
    SPMediaItemStatusSave           = 1 << 1,
    SPMediaItemStatusDownloading    = 1 << 2,
    SPMediaItemStatusisInQueue      = 1 << 3,
};

extern NSString *const SPProgressDidChangeNotification;
extern NSString *const SPProgressDidFinishNotification;
extern NSString *const SPVKDidAuthorizeNotification;

#define NSLS(str) NSLocalizedString(str, nil)
#define NSLS(str) NSLocalizedString(str, nil)

@interface GlobalConstants : NSObject

@end

