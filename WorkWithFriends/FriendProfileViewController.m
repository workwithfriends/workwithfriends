//
//  FriendProfileViewController.m
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "FriendProfileViewController.h"
#import "GlobalVariables.h"

@interface FriendProfileViewController ()

@end

@implementation FriendProfileViewController




- (NSInteger *) friendID{
    return friendID;
}
- (void) setFriendID: (NSInteger*) theFriendID{
    friendID=theFriendID;
}
- (SwitchViewController*) destinationView{
    return destinationView;
}
-(void) setDestinationView: (SwitchViewController*) theController{
    destinationView=theController;
}

-(void) viewDidAppear:(BOOL)animated{
    NSLog(@"Sending request");
    RequestToServer *viewFriend = [[RequestToServer alloc] init];
    [viewFriend setRequestType:@"viewFriendProfile"];
    NSString *stringID=[NSString stringWithFormat:@"%d",(int)self.friendID];
    NSLog(stringID);
    [viewFriend addParameter:@"friendId" withValue:stringID];
    friend = [viewFriend makeRequest];
    // Do any additional setup after loading the view.
    _friendName.text = [NSString stringWithFormat:@"%@ %@", [friend valueForKey:@"friendFirstName"], [friend valueForKey:@"friendLastName"]];
    NSURL *profileURL = [NSURL URLWithString:[friend valueForKey:@"friendProfileImageUrl"]];
    _friendProfileImage.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: profileURL]];
    _friendDescription.text=[friend valueForKey:@"aboutMe"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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


- (IBAction)backButton:(id)sender {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Saves the tabbarController
    if (self.destinationView==nil){
        //self.destinationView = [segue destinationViewController];
        //[self.destinationView setFriend: friend];
    }
}

- (IBAction)jobsSkillsSwitch:(UISegmentedControl *)sender {
    // Set the good tab index
    //[self.destinationView setSelectedIndex:[sender selectedSegmentIndex]];
}
@end
