//
//  FriendProfileViewController.h
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwitchViewController.h";

@interface FriendProfileViewController : UIViewController
{
    NSInteger *friendID;
    NSDictionary *friend;
    SwitchViewController  *destinationView;
}
- (IBAction)backButton:(id)sender;
- (NSInteger *) friendID;
- (void) setFriendID: (NSInteger*) theFriendID;
- (SwitchViewController*) destinationView;
-(void) setDestinationView: (SwitchViewController*) theController;
@property (weak, nonatomic) IBOutlet UIImageView *friendProfileImage;
@property (weak, nonatomic) IBOutlet UITextView *friendName;
@property (weak, nonatomic) IBOutlet UITextView *friendDescription;
- (IBAction)jobsSkillsSwitch:(id)sender;

@end
