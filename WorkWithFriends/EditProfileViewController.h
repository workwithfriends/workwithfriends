//
//  EditProfileViewController.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"
#import "RequestToServer.h"

@interface EditProfileViewController : UIViewController
{
    NSString* firstName;
    NSString* lastName;
    NSString* aboutMe;
    NSArray* mySkills;
    UIImage* profilePicture;
}

- (NSString*) aboutMe;
- (NSArray*) mySkills;
- (NSString*) firstName;
- (NSString*) lastName;
- (UIImage*) profilePicture;
- (void) setAboutMe:(NSDictionary*) me;
- (void) setMySkills:(NSDictionary*) me;
- (void) setFirstName:(NSDictionary*) me;
- (void) setLastName:(NSDictionary*) me;
- (void) setProfilePicture:(NSDictionary*) me;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeLabel;
- (IBAction)doneEditingLabel:(UIBarButtonItem *)sender;

@end
