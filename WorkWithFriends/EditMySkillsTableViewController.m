//
//  EditMySkillsTableViewController.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "EditMySkillsTableViewController.h"

@implementation EditMySkillsTableViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *) skillsStringList{
    return skillsStringList;
}
- (NSMutableArray *) skillsStrengthsList{
    return skillsStrengthsList;
}
- (void) setSkillsStringList: (NSMutableArray *)stringList{
    skillsStringList=stringList;
}
- (void) setSkillsStrengthsList: (NSMutableArray *)stringList{
    skillsStrengthsList=stringList;
}
- (NSInteger *) rowSelected{
    return rowSelected;
}
- (void) setRowSelected: (NSInteger *)rowNumber{
    rowSelected=rowNumber;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    GlobalVariables *globals = [GlobalVariables sharedInstance];
    NSArray *mySkills = [globals.ME objectForKey:@"skills"];
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
        self.skillsStringList=[NSMutableArray arrayWithArray:skillsStrings];
        self.skillsStrengthsList=[NSMutableArray arrayWithArray:skillsStrengths];
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
    static NSString *MyIdentifier = @"editSkillCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    // Configure the cell
    NSString *theSkillString = [self.skillsStringList objectAtIndex:indexPath.row];
    NSString *theSkillStrength = [self.skillsStrengthsList objectAtIndex:indexPath.row];
    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(20, 22, 140, 20)];
    labelTwo = [[UILabel alloc]initWithFrame:CGRectMake(100, 22, 100, 20)];
    
    labelOne.text = theSkillString;
    labelTwo.textAlignment = UITextAlignmentRight;
    labelTwo.text = theSkillStrength;
    labelTwo.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    labelTwo.tag=456;
    stepper = [[UIStepper alloc] init];
    stepper.frame = CGRectMake(220, 10, 160, 10);
    stepper.value=[labelTwo.text intValue];
    [stepper addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
    [cell.contentView addSubview: stepper];
    [cell.contentView addSubview:labelOne];
    [cell.contentView addSubview:labelTwo];
    [cell.contentView setTag:indexPath.row];
    return cell;
}

// Override to support editing the table view.


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        [self.skillsStrengthsList removeObjectAtIndex:indexPath.row];
        [self.skillsStringList removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData]; // tell table to refresh now
    }
}
/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.rowSelected=(NSInteger *)indexPath.row;
    //[self.tableHolder performSegueJobs];
}

- (void)changeValue:(UIStepper *)sender {
    double value = [sender value];
    int row = [sender.superview tag];
    NSString *newValue=[NSString stringWithFormat:@"%d",(int)value];
    self.skillsStrengthsList[row]=newValue;
    [(UILabel*)[(UITableViewCell *)sender.superview viewWithTag:456] setText:newValue];

}
@end
