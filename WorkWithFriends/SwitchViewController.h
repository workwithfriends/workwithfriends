//
//  SwitchViewController.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyJobsTableView.h"
#import "MySkillsTableView.h"
@class MyJobsTableView;
@class MySkillsTableView;

@interface SwitchViewController : UIViewController
- (IBAction)switchButton:(id)sender;
- (void) performSegueJobs;

@property (strong, nonatomic) IBOutlet MyJobsTableView *jobTable;
@property (strong, nonatomic) IBOutlet MySkillsTableView *skillsTable;

@end

