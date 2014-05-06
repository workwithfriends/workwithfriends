//
//  SwitchViewController.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendJobTableViewController.h"



@interface SwitchViewController : UITabBarController
{
    int* segueToChose;
    NSDictionary *friend;
}
//- (int*) segueToChose;
//- (void) setSegueToChose: (int*) theSegue;

-(NSDictionary *) friend;
- (void) setFriend:(NSDictionary *) friend;
@end

