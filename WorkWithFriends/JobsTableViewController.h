//
//  JobsTableViewController.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/5/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobsTableViewController : UITableViewController
{
    NSMutableArray *maListe;
    NSArray *searchResults;
}


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;

@end
