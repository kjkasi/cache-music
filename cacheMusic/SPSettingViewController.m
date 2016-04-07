//
//  SPSettingViewController.m
//  cacheMusic
//
//  Created by Anton Minin on 26.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPSettingViewController.h"
#import "SPMediaItem.h"
#import "SPPlayerManager.h"
#import "MBProgressHUD.h"
#import "VKSdk.h"

@interface SPSettingViewController ()

@property (nonatomic, weak) IBOutlet UISwitch *swithClear;
@property (nonatomic, weak) IBOutlet UISwitch *swithLogout;

@end

@implementation SPSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)actionClearCache:(id)sender {
    
    //[[SPPlayerManager sharedManager] stop];
    
    NSArray *mediaItems = [SPMediaItem MR_findAll];
    
    if (mediaItems) {
        for (SPMediaItem *mediaItem in mediaItems) {
            
            NSError *error = nil;
            //
            [[NSFileManager defaultManager] removeItemAtURL:[NSURL URLWithString:mediaItem.url]  error:&error];
            
            if (error) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            } else {
                [mediaItem MR_deleteEntity];
                [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            }
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Complite" message:@"Data cache is cleared" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertView show];
        
        
        
        //[SPMediaItem MR_truncateAll];
    }
}

- (IBAction)actionForceLogout:(id)sender {
    
    [VKSdk forceLogout];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self.swithClear setOn:NO animated:YES];
}

@end
