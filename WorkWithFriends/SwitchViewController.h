//
//  SwitchViewController.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyJobsTableView.h"


@interface SwitchViewController : UITabBarController
{
    int* segueToChose;
}
- (int*) segueToChose;
- (void) setSegueToChose: (int*) theSegue;

@end

