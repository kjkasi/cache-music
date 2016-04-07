//
//  SPVkontakteViewController.m
//  cacheMusic
//
//  Created by Anton Minin on 23.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPVkontakteViewController.h"
#import "SPVKManager.h"
#import "SPMediaCell.h"
#import "SPMediaItem.h"

NSString *const kMediaCellIdentifier = @"MediaCellIdentofier";
//NSString *const kSearchFooterIdentifier = @"SearchFooterIdentifier";
//NSString *const kSearchCellIdentifier = @"SearchCellIdentifier";

@interface SPVkontakteViewController ()

@property (nonatomic, strong) NSDictionary *dictAudio;
@property (nonatomic, strong) NSArray *arrayAudio;
@property (nonatomic, strong) NSArray *arrayMediaItems;

@end

@implementation SPVkontakteViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    
    [SPVKManager sharedManager].delegate = self;
    
    [[SPVKManager sharedManager] Autorize:^{
        //
        
        [[SPVKManager sharedManager] getPlaylist:^(NSDictionary *dict) {
            //
            dispatch_async(dispatch_get_main_queue(), ^{
                self.arrayMediaItems = [SPMediaItem MR_findAll];
                [self.tableView reloadData];
            });
            
        }];
        
    } onFailure:^{
        //
    }]; */
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)relogin:(id)sender {
    
    //[VKSdk forceLogout];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.arrayMediaItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //SPMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:kMediaCellIdentifier];
    SPMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:kMediaCellIdentifier forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SPMediaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kMediaCellIdentifier];
    }
    
    SPMediaItem *mediaItem = [self.arrayMediaItems objectAtIndex:indexPath.row];
    
    [cell setData:mediaItem];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 73.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    __weak typeof(self) weakSelf = self;
    
    //NSDictionary *dict = [self.arrayAudio objectAtIndex:indexPath.row];
    
    //[[SPVKManager sharedManager] didSelect:dict];
    //__weak SPMediaCell *weakSelf = (SPMediaCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    //[[SPVKManager sharedManager] didSelectCell:weakSelf data:dict];
    //[[SPVKManager sharedManager] didSelect:[self.arrayMediaItems objectAtIndex:indexPath.row]];
    [[SPVKManager sharedManager] didSelect:[self.arrayMediaItems objectAtIndex:indexPath.row] onSuccess:^{
        [weakSelf.tableView reloadData];
    }];
}


@end
