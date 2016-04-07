//
//  SPSearchCell.m
//  cacheMusic
//
//  Created by Anton Minin on 31.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPSearchCell.h"
#import "M13ProgressViewRing.h"
#import "SPMediaItem+setData.h"

@interface SPSearchCell()

@property (nonatomic, weak) IBOutlet UILabel *labelArtist;
@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet M13ProgressViewRing *progress;

@end

@implementation SPSearchCell

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
    self.progress.indeterminate = YES;
    self.progress.showPercentage = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(SPMediaItem *)mediaItem {
    
    self.labelArtist.text = mediaItem.artist;
    self.labelTitle.text = mediaItem.title;
    
    [self setStatus:[mediaItem getSts]];
    
    //[self.progress setProgress:[mediaItem.progress floatValue] animated:YES];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    //self.progress.hidden = YES;
    //self.progress
}

- (void)setStatus:(SPMediaItemStatus)status {
    
    if (status == SPMediaItemStatusNone) {
        self.progress.hidden = YES;
        self.progress.indeterminate = YES;
        self.progress.showPercentage = NO;
    }
    
    if (status == SPMediaItemStatusSave) {
        self.progress.hidden = YES;
    }
    
    if (status == SPMediaItemStatusDownloading) {
        self.progress.hidden = NO;
        self.progress.indeterminate = NO;
        self.progress.showPercentage = YES;
        
    }
    
}

- (void)setDownloadProgress:(SPMediaItem *)mediaItem {
    
    [self.progress setProgress:[mediaItem.progress floatValue] animated:YES];
}

- (void)downloadDidFinish {
    
    [self.progress performAction:M13ProgressViewActionSuccess animated:YES];
}

@end
