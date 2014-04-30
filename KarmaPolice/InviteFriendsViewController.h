//
//  InviteFriendsViewController.h
//  KarmaPolice
//
//  Created by Gil Shulman on 4/29/14.
//  Copyright (c) 2014 Karma Police. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AddressBookUI/AddressBookUI.h>

@interface InviteFriendsViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate>
    extern NSString* phoneNumber;
@end
