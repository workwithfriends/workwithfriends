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
    NSArray *friendStringListSorted;
    NSMutableArray *friendStringList;
    NSMutableDictionary *friendPictures;
    NSInteger *rowSelected;
}
- (NSInteger*) rowSelected;
- (NSMutableDictionary *) friendPictures;
- (NSArray *) friendStringListSorted;
- (NSArray *) friendStringList;
- (void) setFriendPictures:(NSMutableDictionary *) pictures;
- (void) setRowSelected:(NSInteger *) row;

@end
