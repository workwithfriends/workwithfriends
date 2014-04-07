//
//  ProfileViewController.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/5/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

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
- (void) setAboutMe {
    aboutMe=@"I'm Jeremy and I love Work with Friends!";
}
- (void) setMySkills{
    mySkills=[NSArray arrayWithObjects:@"Maths",@"Soccer","blabla", nil];
}
- (void) setProfilePicture{
    NSURL *profileURL = [NSURL URLWithString: @"https://scontent-b.xx.fbcdn.net/hphotos-frc3/l/t31.0-8/1801135_10152417296136042_2112033691_o.jpg"];
    profilePicture= [UIImage imageWithData: [NSData dataWithContentsOfURL: profileURL]];
    NSString *myToken = ACCESSTOKEN;
}
- (void) setFirstName {
    firstName=@"Jeremy";
}
- (void) setLastName {
    lastName=@"Wohlwend";
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setFirstName];
        [self setLastName];
        [self setAboutMe];
        [self setProfilePicture];
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
