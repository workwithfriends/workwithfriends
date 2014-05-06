//
//  SwitchViewController.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "SwitchViewController.h"

@interface SwitchViewController ()

@end

@implementation SwitchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tabBar.hidden=YES;
    if (self.friend !=nil){
        for(UITableViewController *table in self.viewControllers){
            if ([[[table class] description] isEqualToString:@"FriendJobTableViewController"]){
                [(FriendJobTableViewController*)table setFriend:self.friend];
            }
            else{
                [(FriendJobTableViewController*)table setFriend:self.friend];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSegueToChose: (int *) theSegue
{
    self.selectedIndex=(NSUInteger) theSegue;
}
-(NSDictionary *) friend{
    return friend;
}
- (void) setFriend:(NSDictionary *) theFriend{
    friend=theFriend;
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
