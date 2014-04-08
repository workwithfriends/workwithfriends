//
//  JobsTableViewController.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/5/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"

@interface JobsTableViewController : UITableViewController
{
    NSArray *jobs;
    NSArray *searchResults;
    NSMutableArray *jobStringList;
    NSInteger *rowSelected;
}
- (NSInteger*) rowSelected;
- (void) setRowSelected:(NSInteger *) row;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;
-(void)refresh;
@end
