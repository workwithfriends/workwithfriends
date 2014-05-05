//
//  EditMySkillsTableViewController.h
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"
#import "JobFormViewController.h"

@interface EditMySkillsTableViewController : UITableViewController{
    NSArray *skillsStringList;
    NSMutableArray *skillsStrengthsList;
    NSInteger *rowSelected;
    UILabel *labelTwo;
    UIStepper *stepper;
    
}
- (void)changeValue:(UIStepper *)sender;
- (NSArray *) skillsStringList;
- (void) setSkillsStringList: (NSArray *)stringList;
- (NSMutableArray *) skillsStrengthsList;
- (void) setSkillsStrengthsList: (NSMutableArray *)stringList;
- (NSInteger *) rowSelected;
- (void) setRowSelected: (NSInteger *)rowNumber;
@end
