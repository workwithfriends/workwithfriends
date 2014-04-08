//
//  FriendsTableViewController.h
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewController : UITableViewController

{
    NSArray *friends;
    NSMutableArray *friendStringList;
    NSInteger *rowSelected;
}
- (NSInteger*) rowSelected;
- (void) setRowSelected:(NSInteger *) row;
@end
