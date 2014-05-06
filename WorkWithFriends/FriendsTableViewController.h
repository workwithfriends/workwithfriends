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
    NSMutableDictionary *friendPictures;
    NSInteger *friendSelected;
    NSMutableDictionary *friendToID;
}
- (NSInteger*) friendSelected;
- (NSMutableDictionary *) friendPictures;
- (NSArray *) friendStringListSorted;
- (void) setFriendPictures:(NSMutableDictionary *) pictures;
- (void) setFriendSelected:(NSInteger *) friend;

@end
