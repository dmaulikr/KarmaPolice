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

    blnShowQuestion = true;
    questionIndex = 0;
    [self showQuestion];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnYes:(id)sender {
    [self saveAnswer:YES];
    
    //TODO - Show answers results
    _lblResults = @"TEST TEST";
    
    blnShowQuestion = true;
    [self showQuestion];
}


- (IBAction)btnNo:(id)sender {
    [self saveAnswer:NO];
    blnShowQuestion = true;
    [self showQuestion];
}

// GS: TODO

// Fetch All Relevant Questions to display into an array
// Display the first question
// Write the answer
// Move to the next one
// Check that there are questions left


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


@end
