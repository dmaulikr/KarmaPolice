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

@property (weak, nonatomic) IBOutlet UIButton *txtResults;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *KarmaPoints;
@property (weak, nonatomic) IBOutlet UIImageView *questionImage;


extern int questionIndex;
extern bool blnShowQuestion;
extern NSString* AskerUID;
extern NSString* QuestionId;


- (void) showQuestion;

- (void) saveAnswer:(BOOL *) answer;

- (NSString *) getStat;

- (void) postAnswerHandler: (BOOL *) answer;

- (void) updateKarmaPoints;

- (BOOL)searchArray:(NSArray *)array forObject:(id)object;

- (BOOL)askerIsFriend;


@end
