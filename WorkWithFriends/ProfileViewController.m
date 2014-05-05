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
- (UITabBarController*) destinationView{
    return destinationView;
}
-(void) setDestinationView: (UITabBarController*) theController{
    destinationView=theController;
}
- (void) setAboutMe: (NSDictionary*) me {
    aboutMe=[me valueForKey:@"aboutMe"];
}
- (void) setMySkills: (NSDictionary*) me{
    mySkills=[me valueForKey:@"skills"];
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

- (id)initWithCoder:(NSCoder *)Daecoder
{
    self = [super initWithCoder:Daecoder];
    if (self) {
        GlobalVariables *globals = [GlobalVariables sharedInstance];
        [self setFirstName: globals.ME];
        [self setLastName: globals.ME];
        [self setAboutMe: globals.ME];
        [self setProfilePicture: globals.ME];
        [self setMySkills: globals.ME];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _profilePictureLabel.image = self.profilePicture;
    _firstNameLabel.text = [[self.firstName stringByAppendingString:@" "] stringByAppendingString:self.lastName];
    _aboutMeLabel.text = self.aboutMe;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated{
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    [self setAboutMe: globals.ME];
    _aboutMeLabel.text = self.aboutMe;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Saves the tabbarController
    if (self.destinationView==nil){
        self.destinationView = [segue destinationViewController];
    }
}


- (IBAction)jobsSkillsSwitch:(UISegmentedControl *)sender {
    // Set the good tab index
    [self.destinationView setSelectedIndex:[sender selectedSegmentIndex]];
    }

@end
