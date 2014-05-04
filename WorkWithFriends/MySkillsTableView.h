//
//  MySkillsTableView.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"
#import "JobFormViewController.h"

@interface MySkillsTableView : UITableViewController{
    NSArray *skillsStringList;
    NSInteger *rowSelected;
    
}
- (NSArray *) skillsStringList;
- (void) setSkillsStringList: (NSArray *)stringList;
- (NSInteger *) rowSelected;
- (void) setRowSelected: (NSInteger *)rowNumber;
@end
