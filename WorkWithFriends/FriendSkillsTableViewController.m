//
//  FriendSkillsTableViewController.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 5/6/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "FriendSkillsTableViewController.h"

@interface FriendSkillsTableViewController ()

@end

@implementation FriendSkillsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (NSArray *) skillsStringList{
    return skillsStringList;
}
- (NSArray *) skillsStrengthsList{
    return skillsStrengthsList;
}
- (void) setSkillsStringList: (NSArray *)stringList{
    skillsStringList=stringList;
}
- (void) setSkillsStrengthsList: (NSArray *)stringList{
    skillsStrengthsList=stringList;
}
- (NSInteger *) rowSelected{
    return rowSelected;
}
- (void) setRowSelected: (NSInteger *)rowNumber{
    rowSelected=rowNumber;
}

- (void) setFriend: (NSDictionary *)theFriend{
    friend=theFriend;
}
-(NSDictionary *) friend{
    return friend;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *mySkills = [self.friend objectForKey:@"friendSkills"];
    NSMutableArray *skillsStrings = [[NSMutableArray alloc] init];
    NSMutableArray *skillsStrengths = [[NSMutableArray alloc] init];
    self.skillsStringList=[[NSArray alloc]init];
    if (mySkills != [NSNull null]){
        for (NSDictionary *skill in mySkills){
            NSString *skillString = [skill valueForKey:@"skill"];
            NSString *skillStrength =[skill valueForKey:@"strength"];
            [skillsStrings addObject:skillString];
            [skillsStrengths addObject:skillStrength];
        }
        self.skillsStringList=[NSArray arrayWithArray:skillsStrings];
        self.skillsStrengthsList=[NSArray arrayWithArray:skillsStrengths];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.skillsStringList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"friendSkillCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = [[UITableViewCell alloc]
            initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    // Configure the cell
    NSString *theSkillString = [self.skillsStringList objectAtIndex:indexPath.row];
    NSString *theSkillStrength = [self.skillsStrengthsList objectAtIndex:indexPath.row];
    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(20, 22, 140, 20)];
    UILabel *labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(160, 22, 140, 20)];
    
    labelOne.text = theSkillString;
    labelTwo.textAlignment = UITextAlignmentRight;
    labelTwo.text = theSkillStrength;
    labelTwo.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    [cell.contentView addSubview:labelOne];
    [cell.contentView addSubview:labelTwo];
    return cell;
}



/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowSelected=(NSInteger *)indexPath.row;
    //[self.tableHolder performSegueJobs];
}

@end
