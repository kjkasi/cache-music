//
//  SPSearchViewController.m
//  cacheMusic
//
//  Created by Anton Minin on 31.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPSearchViewController.h"
#import "SPSearchCell.h"
#import "SPSearchFooterCell.h"
#import "AFNetworking.h"
#import "SPVKManager.h"
#import "SPMediaItem+setData.h"
#import "SPDownloadManager.h"

NSString *const kSearchFooterIdentifier = @"SearchFooterIdentifier";
NSString *const kSearchCellIdentifier = @"SearchCellIdentifier";

#define kCellHeight     44.f
#define kFooterHeight   44.f

@interface SPSearchViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UILabel *labelWarning;
@property (nonatomic, strong) NSArray *arrayVkontakte;
@property (nonatomic, strong) NSArray *arraySoundCloud;

@end

@implementation SPSearchViewController

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
    
    self.arrayVkontakte = [SPMediaItem MR_findAll];
    
    __weak typeof(self) weakSelf = self;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SPProgressDidChangeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        //
        
        SPMediaItem *object = note.object;
        NSLog(@"%@, progress %@", object.artist, object.progress);
        
        SPSearchCell *cell = [self cellAtItem:object];
        [cell setDownloadProgress:object];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SPVKDidAuthorizeNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        
        [weakSelf.tableView reloadData];
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:SPProgressDidFinishNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        //
        
        SPMediaItem *object = note.object;
        
        SPSearchCell *cell = [self cellAtItem:object];
        [cell downloadDidFinish];
        
    }];

    
    
    /*
    BOOL isReachability = [AFNetworkReachabilityManager sharedManager].isReachable;
    
    [self showReachabilityWarning: isReachability ? YES : NO];
    
     */
    
    
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        
        if (status == AFNetworkReachabilityStatusUnknown || status == AFNetworkReachabilityStatusNotReachable) {
            [weakSelf showReachabilityWarning:YES];
        } else {
            [weakSelf showReachabilityWarning:NO];
        }
        
        AFStringFromNetworkReachabilityStatus(status);
        
    }];
    
    [[SPVKManager sharedManager] getPlaylist:^(BOOL success) {
        if (success) {
            //
            //self.arrayVkontakte = [SPMediaItem MR_findAll];
            [weakSelf.tableView reloadData];
        
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Opss, some error" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayVkontakte count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SPSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchCellIdentifier];
    
    SPMediaItem *mediaItem = [self.arrayVkontakte objectAtIndex:indexPath.row];
    [cell setData:mediaItem];
    
    //SPMediaItem MR_f
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    SPSearchFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchFooterIdentifier];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return kCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return kFooterHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SPMediaItem *mediaItem = [self.arrayVkontakte objectAtIndex:indexPath.row];
    
    SPSearchCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if ([mediaItem getSts] == SPMediaItemStatusNone) {
        //[[SPDownloadManager sharedManager] addItemForDownload:mediaItem];
        //[[SPDownloadManager sharedManager] addItemForDownload:mediaItem];
        [cell setStatus:SPMediaItemStatusDownloading];
        [[SPDownloadManager sharedManager] downloadItem:mediaItem];
    }
    
}

#pragma mark - Reachability

- (void)showReachabilityWarning:(BOOL)show {
    
    self.tableView.hidden = show;
    self.labelWarning.hidden = !show;
    
}

#pragma mark - Support method

- (SPSearchCell *)cellAtItem:(SPMediaItem *)mediaItem {
    
    NSUInteger index = [self.arrayVkontakte indexOfObject:mediaItem];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    SPSearchCell *cell = (SPSearchCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    return cell;
}


@end
