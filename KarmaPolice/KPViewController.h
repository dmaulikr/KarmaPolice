//
//  KPViewController.h
//  KarmaPolice
//
//  Created by Gil Shulman on 1/30/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#include <stdlib.h>


//@interface KPViewController : UIViewController


@interface KPViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate>
{
    // IBOutlet UIScrollView *photoScrollView;
    // NSMutableArray *allImages;
    
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
}


 
- (IBAction)refresh:(id)sender;
- (IBAction)cameraButtonTapped:(id)sender;
- (void)uploadImage:(NSData *)imageData;

- (void)uploadImage:(NSData *)imageData; // :(NSString *) questionId;

- (void)buttonTouched:(id)sender;

extern NSData* questionImageData;


@property (strong, nonatomic) IBOutlet UIView *GetKarmaViewController;

@property (weak, nonatomic) IBOutlet UIImageView *KPAskerFBPhoto;

- (void) loadImage:(UIImage *) imageURL;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmitQuestion;
- (void) fetchQuestions:(id *) userID;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

@property (weak, nonatomic) IBOutlet UITextView *txtQuestionField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *btnAnonymously;
@property (weak, nonatomic) IBOutlet UISegmentedControl *btnShowQuestionTo;


- (void)hudWasHidden:(MBProgressHUD *)hud;

//@property (nonatomic, retain) IBOutlet UIImageView *imageToDisplay;








@end






