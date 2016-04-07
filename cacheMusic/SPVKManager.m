//
//  SPAPIManager.m
//  cacheMusic
//
//  Created by Anton Minin on 03.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPVKManager.h"
#import "AFNetworking.h"
#import "SPAppDelegate.h"
#import "SPMediaItem.h"
#import "SPData.h"
#import "SPMediaItem+setData.h"
#import "SPPlayerManager.h"
#import "SPMediaCell.h"

typedef void(^vkAutorizeSuccess)(void);
typedef void(^vkAutorizeFailure)(void);

NSString* const SPVkAutorizeDidFinishNotification = @"SPVkAutorizeDidFinishNotification";

@interface SPVKManager()

@property (nonatomic, strong) AFHTTPRequestOperationManager* requestOperationManager;
@property (nonatomic, strong) VKAccessToken *accessToken;
@property (nonatomic, copy) vkAutorizeSuccess vkAutrorizeSuccesBlock;
@property (nonatomic, copy) vkAutorizeFailure vkAutrorizeFailureBlock;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, strong) dispatch_queue_t queue;

@end

@implementation SPVKManager

+ (SPVKManager*) sharedManager {
    
    static SPVKManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[SPVKManager alloc] init];
    });
    
    return manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        dispatch_queue_t queue = dispatch_queue_create("com.cachemusic.download.queue", DISPATCH_QUEUE_SERIAL);
        self.queue = queue;
        
        AVAudioPlayer *player = [[AVAudioPlayer alloc] init];
        //player.delegate = self;
        
        self.player = player;
        
        NSURL* url = [NSURL URLWithString:@"https://api.vk.com/method/"];
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
        
        __weak typeof(self) weakSelf = self;
        [VKSdk initializeWithDelegate:weakSelf andAppId:APP_ID];
        if ([VKSdk wakeUpSession])
        {
            //Start working
        }
        
    }
    return self;
}

- (BOOL)isAuthorized
{
    VKAccessToken *token = [VKSdk getAccessToken];
    return token.accessToken ? YES: NO;
}

#pragma mark - VKSdkDelegate

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    
    
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    
}

- (void)vkSdkUserDeniedAccess:(VKError *)authorizationError {
    
    self.vkAutrorizeFailureBlock();
    
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    
    //[self.delegate presentViewController:controller animated:YES completion:nil];
    
    [[self topViewController] presentViewController:controller animated:YES completion:nil];
}

- (void)vkSdkReceivedNewToken:(VKAccessToken *)newToken {
    
    NSLog(@"VK Autorize with Token: %@", newToken.accessToken);
    //self.vkAutrorizeSuccesBlock();
    //[VKSdk setAccessToken:newToken];
    
    [self getPlaylist:^(BOOL success) {
        
        if (success) {
            [[NSNotificationCenter defaultCenter] postNotificationName:SPVKDidAuthorizeNotification object:nil userInfo:nil];
        }
        
    }];
}

#pragma mark - Utility functions for UI

- (UIViewController *)topViewController
{
    
	return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewController:(UIViewController *)rootViewController
{
	if (rootViewController.presentedViewController == nil) {
		return rootViewController;
	}
	
	if ([rootViewController.presentedViewController isMemberOfClass:[UINavigationController class]]) {
		UINavigationController *navigationController = (UINavigationController *)rootViewController.presentedViewController;
		UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
		return [self topViewController:lastViewController];
	}
	
	UIViewController *presentedViewController = (UIViewController *)rootViewController.presentedViewController;
	return [self topViewController:presentedViewController];
}

- (void)getPlaylist:(void(^)(BOOL success))success {
    
    if ([self isAuthorized]) {
        VKAccessToken *accessToken = [VKSdk getAccessToken];
        
        NSDictionary *param = @{@"owner_id": accessToken.userId};
        
        VKRequest *audioReq = [VKApi requestWithMethod:@"audio.get" andParameters:param andHttpMethod:@"GET"];
        
        [audioReq executeWithResultBlock:^(VKResponse *response) {
            
            NSArray *array = [response.json objectForKey:@"items"];
            
            for (NSDictionary *dict in array) {
                
                NSNumber *albumId = [SPData getAudioId:dict];
                
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"audioId == %@", albumId];
                
                [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                    SPMediaItem *mediaItem = [SPMediaItem MR_findFirstWithPredicate:predicate inContext:localContext];
                    
                    if (!mediaItem) {
                        mediaItem = [SPMediaItem MR_createInContext:localContext];
                        [mediaItem setSts:SPMediaItemStatusNone];
                    }
                    [mediaItem setData:dict];
                }];
                
            }
            
            success(YES);
            
        } errorBlock:^(NSError *error) {
            NSLog(@"Error: %@", error);
            success(NO);
        }];
    }
}

- (void)Autorize:(void(^)(void))onSuccess onFailure:(void(^)(void))onFailure {
    
    self.vkAutrorizeSuccesBlock = ^(void) {
        onSuccess();
    };
    
    self.vkAutrorizeFailureBlock = ^(void) {
        onFailure();
    };
    
    if (![self isAuthorized]) {
        
    } else {
        self.vkAutrorizeSuccesBlock();
    }
    
}

#pragma mark - Support Method

- (NSArray *)getDataFromResponse:(VKResponse *)response {
    
    return [response.json objectForKey:@"items"];
}

- (NSInteger)getAudioIdFrom:(NSDictionary *)dict {
    
    return [[dict objectForKey:@"id"] integerValue];
}

- (void)didSelectCell:(SPMediaCell *)cell data:(NSDictionary *)data {
    
    NSNumber *number = [SPData getAudioId:data];
    
    NSString *title = [SPData getTitle:data];
    
    NSString *artist = [SPData getArtist:data];
    
    NSString *fileName = [NSString stringWithFormat:@"%@-%@.mp3", title, artist];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"audioId == %@", number];
    
    //SPMediaItem *mediaItem = [SPMediaItem MR_findFirstByAttribute:@"auidioId" withValue:@(audioId];
    
    //NSArray *array = [SPMediaItem MR_findAll];
    
    NSArray *allItems = [SPMediaItem MR_findAll];
    
    NSArray *mediaItems = [SPMediaItem MR_findAllWithPredicate:predicate];
    
    if ([mediaItems count]) {
        
        SPMediaItem *mediaItem = [mediaItems objectAtIndex:0];
        
        NSUInteger index = [allItems indexOfObject:mediaItem];
        
        NSURL *localUrl = [NSURL URLWithString:mediaItem.url];
        
        [[SPPlayerManager sharedManager] playItems:allItems atIndex:index];
        
    } else {
        
        dispatch_sync(self.queue, ^{
            
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSProgress *progress = nil;//[NSProgress currentProgress];
            
            NSURLRequest *request = [NSURLRequest requestWithURL:[SPData getUrl:data]];
            
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"File downloaded to: %@", filePath);
                
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    SPMediaItem *mediaItem = [SPMediaItem MR_createInContext:localContext];
                    [mediaItem setData:data];
                    [mediaItem setLocalPath:filePath];
                } completion:^(BOOL success, NSError *error) {
                    if (success) {
                        [cell setComplete];
                    } else {
                        [cell setFailure];
                    }
                }];
            }];
            
            [downloadTask resume];
            
            [progress addObserver:cell forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        });
        
    }
}

- (void)didSelect:(SPMediaItem *)mediaItem {
    
    if (mediaItem.url) {
        
        NSArray *allItems = [SPMediaItem MR_findAll];
        NSUInteger index = [allItems indexOfObject:mediaItem];
        [[SPPlayerManager sharedManager] playItems:allItems atIndex:index];
        
    } else {
        
        dispatch_sync(self.queue, ^{
            
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

                [mediaItem setLocalPath:filePath];
                [mediaItem setSts:SPMediaItemStatusSave];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }];
            
            [downloadTask resume];
            
        });
    }
    
}

- (void)didSelect:(SPMediaItem *)mediaItem onSuccess:(void(^)(void))onSuccess {
    
    if (mediaItem.url) {
        
        NSArray *allItems = [SPMediaItem MR_findAll];
        NSUInteger index = [allItems indexOfObject:mediaItem];
        [[SPPlayerManager sharedManager] playItems:allItems atIndex:index];
        
    } else {
        
        dispatch_sync(self.queue, ^{
            
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
                
                [mediaItem setLocalPath:filePath];
                [mediaItem setSts:SPMediaItemStatusSave];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
                
                onSuccess();
            }];
            
            [downloadTask resume];
            
        });
    }
}


@end
