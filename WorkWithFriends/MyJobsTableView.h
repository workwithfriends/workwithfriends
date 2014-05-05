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
    NSArray *jobStringList;
    NSInteger sectionLength[4];
    NSInteger *rowSelected;

}
- (NSArray *) jobStringList;
- (void) setJobStringList: (NSArray *)stringList;
- (NSInteger *) sectionLength;
- (NSInteger *) rowSelected;
- (void) setRowSelected: (NSInteger *)rowNumber;
@end
