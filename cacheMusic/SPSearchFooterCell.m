//
//  SPSearchFooterCell.m
//  cacheMusic
//
//  Created by Anton Minin on 31.08.14.
//  Copyright (c) 2014 Anton Minin. All rights reserved.
//

#import "SPSearchFooterCell.h"
#import "SPMediaItem.h"

@interface SPSearchFooterCell()

@property (nonatomic, weak) IBOutlet UILabel *labelFileCount;

@end

@implementation SPSearchFooterCell

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
    
    self.labelFileCount.text = [NSString stringWithFormat:NSLS(@"label-file-count"), [[SPMediaItem MR_findAll] count]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(SPMediaItem *)item {

    self.labelFileCount.text = [NSString stringWithFormat:NSLS(@"label-file-count"), 50];
}

@end
