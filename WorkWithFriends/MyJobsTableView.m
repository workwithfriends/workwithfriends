//
//  MyJobsTableView.m
//  WorkWithFriends
//
//  Created by Jeremy Wohlwend on 4/8/14.
//  Copyright (c) 2014 Jeremy Wohlwend. All rights reserved.
//

#import "MyJobsTableView.h"

@implementation MyJobsTableView

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (NSArray *) jobStringList{
    return jobStringList;
}
- (NSInteger *) sectionLength{
    return sectionLength;
}
- (void) setJobStringList: (NSArray *)stringList{
    jobStringList=stringList;
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
    NSArray *myCurrentJobsAsEmployer = [[globals.ME objectForKey:@"jobs"] objectForKey:@"currentJobsAsEmployer"];
    NSArray *myCurrentJobsAsEmployee = [[globals.ME objectForKey:@"jobs"] objectForKey:@"currentJobsAsEmployee"];
    NSArray *myCompletedJobs = [[globals.ME objectForKey:@"jobs"] objectForKey:@"completedJobs"];
    NSArray *myPostedJobs= [[globals.ME objectForKey:@"jobs"] objectForKey:@"postedJobs"];
    NSMutableArray *theJobStringList = [[NSMutableArray alloc] init];
    if (myCurrentJobsAsEmployer != [NSNull null]){
        for(int i=0; i < [myCurrentJobsAsEmployer count];i++){
            NSString *jobString=[NSString stringWithFormat: @"You hired %@ as a %@", [[myCurrentJobsAsEmployer objectAtIndex: i] valueForKey:@"employeeFirstName"], [[myCurrentJobsAsEmployer objectAtIndex: i] valueForKey:@"type"]];
            [theJobStringList addObject:jobString];
        }
        self.sectionLength[0]=[myCurrentJobsAsEmployer count];
    }
    if (myCurrentJobsAsEmployee != [NSNull null]){
        for(NSDictionary *job in myCurrentJobsAsEmployee){
            NSString *jobString=[NSString stringWithFormat: @"%@ hired you as a %@ !", [job valueForKey:@"employerFirstName"], [job valueForKey:@"type"]];
            [theJobStringList addObject:jobString];
        }
        self.sectionLength[1]=[myCurrentJobsAsEmployee count];
    }
    if (myPostedJobs != [NSNull null]){
        for(NSDictionary *job in myPostedJobs){
            NSString *jobString=[NSString stringWithFormat: @"You need a %@ who's good at %@", [job valueForKey:@"type"], [[job valueForKey:@"skills"] objectAtIndex:0]];
            NSLog(@"%@",jobString);
            [theJobStringList addObject:jobString];
        }
        self.sectionLength[2]=[myPostedJobs count];
    }
    if (myCompletedJobs != [NSNull null]){
        for(NSDictionary *job in myCompletedJobs){
            NSString *jobString=[NSString stringWithFormat: @"You have completed a job for %@", [job valueForKey:@"employerFirstName"]];
            [theJobStringList addObject:jobString];
        }
        self.sectionLength[3]=[myCompletedJobs count];
    }
    self.jobStringList=[NSArray arrayWithArray:theJobStringList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"jobCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    // Configure the cell
    NSString *cellValue = [self.jobStringList objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0)
        return @"Current jobs as employer";
    else if(section==1)
        return @"Current jobs as employee";
    else if(section==2)
        return @"My posted jobs";
    else if(section==3)
        return @"Completed jobs";
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sectionLength[section];
}

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

@end
