//
//  ProfileViewController.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/5/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchViewController.h"
#import "GlobalVariables.h"


@interface ProfileViewController : UIViewController
{
    NSString* firstName;
    NSString* lastName;
    NSString* aboutMe;
    NSArray* mySkills;
    UIImage* profilePicture;
    UITabBarController* destinationView;
    
}

- (NSString*) aboutMe;
- (NSArray*) mySkills;
- (NSString*) firstName;
- (NSString*) lastName;
- (UIImage*) profilePicture;
- (UITabBarController*) destinationView;
-(void) setDestinationView: (UITabBarController*) theController;
- (void) setAboutMe:(NSDictionary*) me;
- (void) setMySkills:(NSDictionary*) me;
- (void) setFirstName:(NSDictionary*) me;
- (void) setLastName:(NSDictionary*) me;
- (void) setProfilePicture:(NSDictionary*) me;

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureLabel;

@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeLabel;
- (IBAction)jobsSkillsSwitch:(UISegmentedControl *)sender;

@end
