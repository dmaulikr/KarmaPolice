//
//  TableViewCell.m
//  KarmaPolice
//
//  Created by Gil Shulman on 3/25/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

@synthesize timeLabel = _nameLabel;
@synthesize questionLabel = _prepTimeLabel;
@synthesize resultsLabel = _thumbnailImageView;
@synthesize peopleLabel = _peopleLabel;
@synthesize privacySegments = _privacySegments;


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

@end
