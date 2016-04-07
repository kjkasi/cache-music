//
//  SPDownloadManager.m
//  cacheMusic
//
//  Created by Anton Minin on 12.10.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPDownloadManager.h"
#import "AFNetworking/AFNetworking.h"
#import "SPMediaItem+setData.h"
#import "SPDownloadItem.h"

NSString *const kQueueChangeIdentifier = @"QueueChangeIdentifier";
NSString *const kProgressKeyPath = @"fractionCompleted";

@interface SPDownloadManager()

@property (nonatomic, strong) NSMutableArray *arrayDownloadQueue;

@end

@implementation SPDownloadManager

+ (SPDownloadManager *)sharedManager {
    
    static SPDownloadManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SPDownloadManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        // init
        self.arrayDownloadQueue = [NSMutableArray array];
        
        //[self.arrayDownloadQueue addObserver:self forKeyPath:kQueueChangeIdentifier options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)downloadItem:(SPMediaItem *)mediaItem {
    
    SPDownloadItem *downloadItem = [SPDownloadItem new];
    
    [downloadItem setData:mediaItem];
    
    [self.arrayDownloadQueue addObject:mediaItem];
    
    __weak typeof(self) weakSelf = self;

    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSProgress *progress = nil;//[NSProgress currentProgress];
    
    NSURL *url = [NSURL URLWithString:mediaItem.remoteUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [mediaItem setLocalPath:filePath];
            [mediaItem setSts:SPMediaItemStatusSave];
            [weakSelf.arrayDownloadQueue removeObject:mediaItem];
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SPProgressDidFinishNotification object:mediaItem];
    }];
    
    [downloadTask resume];
    
    [progress addObserver:mediaItem forKeyPath:kProgressKeyPath options:NSKeyValueObservingOptionNew context:NULL];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [mediaItem setSts:SPMediaItemStatusDownloading];
    }];
    
}

- (void)addItemForDownload:(SPMediaItem *)mediaItem {
    
    [self.arrayDownloadQueue addObject:mediaItem];
    //[self queueUpdate];
}


@end
