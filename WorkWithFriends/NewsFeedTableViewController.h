//
//  NewsFeedTableViewController.h
//  WorkWithFriends
//
//  Created by LUIS SANMIGUEL on 4/7/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFeedTableViewController : UITableViewController
{
    NSArray *newsfeedItems;
    NSMutableArray *newsfeedItemsStringList;
    NSInteger *rowSelected;
    NSMutableArray *newsfeedPictures;
}
- (NSInteger*) rowSelected;
- (void) setRowSelected:(NSInteger *) row;
-(void)refresh;
@end