//
//  MyJobsTableView.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"
#import "JobFormViewController.h"
//#import "SwitchViewController.h"
//@class SwitchViewController;

@interface MyJobsTableView : UITableViewController{
    NSMutableArray *jobStringList;
    NSInteger *rowSelected;
    //SwitchViewController *tableHolder;
}
- (NSMutableArray *) jobStringList;
- (void) setJobStringList: (NSMutableArray *)stringList;
- (NSInteger *) rowSelected;
- (void) setRowSelected: (NSInteger *)rowNumber;
//- (SwitchViewController *) tableHolder;
//- (void) setTableHolder: (SwitchViewController *)holder;
@end
