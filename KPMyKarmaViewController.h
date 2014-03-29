//
//  KPMyKarmaViewController.h
//  KarmaPolice
//
//  Created by Gil Shulman on 3/25/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "TableViewCell.h"


NSArray *questionsArray;

@interface KPMyKarmaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *QuestionTableView;

@end
