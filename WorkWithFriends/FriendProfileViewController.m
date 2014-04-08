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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (int *) rowSelected{
    return rowSelected;
}
- (void) setRowSelected: (int*) rowNumber{
    rowSelected=rowNumber;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    friend = [globals.FRIENDS objectAtIndex: self.rowSelected];
    _friendName.text = [NSString stringWithFormat:@"%@ %@", [friend valueForKey:@"friendFirstName"], [friend valueForKey:@"friendLastName"]];
    NSURL *profileURL = [NSURL URLWithString:[friend valueForKey:@"friendProfileImageUrl"]];
    _friendProfileImage.image = [UIImage imageWithData: [NSData dataWithContentsOfURL: profileURL]];
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


@end
