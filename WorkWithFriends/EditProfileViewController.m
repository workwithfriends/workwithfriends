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
- (EditMySkillsTableViewController*) mySkillsTable{
    return mySkillsTable;
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
- (void) setMySkillsTable: (EditMySkillsTableViewController*) other{
    mySkillsTable=other;
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
    _firstNameLabel.text = [[self.firstName stringByAppendingString:@" "] stringByAppendingString:self.lastName];
    _aboutMeLabel.text = self.aboutMe;
    _aboutMeLabel.layer.borderWidth = 0.5f;
    _aboutMeLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _aboutMeLabel.layer.cornerRadius = 8;

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneEditingLabel:(UIBarButtonItem *)sender {
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    RequestToServer *modifyAboutMeRequest = [[RequestToServer alloc] init];
    [modifyAboutMeRequest addParameter:@"aboutMe" withValue:_aboutMeLabel.text];
    [modifyAboutMeRequest setRequestType:@"addAboutMeToAccount"];
    NSDictionary *data = [modifyAboutMeRequest makeRequest];
    
    if ([[data valueForKey:@"aboutMe"] isEqualToString :_aboutMeLabel.text]){
         [globals.ME setValue:_aboutMeLabel.text forKey:@"aboutMe"];
         [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    
    if (self.mySkillsTable !=nil){
        NSMutableArray *newSkillArray=[[NSMutableArray alloc] init];
        for (int i=0; i < [self.mySkillsTable.skillsStringList count];i++){
            NSMutableDictionary *newSkill=[[NSMutableDictionary alloc]init];
            [newSkill setValue:[self.mySkillsTable.skillsStringList objectAtIndex:i] forKey:@"skill"];
            [newSkill setValue:[self.mySkillsTable.skillsStrengthsList objectAtIndex:i] forKey:@"strength"];
            [newSkillArray addObject:newSkill];
        }
        RequestToServer *modifySkills = [[RequestToServer alloc] init];
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newSkillArray
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        [modifySkills addParameter:@"skills" withValue:[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
        [modifySkills setRequestType:@"addSkillsToAccount"];
        NSDictionary *data = [modifySkills makeRequest];
        [globals.ME setValue:[data valueForKey:@"skills"] forKey:@"skills"];
    }

}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"skillsTable"]) {
        
        // Get destination view
        if (self.mySkillsTable ==nil){
            EditMySkillsTableViewController *vc = [segue destinationViewController];
            self.mySkillsTable=vc;
        }
    }
}
- (IBAction)addSkill:(id)sender {
    if([_theNewRate.text intValue] > 10){
        _theNewRate.text=@"10";
    }
    else if ([_theNewRate.text intValue] < 0){
        _theNewRate.text=@"0";
    }
    [self.mySkillsTable.skillsStringList addObject:_theNewSkill.text];
    
    [self.mySkillsTable.skillsStrengthsList addObject:_theNewRate.text];
    _theNewSkill.text=@"";
    _theNewRate.text=@"";
    [self.mySkillsTable.tableView reloadData];
    [_theNewSkill resignFirstResponder];
    [_theNewRate resignFirstResponder];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_theNewSkill resignFirstResponder];
    [_theNewRate resignFirstResponder];
    [_aboutMeLabel resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_theNewSkill resignFirstResponder];
    [_theNewRate resignFirstResponder];
    return YES;
}

@end
