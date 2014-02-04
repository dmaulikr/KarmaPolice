//
//  KPViewController.h
//  KarmaPolice
//
//  Created by Gil Shulman on 1/30/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KPViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *GetKarmaViewController;

@property (weak, nonatomic) IBOutlet UIImageView *KPAskerFBPhoto;

- (void) loadImage:(UIImage *) imageURL;

@property (weak, nonatomic) IBOutlet UITextField *txtQuestionField;

@property (weak, nonatomic) IBOutlet UIButton *btnSubmitQuestion;
- (void) fetchQuestions:(id *) userID;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

//@property (nonatomic, retain) IBOutlet UIImageView *imageToDisplay;



@end






