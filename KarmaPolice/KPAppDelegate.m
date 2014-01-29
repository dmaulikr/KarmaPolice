//
//  KPAppDelegate.m
//  KarmaPolice
//
//  Created by Gil Shulman on 1/13/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import "KPAppDelegate.h"
#import <Parse/Parse.h>

/*
view controllers: (1) KPGetKarmaViewController (2) new query (3) activity (4) invite friends (5) me page (6) settings
 (7) question page -directed from activity page(8) placeholder - while loading page
*/

@implementation KPAppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    // Override point for customization after application launch.
    [Parse setApplicationId:@"Muo904vBZAdFQzXGvgQlMI9u3ZJ0JBTVV456rU3C"
                  clientKey:@"LIUytnzp1ywCJuuK0d31nnys7wPIeMjYHpwUnR24"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    
    // Override point for customization after application launch:
    // Instance LoginViewController with Parse object:
    
    PFLogInViewController *LoginViewController = [PFLogInViewController new];
    LoginViewController.fields = PFLogInFieldsFacebook;
    LoginViewController.title = @"Karma Police";
    [LoginViewController.logInView.facebookButton addTarget:self action:@selector(loginButtonTouchHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:LoginViewController];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (IBAction)loginButtonTouchHandler:(id)sender  {
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"user_about_me", @"user_relationships", @"user_birthday", @"user_location",@"email", @"read_friendlists"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
            [self KPNavigate:@"KPGetKarma"];
        } else {
            NSLog(@"User with facebook logged in!");
            //[self.navigationController pushViewController:[[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
        }
    }];
}

- (void) KPNavigate:(NSString *)viewControllerId
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"KPStoryboard" bundle: nil];
    UITabBarController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"KPGetKarma"];
    
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //[self presentViewController:vc animated:YES completion:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

//GS: Added to support the Single-Sign On feature of the Facebook SDK:

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
