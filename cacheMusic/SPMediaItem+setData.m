//
//  SPMediaItem+setData.m
//  cacheMusic
//
//  Created by Anton Minin on 24.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPMediaItem+setData.h"

@implementation SPMediaItem (setData)

- (void) setData:(NSDictionary *)data {
    
    self.artist = [SPData getArtist:data];
    self.audioId = [SPData getAudioId:data];
    self.duration = [SPData getDuration:data];
    self.title = [SPData getTitle:data];
    self.remoteUrl = [SPData getStringURL:data];
}

- (void) setLocalPath:(NSURL *)path {
    
    self.url = [path absoluteString];
    
}

- (void) setSts:(SPMediaItemStatus)status {
    
    self.status = [NSNumber numberWithInteger:status];
}

- (SPMediaItemStatus)getSts {
    
    return [self.status integerValue];
}

- (void)progressWillChange:(NSProgress *)progress {
    
    self.progress = [NSNumber numberWithDouble:progress.fractionCompleted];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    NSNumber *number = [change objectForKey:NSKeyValueChangeNewKey];
    self.progress = number;
    
    //[[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    
    __weak typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SPProgressDidChangeNotification object:weakSelf];
    
    /*
    dispatch_async(dispatch_get_main_queue(), ^{
        //self.progress = number;
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [self setSts:SPMediaItemStatusDownloading];
        }];
    }); */
}

@end
