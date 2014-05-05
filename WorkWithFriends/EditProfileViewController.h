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
#import "EditMySkillsTableViewController.h"

@interface EditProfileViewController : UIViewController
{
    NSString* firstName;
    NSString* lastName;
    NSString* aboutMe;
    EditMySkillsTableViewController* mySkillsTable;
    UIImage* profilePicture;
}
- (IBAction)addSkill:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *theNewSkill;
@property (strong, nonatomic) IBOutlet UITextField *theNewRate;
- (NSString*) aboutMe;
- (EditMySkillsTableViewController*) mySkillsTable;
- (NSString*) firstName;
- (NSString*) lastName;
- (UIImage*) profilePicture;
- (void) setAboutMe:(NSDictionary*) me;
- (void) setMySkillsTable:(EditMySkillsTableViewController*) other;
- (void) setFirstName:(NSDictionary*) me;
- (void) setLastName:(NSDictionary*) me;
- (void) setProfilePicture:(NSDictionary*) me;
@property (weak, nonatomic) IBOutlet UIImageView *profilePictureLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *aboutMeLabel;
@property (strong, nonatomic) IBOutlet UIView *skillsTable;
- (IBAction)doneEditingLabel:(UIBarButtonItem *)sender;

@end
