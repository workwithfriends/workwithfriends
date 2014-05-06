//
//  MyJobsTableView.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"
#import "MyJobFormViewController.h"
#import "RequestToServer.h"
//#import "SwitchViewController.h"
//@class SwitchViewController;

@interface MyJobsTableView : UITableViewController{
    NSMutableDictionary *jobStringList;
    NSInteger sectionLength[5];
    NSInteger *rowSelected;
    NSInteger *sectionSelected;

}
- (NSMutableDictionary *) jobStringList;
- (void) setJobStringList: (NSMutableDictionary *)stringList;
- (NSInteger *) sectionLength;
- (NSInteger *) rowSelected;
- (void) setRowSelected: (NSInteger *)rowNumber;
- (NSInteger *) sectionSelected;
- (void) setSectionSelected: (NSInteger *)sectionNumber;
@end
