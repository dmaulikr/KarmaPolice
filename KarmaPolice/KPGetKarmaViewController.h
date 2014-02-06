//
//  KPFirstViewController.h
//  KarmaPolice
//
//  Created by Gil Shulman on 1/13/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPGetKarmaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgAskerFBPicture;
@property (weak, nonatomic) IBOutlet UILabel *txtQuestion;
@property (weak, nonatomic) IBOutlet UIButton *btnYes;
@property (weak, nonatomic) IBOutlet UIButton *btnNo;
- (void) fetchQuestions;

@end
