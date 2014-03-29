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
    // Display current Karma Points:
    PFUser *currentUser = [PFUser currentUser];
    NSNumber *karmaPoints;
    karmaPoints = currentUser[@"KarmaPoints"];
    NSInteger intKarmaPoints = [karmaPoints integerValue];
    _KarmaPoints.text = [NSString stringWithFormat:@"%d", intKarmaPoints];
    //make the corner of yes button round
    CALayer *btnLayer = [_btnYes layer];
    [btnLayer setMasksToBounds:YES];
    [btnLayer setCornerRadius:45.0f];
    
    CALayer *btnLayer1 = [_btnNo layer];
    [btnLayer1 setMasksToBounds:YES];
    [btnLayer1 setCornerRadius:45.0f];
    
   
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
    [self postAnswerHandler:(BOOL*)YES];
}

- (IBAction)btnNo:(id)sender {
    if(sender == self.btnNo){
        [self postAnswerHandler:NO];
    }
}

- (void) postAnswerHandler: (BOOL *) answer{
    _btnYes.hidden = YES;
    _btnNo.hidden = YES;
    [self saveAnswer:answer];
    [_txtResults setTitle:[self getStat] forState:UIControlStateNormal];
    _txtResults.hidden = NO;
    [self updateKarmaPoints];
}

- (void) showQuestion {
    PFQuery *query = [PFQuery queryWithClassName:@"TblQuestions"];
    
    __block UIImage *askerPhoto;
    __block NSString *userPhotoUrlStr;
    __block NSString *strQuestionText;
    __block NSString *strAskerName;
    __block NSNumber *askAnonymously;
    __block NSNumber *allKP;
    
    
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
                
                askAnonymously = [object objectForKey:@"askAnonymously"];
                allKP = [object objectForKey:@"allKP"];
                
                if(([allKP isEqualToNumber:@0] && [self askerIsFriend]) || ([allKP isEqualToNumber:@1])){
                        QuestionId = object.objectId;
                
                        @try {
                            PFFile *theImage = [object objectForKey:@"imageFile"];
                            NSData *imageData = [theImage getData];
                            UIImage *image = [UIImage imageWithData:imageData];
                            _questionImage.image = image;
                        }
                        @catch (NSException * e) {
                            NSLog(@"Exception: %@", e);
                            //Show a default image here or change background color
                        }
                        @finally {
                            NSLog(@"finally");
                        }
                    
                        PFQuery *uQuery = [PFQuery queryWithClassName:@"_User"];
                        NSString *AskerIdStr = [object objectForKey:@"UserId"];
                        PFObject *userObject = [uQuery getObjectWithId:AskerIdStr];
                    
                            if (!userObject) {
                                NSLog(@"The getFirstObject request failed.");
                            } else {
                                // The find succeeded.
                                NSLog(@"Successfully retrieved the object.");
                                userPhotoUrlStr = [userObject objectForKey:@"UserImageURL"];
                                strAskerName = [userObject objectForKey:@"strUserName"];
                            }
                    
                        NSURL *userPhotoUrl = [NSURL URLWithString:userPhotoUrlStr];
                        askerPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:userPhotoUrl]];

                        _txtQuestion.text = strQuestionText;
                        
                        if([askAnonymously isEqualToNumber:@0]){
                            _imgAskerFBPicture.image = askerPhoto;
                            _lblUserName.text = strAskerName;
                            _imgAskerFBPicture.hidden = NO;
                            _lblUserName.hidden = NO;
                        }else{
                            _imgAskerFBPicture.hidden = YES;
                            _lblUserName.hidden = YES;
                        }
                        blnShowQuestion = false;
                        questionIndex++;
                        // Show the buttons again:
                        _btnYes.hidden = NO;
                        _btnNo.hidden = NO;
                }else{
                    blnShowQuestion = true; //fetch more question that might be fit
                    questionIndex++;
                }
            } //close the while loop
            
        } else {
            _txtQuestion.text = @"no questions at the moment!";
            _btnYes.hidden = YES;
            _btnNo.hidden = YES;
    }}];
}

- (BOOL)askerIsFriend{

    PFUser *user = [PFUser currentUser];
    __block NSString* AskerFacebookId;
    PFQuery *usersQuery= [PFUser query];
    PFObject *userObject = [usersQuery getObjectWithId:AskerUID];
    AskerFacebookId = [userObject objectForKey:@"facebookId"];
    NSArray *friends = [user objectForKey:@"freinds"];
    return[self searchArray:friends forObject:AskerFacebookId];
}


- (BOOL)searchArray:(NSArray *)array forObject:(id)object {
    for (id elem in array) {
        if ([elem[@"id"] isEqualToString:object]){
                return TRUE;
            }
    }
    return FALSE;
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
    
    return [NSString stringWithFormat:@"%@%@\r\r%@", percentageSaidYesforDisplay, @"% Said Yes", @"Click here to see the next question!"];
}

- (void) updateKarmaPoints{
    
    PFUser *currentUser = [PFUser currentUser];
    NSNumber *karmaPoints;
    karmaPoints = currentUser[@"KarmaPoints"];
    NSInteger intKarmaPoints = [karmaPoints integerValue];
    intKarmaPoints++;
    currentUser[@"KarmaPoints"] = [NSNumber numberWithInt:intKarmaPoints];
    [currentUser save];
    _KarmaPoints.text = [NSString stringWithFormat:@"%d", intKarmaPoints];
}

@end
