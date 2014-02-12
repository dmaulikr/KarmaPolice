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

@implementation KPGetKarmaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self fetchQuestions];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnYes:(id)sender {
}

- (IBAction)btnNo:(id)sender {
}

- (void) fetchQuestions{
    PFQuery *query = [PFQuery queryWithClassName:@"TblQuestions"];
    //[query whereKey:@"user" equalTo: [PFUser currentUser]];
    __block UIImage *askerPhoto;
    __block NSString *userPhotoUrl;
    __block NSString *strQuestionText;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            // NSLog(@"Successfully retrieved %d scores.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
               // NSLog(@"%@", object.objectId);
                strQuestionText = [object objectForKey:@"Question"];
                    PFQuery *uQuery = [PFQuery queryWithClassName:@"_User"];
                    [uQuery whereKey:@"objectId" equalTo:[object objectForKey:@"objectId"]];
                    [uQuery getFirstObjectInBackgroundWithBlock:^(PFObject *userObject, NSError *error) {
                        if (!object) {
                            NSLog(@"The getFirstObject request failed.");
                        } else {
                            // The find succeeded.
                            NSLog(@"Successfully retrieved the object.");
                            userPhotoUrl = [userObject objectForKey:@"UserImgURL"];
                        }
                    }];
                }
                
                askerPhoto = [UIImage imageWithData:[NSData dataWithContentsOfURL:userPhotoUrl]];
                 _imgAskerFBPicture.image = askerPhoto;
                 _txtQuestion.text = strQuestionText;
            }
         else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

@end
