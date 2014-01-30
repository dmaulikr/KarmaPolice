//
//  KPViewController.m
//  KarmaPolice
//
//  Created by Gil Shulman on 1/30/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import "KPViewController.h"
#import <Parse/Parse.h>

@interface KPViewController ()

@end

@implementation KPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        // result is a dictionary with the user's Facebook data
        NSDictionary *userData = (NSDictionary *)result;

        NSString *facebookID = userData[@"id"];
        NSString *name = userData[@"name"];
        NSString *location = userData[@"location"];
        NSString *gender = userData[@"gender"];
        //NSString *birthday = userData[@"birthday"];
        
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
        NSString *AllFBData =[NSString stringWithFormat:@"%@ %@ %@ %@", facebookID,name,location,gender];
        NSLog(AllFBData);
                // Now add the data to the UI elements
        [self loadImage:pictureURL];
    }];
    
    
}

- (void) loadImage:(NSURL *) imageURL{
    NSString *url = [[NSString alloc] initWithFormat:imageURL];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(1*197+170, 1*350+25, 13, 13)];
    [imageView setImage:image];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end