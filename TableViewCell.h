//
//  TableViewCell.h
//  KarmaPolice
//
//  Created by Gil Shulman on 3/25/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *questionLabel;
@property (nonatomic, weak) IBOutlet UILabel *resultsLabel;
@property (nonatomic, weak) IBOutlet UILabel *peopleLabel;

@property (nonatomic, weak) IBOutlet UISegmentedControl *privacySegments;

@end
