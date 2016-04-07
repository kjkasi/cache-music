//
//  SPMediaTableViewCell.m
//  cacheMusic
//
//  Created by Anton Minin on 03.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPMediaCell.h"
#import "M13ProgressViewPie.h"
#import "SPMediaItem.h"


@interface SPMediaCell()

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelSubTitle;
@property (nonatomic, weak) IBOutlet UIButton *buttonState;
@property (nonatomic, weak) IBOutlet M13ProgressViewPie *progress;
@property (nonatomic, weak) IBOutlet UIImageView *imageStatus;
@property (nonatomic, weak) NSNumber *audioId;

@end

@implementation SPMediaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(SPMediaItem *)mediaItem {
    
    self.labelTitle.text = mediaItem.title;
    self.labelSubTitle.text = mediaItem.artist;
    self.audioId = mediaItem.audioId;
    
    NSInteger status = [mediaItem.status integerValue];
    
    if (status & SPMediaItemStatusNone) {
        //
        [self.imageStatus setImage:[UIImage imageNamed:@"download-25"]];
    } else if (status & SPMediaItemStatusSave) {
        [self.imageStatus setImage:nil];
    } else if (status & SPMediaItemStatusisInQueue) {
        [self.imageStatus setImage:[UIImage imageNamed:@"download-25"]];
    }
    
}

/*
- (void)setData:(NSDictionary *)dict {
    
    self.progress.hidden = YES;
    
    NSString *labelTitle = [dict objectForKey:@"title"];
    
    NSString *labelSubTitle = [dict objectForKey:@"artist"];
    
    self.labelTitle.text = labelTitle;
    self.labelSubTitle.text = labelSubTitle;
    
    self.audioId = [SPData getAudioId:dict];
    
} */

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    
    
    NSNumber *number = [change objectForKey:NSKeyValueChangeNewKey];
    
    if (number > 0) {
        self.progress.hidden = NO;
        [self.progress setProgress:[number floatValue] animated:YES];
    }
    
}

- (void)setComplete {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.progress.hidden = YES;
    });
    
    [self.progress performAction:M13ProgressViewActionSuccess animated:YES];
}

- (void)setFailure {
    
    [self.progress performAction:M13ProgressViewActionFailure animated:YES];
}

- (void)setHidden:(BOOL)hidden {
    
    self.progress.hidden = hidden;
}

- (void)setNeedDownload:(BOOL)download {
    
    [self.imageStatus setHighlighted:!download];
    [self.imageStatus setHidden:!download];
    
    //NSSet
}


@end
