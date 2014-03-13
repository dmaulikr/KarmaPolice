//
//  KPGetKarmaViewController.m
//  KarmaPolice
//
//  Created by Gil Shulman on 1/13/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import "KPGetKarmaViewController.h"
#import <Parse/Parse.h>



@interface KPGetKarmaViewController ()

@end

int questionIndex;
bool blnShowQuestion;
NSString* AskerUID;
NSString* QuestionId;

@implementation KPGetKarmaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _txtResults.hidden = YES;
    blnShowQuestion = true;
    questionIndex = 0;
    [self showQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)txtResults:(id)sender {
    _txtResults.hidden = YES;
    blnShowQuestion = true;
    [self showQuestion];
}

- (IBAction)btnYes:(id)sender {
    [self postAnswerHandler:YES];
}


- (IBAction)btnNo:(id)sender {
    [self postAnswerHandler:NO];
}

- (void) postAnswerHandler: (BOOL *) answer{
    _btnYes.hidden = YES;
    _btnNo.hidden = YES;
    [self saveAnswer:answer];
    [_txtResults setTitle:[self getStat] forState:UIControlStateNormal];
    _txtResults.hidden = NO;
 
}

- (void) showQuestion {
    PFQuery *query = [PFQuery queryWithClassName:@"TblQuestions"];
    
    __block UIImage *askerPhoto;
    __block NSString *userPhotoUrlStr;
    __block NSString *strQuestionText;
    
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"UserId" notEqualTo:user.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error && objects.count > questionIndex) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            while (blnShowQuestion && objects.count > questionIndex){
                PFObject *object = objects[questionIndex];
               // NSLog(@"%@", object.objectId);
                strQuestionText = [object objectForKey:@"Question"];
                AskerUID = [object objectForKey:@"UserId"];
                QuestionId = object.objectId;
                    PFQuery *uQuery = [PFQuery queryWithClassName:@"_User"];
                    NSString *AskerIdStr = [object objectForKey:@"UserId"];
                    PFObject *userObject = [uQuery getObjectWithId:AskerIdStr];
                
                        if (!userObject) {
                            NSLog(@"The getFirstObject request failed.");
                        } else {
                            // The find succeeded.
                            NSLog(@"Successfully retrieved the object.");
                            userPhotoUrlStr = [userObject objectForKey:@"UserImageURL"];
                        }
                
            NSURL *userPhotoUrl = [NSURL URLWithString:userPhotoUrlStr];
            askerPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:userPhotoUrl]];
            _imgAskerFBPicture.image = askerPhoto;
            _txtQuestion.text = strQuestionText;
            blnShowQuestion = false;
            questionIndex++;
            // Show the buttons again:
            _btnYes.hidden = NO;
            _btnNo.hidden = NO;
            }
        } else {
            // Log details of the failure
            //NSLog(@"Error: %@ %@", error, [error userInfo]);
            _txtQuestion.text = @"Great! No more questions for now!";
            _btnYes.hidden = YES;
            _btnNo.hidden = YES;

        }}];
}

- (void) saveAnswer:(BOOL *) answer{
    PFObject *newAnswer = [PFObject objectWithClassName:@"TblAnswers"];
    newAnswer[@"Answer"] = [NSNumber numberWithBool:answer];
    PFUser *user = [PFUser currentUser];
    newAnswer[@"UserId"] = user.objectId;
    newAnswer[@"AskerUID"] = AskerUID;
    newAnswer[@"QuestionId"] = QuestionId;
    [newAnswer saveInBackground];
}

- (NSString *) getStat{
    
    __block int totalNumberofAnswers;
    __block int totalNumberofYes;
    
    PFQuery *query = [PFQuery queryWithClassName:@"TblAnswers"];
    [query whereKey:@"QuestionId" equalTo:QuestionId];
    totalNumberofAnswers = query.countObjects;
    
    [query whereKey:@"Answer" equalTo:[NSNumber numberWithBool:YES]];
    totalNumberofYes =  query.countObjects;
    
    NSInteger percentageSaidYes;
    percentageSaidYes = (int)((float)totalNumberofYes/(float)totalNumberofAnswers*100);
    NSNumber *percentageSaidYesforDisplay = [[NSNumber alloc] initWithInt:percentageSaidYes];
    
    return [NSString stringWithFormat:@"%@/%@/%@", percentageSaidYesforDisplay, @"% Said Yes  ", @"Click here to move to the next question"];
}

@end
