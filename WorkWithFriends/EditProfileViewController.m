//
//  EditProfileViewController.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController

- (NSString*) aboutMe{
    return aboutMe;
}
- (NSArray*) mySkills{
    return mySkills;
}
- (NSString*) firstName{
    return firstName;
}
- (NSString*) lastName{
    return lastName;
}
- (UIImage*) profilePicture{
    return profilePicture;
}
- (void) setAboutMe: (NSDictionary*) me {
    aboutMe=[me valueForKey:@"aboutMe"];
}
- (void) setMySkills: (NSDictionary*) me{
    mySkills=[NSArray arrayWithObjects:@"Maths",@"Soccer","blabla", nil];
}
- (void) setProfilePicture: (NSDictionary*) me{
    NSURL *profileURL = [NSURL URLWithString:[me valueForKey:@"profileImageUrl"]];
    profilePicture= [UIImage imageWithData: [NSData dataWithContentsOfURL: profileURL]];
}
- (void) setFirstName:(NSDictionary*) me{
    firstName=[me valueForKey:@"firstName"];
}
- (void) setLastName:(NSDictionary*) me {
    lastName=[me valueForKey:@"lastName"];;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        GlobalVariables *globals = [GlobalVariables sharedInstance];
        [self setFirstName: globals.ME];
        [self setLastName: globals.ME];
        [self setAboutMe: globals.ME];
        [self setProfilePicture: globals.ME];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _profilePictureLabel.image = self.profilePicture;
    _firstNameLabel.text = self.firstName;
    _lastNameLabel.text = self.lastName;
    _aboutMeLabel.text = self.aboutMe;
    _aboutMeLabel.layer.borderWidth = 2.0f;
    _aboutMeLabel.layer.borderColor = [[UIColor grayColor] CGColor];
    _aboutMeLabel.layer.cornerRadius = 8;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneEditingLabel:(UIBarButtonItem *)sender {
    RequestToServer *modifyAboutMeRequest = [[RequestToServer alloc] init];
    [modifyAboutMeRequest setRequestType:@"modifyAboutMeRequest"];
    [modifyAboutMeRequest addParameter:@"aboutMe":_aboutMeLabel.text];
    NSDictionary *data = [modifyAboutMeRequest makeRequest];
    if ([[data valueForKey:@"aboutMe"] isEqualToString:_aboutMeLabel.text]){
       [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }

}
@end
