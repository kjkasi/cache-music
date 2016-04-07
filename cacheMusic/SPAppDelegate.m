//
//  SPAppDelegate.m
//  cacheMusic
//
//  Created by Anton Minin on 03.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPAppDelegate.h"
#import "SPVKManager.h"
#import "VKSdk.h"
#import "SPPlayerManager.h"
#import "SPMediaItem.h"
#import "AFNetworking.h"

@implementation SPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [MagicalRecord setupAutoMigratingCoreDataStack];
    [SPVKManager sharedManager];
    
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"main" bundle:nil];
    //UIViewController *vc = [mainStoryboard instantiateInitialViewController];
    //self.window.rootViewController = vc;
    //[self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    NSArray* temp = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:NSTemporaryDirectory() error:NULL];
    for (NSString *file in temp) {
        [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@%@", NSTemporaryDirectory(), file] error:NULL];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    /*
    if (![SPAPIManager sharedManager].isAuthorized) {
        [VKSdk authorize:@[VK_PER_AUDIO]];
    }*/
    
    //[SPMediaItem MR_truncateAll];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    VKAccessToken *accessToken = [VKSdk getAccessToken];
    
    if (!accessToken) {
    
        [VKSdk authorize:@[VK_PER_AUDIO]];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

#pragma mark - VKSdk

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    return YES;
}

- (void)presendViewController:(UIViewController*)controller {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
    
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //if it is a remote control event handle it correctly
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlPlay) {
            NSLog(@"UIEventSubtypeRemoteControlPlay");
            [[SPPlayerManager sharedManager] play];
        } else if (event.subtype == UIEventSubtypeRemoteControlPause) {
            NSLog(@"UIEventSubtypeRemoteControlPause");
            [[SPPlayerManager sharedManager] pause];
        } else if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            //NSLog(@"UIEventSubtypeRemoteControlTogglePlayPause");
        } else if (event.subtype == UIEventSubtypeRemoteControlNextTrack) {
            [[SPPlayerManager sharedManager] next];
        } else if (event.subtype == UIEventSubtypeRemoteControlPreviousTrack) {
            [[SPPlayerManager sharedManager] previous];
        }
    }
}



@end
